#!/usr/bin/env bash
# install.sh — wire claude-switchboard into Hammerspoon, and optionally into Claude Code.
#
# Everything this script needs, it works out. The repo's location comes from where this
# file sits; the folder you keep repos in defaults to the repo's parent. Nothing is
# typed, and nothing outside ~/.hammerspoon (and, with --hooks, ~/.claude) is touched.
#
#     ./install.sh                 wire it up, then restart Hammerspoon
#     ./install.sh --check         report what is wired; change nothing
#     ./install.sh --repos DIR     where your repos live (repeatable; default: repo's parent)
#     ./install.sh --hooks         also register the red-dot hooks with Claude Code
#     ./install.sh --no-reload     leave Hammerspoon alone; reload it yourself
#     ./install.sh --no-ipc        leave out the command-line bridge (see below)
#     ./install.sh --upgrade       replace an older by-hand install in init.lua
#
# WHY A MARKED BLOCK. What goes into ~/.hammerspoon/init.lua sits between two comment
# markers, so a second run REPLACES it rather than appending a second copy. That is what
# makes the script safe to re-run after a `git pull`, after moving the repo, or after
# changing --repos. Anything you wrote in init.lua yourself is outside the markers and is
# never read, moved or rewritten.
#
# WHY repoRoots IS SET HERE. `M.repoRoots` in desktop_dashboard.lua defaults to
# ~/Git_Repos. Setting `dd.repoRoots` in init.lua overrides it after `require` and before
# `dd.start()`, which means the tracked .lua file never has to be edited — so `git pull`
# never conflicts with your own configuration.

set -uo pipefail

REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
HS_DIR="$HOME/.hammerspoon"
INIT="$HS_DIR/init.lua"
STALE="$HS_DIR/desktop_dashboard.lua"
MARK_A="-- >>> claude-switchboard >>>"
MARK_B="-- <<< claude-switchboard <<<"

CHECK_ONLY=0; DO_HOOKS=0; RELOAD=1; IPC=1; UPGRADE=0; REPO_ROOTS=()
while [ $# -gt 0 ]; do
  case "$1" in
    --check)     CHECK_ONLY=1; shift ;;
    --hooks)     DO_HOOKS=1; shift ;;
    --no-reload) RELOAD=0; shift ;;
    --no-ipc)    IPC=0; shift ;;
    --upgrade)   UPGRADE=1; shift ;;
    --repos)     REPO_ROOTS+=("${2:?--repos needs a directory}"); shift 2 ;;
    -h|--help)   sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done
[ ${#REPO_ROOTS[@]} -eq 0 ] && REPO_ROOTS=("$(dirname "$REPO")")

grn() { printf '\033[32m%s\033[0m\n' "$*"; }
ylw() { printf '\033[33m%s\033[0m\n' "$*"; }
red() { printf '\033[31m%s\033[0m\n' "$*"; }

[ -f "$REPO/desktop_dashboard.lua" ] || {
  red "STOP $REPO/desktop_dashboard.lua is missing — is this the repo?"; exit 1; }

echo "repo:   $REPO"
echo "repos:  ${REPO_ROOTS[*]}"
echo "target: $INIT"
echo

# ---------------------------------------------------------------------------
# The block, built from the paths above. Absolute, so it does not care what the
# working directory or $HOME happen to be when Hammerspoon loads it.
# ---------------------------------------------------------------------------
roots_lua=""
for r in "${REPO_ROOTS[@]}"; do
  r=$(cd "$r" 2>/dev/null && pwd) || { red "STOP no such directory: $r"; exit 1; }
  roots_lua="$roots_lua  \"$r\",
"
done

ipc_lua=""
[ "$IPC" -eq 1 ] && ipc_lua="-- Command-line bridge: hs -c \"return dd.version\"  (--no-ipc to leave it out)
require(\"hs.ipc\")
"

BLOCK="$MARK_A
-- Written by claude-switchboard/install.sh. Edit above or below this block, not
-- inside it: a re-run replaces everything between the markers.
package.path = package.path .. \";\" .. \"$REPO/?.lua\"
${ipc_lua}local dd = require(\"desktop_dashboard\")"
[ "$IPC" -eq 1 ] && BLOCK="$BLOCK
_G.dd = dd"
BLOCK="$BLOCK
dd.repoRoots = {
$roots_lua}
dd.start()
$MARK_B"

# ---------------------------------------------------------------------------
# Hammerspoon itself. A warning, not a failure: wiring it up before installing
# Hammerspoon is a perfectly reasonable order to do things in.
# ---------------------------------------------------------------------------
if [ -d /Applications/Hammerspoon.app ] || [ -d "$HOME/Applications/Hammerspoon.app" ]; then
  grn "OK   Hammerspoon is installed"
else
  ylw "WARN Hammerspoon is not installed — the panel cannot run without it"
  ylw "     install: brew install --cask hammerspoon    then launch it once"
fi

# ---------------------------------------------------------------------------
# --check: report and exit. Never writes.
# ---------------------------------------------------------------------------
if [ "$CHECK_ONLY" -eq 1 ]; then
  fail=0
  if [ ! -f "$INIT" ]; then
    ylw "MISS $INIT does not exist"; fail=1
  elif ! grep -qF -- "$MARK_A" "$INIT"; then
    ylw "MISS $INIT has no claude-switchboard block"; fail=1
  else
    grn "OK   $INIT has the claude-switchboard block"
    if grep -qF -- "\"$REPO/?.lua\"" "$INIT"; then
      grn "OK   the block points at this checkout"
    else
      ylw "DIFF the block points somewhere else — re-run ./install.sh to repoint it"; fail=1
    fi
  fi
  [ -e "$STALE" ] && { ylw "DIFF a stale $STALE would be loaded instead of the repo"; fail=1; }
  if [ -f "$INIT" ] && python3 -c 'import re,sys
body=open(sys.argv[1],encoding="utf-8").read()
rest=re.sub(re.escape(sys.argv[2])+r".*?"+re.escape(sys.argv[3]),"",body,flags=re.S)
sys.exit(0 if "desktop_dashboard" in rest else 1)' "$INIT" "$MARK_A" "$MARK_B"; then
    ylw "DIFF $INIT loads desktop_dashboard outside the markers too — dd.start() would run twice"
    fail=1
  fi
  if [ -f "$HOME/.claude/settings.json" ] &&
     grep -q "claude-dashboard-state.sh" "$HOME/.claude/settings.json" 2>/dev/null; then
    grn "OK   the red-dot hook is registered with Claude Code"
  else
    ylw "note the red-dot hook is not registered (optional — ./install.sh --hooks)"
  fi
  echo
  [ "$fail" -eq 0 ] && grn "check: Hammerspoon is wired to this checkout" \
                    || ylw "check: NOT fully wired (see MISS/DIFF above)"
  exit "$fail"
fi

# ---------------------------------------------------------------------------
# A stale copy in ~/.hammerspoon wins over the repo, because `require` searches
# there first. Move it aside rather than delete it — it is someone's file.
# ---------------------------------------------------------------------------
if [ -e "$STALE" ]; then
  mv "$STALE" "$STALE.stale.bak" && \
    ylw "note moved an older $STALE aside -> $(basename "$STALE").stale.bak"
fi

# ---------------------------------------------------------------------------
# Write the block: create, replace between the markers, or append.
# ---------------------------------------------------------------------------
mkdir -p "$HS_DIR" 2>/dev/null
export BLOCK MARK_A MARK_B INIT UPGRADE
python3 - <<'PY'
import os, re, shutil

init, block = os.environ["INIT"], os.environ["BLOCK"]
a, b = os.environ["MARK_A"], os.environ["MARK_B"]

body = open(init, encoding="utf-8").read() if os.path.exists(init) else ""

# An empty or whitespace-only file is not "someone's config to append to" — it is a
# blank sheet, and appending to it leaves stray blank lines at the top.
def write_fresh():
    open(init, "w").write(block + "\n")
    print("WRITE wrote %s with the claude-switchboard block" % init)

if not body.strip():
    write_fresh()
    raise SystemExit(0)

# A hand-written loader from an earlier install would run alongside ours: package.path
# set twice, dd.start() called twice. Refuse rather than quietly double it.
outside = re.sub(re.escape(a) + r".*?" + re.escape(b), "", body, flags=re.S)

bak = init + ".pre-switchboard.bak"
if "desktop_dashboard" in outside and not os.environ.get("SWITCHBOARD_FORCE"):
    if os.environ.get("UPGRADE") != "1":
        print("STOP  %s already loads desktop_dashboard outside our markers:" % init)
        for line in outside.splitlines():
            if "desktop_dashboard" in line:
                print("        %s" % line.strip())
        print("      That is an earlier install by hand. Re-run with --upgrade to replace it")
        print("      (your file is backed up first), or delete those lines yourself.")
        print("      SWITCHBOARD_FORCE=1 adds ours alongside, which starts the panel twice.")
        raise SystemExit(1)

    # --upgrade: take out the by-hand install, and only that. A line goes if it is
    # loader code or a comment naming this tool; anything else in the file is left
    # exactly where it is.
    OWN = ("desktop_dashboard", "desktop dashboard", "claude-switchboard",
           "claude switchboard", "hs.ipc", "dd.version", "dd.start()", "_g.dd",
           "reporoots")
    if not os.path.exists(bak):
        shutil.copy2(init, bak)
        print("note  backed up your init.lua -> %s" % os.path.basename(bak))

    src = body.splitlines()
    drop = set(i for i, ln in enumerate(src) if any(t in ln.lower() for t in OWN))
    # A comment sitting against a dropped line belongs to it — "-- Load Claude
    # Switchboard from its repo" names nothing this list matches, and leaving it
    # behind is how an upgrade ends up looking like a botch.
    grew = True
    while grew:
        grew = False
        for i, ln in enumerate(src):
            if i in drop or not ln.strip().startswith("--"):
                continue
            if (i - 1) in drop or (i + 1) in drop:
                drop.add(i); grew = True

    for i in sorted(drop):
        print("       - %s" % src[i].strip())
    print("WRITE removed %d line(s) of by-hand install" % len(drop))

    kept, blanks = [], 0
    for i, ln in enumerate(src):
        if i in drop:
            continue
        blanks = blanks + 1 if not ln.strip() else 0
        if blanks < 2:                       # no runs of blank lines where it was
            kept.append(ln)
    body = "\n".join(kept).strip("\n")
    outside = body

if not os.path.exists(bak):
    shutil.copy2(init, bak)
    print("note  backed up your init.lua -> %s" % os.path.basename(bak))

if not body.strip():                  # --upgrade emptied it
    write_fresh()
    raise SystemExit(0)

pat = re.compile(re.escape(a) + r".*?" + re.escape(b), re.S)
if pat.search(body):
    open(init, "w").write(pat.sub(lambda _: block, body, count=1))
    print("WRITE replaced the existing claude-switchboard block")
else:
    sep = "" if body.endswith("\n") else "\n"
    open(init, "w").write(body + sep + "\n" + block + "\n")
    print("WRITE appended the claude-switchboard block; your own config is untouched")
PY
[ $? -eq 0 ] || exit 1          # it refused; do not go on to reload or register hooks

# ---------------------------------------------------------------------------
# --hooks: the red dot. Five events in ~/.claude/settings.json, merged into
# whatever is already there. Never replaces the file, and validates before it
# moves anything into place: malformed JSON there disables every setting in it,
# permissions and all, with no error anywhere.
# ---------------------------------------------------------------------------
if [ "$DO_HOOKS" -eq 1 ]; then
  echo
  HOOK_SRC="$REPO/claude-dashboard-state.sh"
  HOOK_DST="$HOME/.claude/claude-dashboard-state.sh"
  [ -f "$HOOK_SRC" ] || { red "STOP $HOOK_SRC is missing"; exit 1; }
  mkdir -p "$HOME/.claude" 2>/dev/null
  cp "$HOOK_SRC" "$HOOK_DST" && chmod +x "$HOOK_DST" && grn "OK   installed $HOOK_DST"

  export HOOK_DST
  python3 - <<'PY'
import json, os, shutil, sys

path = os.path.expanduser("~/.claude/settings.json")
hook = os.environ["HOOK_DST"].replace(os.path.expanduser("~"), "$HOME", 1)
real = os.path.realpath(path) if os.path.exists(path) else path
if os.path.islink(path):
    print("note  %s is a symlink -> %s; that is the file being edited" % (path, real))

data = {}
if os.path.exists(path):
    try:
        data = json.load(open(path, encoding="utf-8"))
    except Exception as e:
        print("STOP  %s is not valid JSON (%s) — refusing to touch it" % (path, e))
        raise SystemExit(1)

hooks = data.setdefault("hooks", {})
already = json.dumps(hooks).count("claude-dashboard-state.sh")
if already:
    print("OK    the red-dot hook is already registered (%d event(s)) — nothing added" % already)
    raise SystemExit(0)

for event, state in (("UserPromptSubmit", "working"), ("Notification", "waiting"),
                     ("Stop", "done"), ("SessionEnd", "gone"), ("SessionStart", "idle")):
    entry = {"hooks": [{"type": "command", "async": True, "timeout": 5,
                        "command": 'bash "%s" %s' % (hook, state)}]}
    hooks.setdefault(event, []).append(entry)

if os.path.exists(real):
    shutil.copy2(real, real + ".pre-switchboard.bak")
    print("note  backed up %s" % os.path.basename(real + ".pre-switchboard.bak"))

tmp = real + ".tmp"
open(tmp, "w", encoding="utf-8").write(json.dumps(data, indent=2) + "\n")
json.load(open(tmp, encoding="utf-8"))          # parse it before it goes live
os.replace(tmp, real)
print("WRITE registered the red-dot hook on five events")
PY
  [ $? -eq 0 ] || exit 1        # unparseable settings.json; stop rather than reload
fi

# ---------------------------------------------------------------------------
# Hammerspoon reads init.lua at load, so the change means nothing until it
# reloads. Restarting from the shell is the same thing as the menu-bar item,
# and works when there is no menu bar to click (over ssh, or from an agent).
# ---------------------------------------------------------------------------
echo
if [ "$RELOAD" -eq 1 ]; then
  osascript -e 'quit app "Hammerspoon"' >/dev/null 2>&1
  /bin/sleep 3
  open -a Hammerspoon >/dev/null 2>&1 && grn "restarted Hammerspoon" \
    || ylw "could not restart Hammerspoon — launch it yourself"
else
  ylw "not reloading. Click the Hammerspoon menu-bar hammer -> Reload Config."
fi

cat <<'EOF'

Then look at the screen: the panel should be in a corner, and the Hammerspoon
Console should say "desktop_dashboard vNN … loaded".

If every Desktop label is blank or "—", Hammerspoon does not have Accessibility
permission: System Settings -> Privacy & Security -> Accessibility -> enable
Hammerspoon. macOS will not let any script grant that.
EOF
