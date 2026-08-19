# Installing Claude Switchboard

How to install and run Claude Switchboard on a machine. Do this on each Mac where you want
it (yours or a colleague's).

**Two of these steps a person has to do**, because macOS won't let software grant itself
permissions or click menu-bar items: granting Accessibility (step 2), and looking at the
screen to confirm the panel appeared (step 5). Everything else can be done for you — see
*[Let Claude Code install it](README.md#let-claude-code-install-it)*.

## Requirements

- macOS (built and used on an Intel Mac; should work on Apple Silicon too).
- [Hammerspoon](https://www.hammerspoon.org) — free, open‑source, notarized.
  **No SIP changes required.**
- `git`, for the git dot. Any Xcode Command Line Tools install provides it.
- **Nothing else.** The hook needs no `jq` and no other tool as of `v56`; it uses `awk` and
  bash, both of which macOS ships. (Before that it needed `jq` and failed *silently* without
  it — if you are running an older copy, that is why your red dot never lights.)

**Which terminal you run `claude` in matters, but less than it used to.** Sessions get a
**Desktop line** from **Terminal.app and iTerm2** — the two whose AppleScript reports windows
for Spaces you are not looking at, which is what placing a session on a Desktop requires. A
session in Ghostty, kitty or Cursor's built-in terminal still appears in the **`T#` sessions
list**, drawn from its hook state file — project, dot, question, and which terminal it is in
— but with no Desktop attached. That half needs the hook installed (see *Optional: the red
dot*, below); everything else on the panel works regardless.

## Steps

1. **Install Hammerspoon**

   ```sh
   brew install --cask hammerspoon
   ```

   (or download from https://www.hammerspoon.org). Launch it once.

2. **Grant Accessibility permission** — 🧑 **you must do this yourself.** macOS deliberately
   prevents software from granting this on its own. System Settings → Privacy & Security →
   Accessibility → enable **Hammerspoon**. This is what lets the tool read window titles; it
   is a normal per‑app permission (the same one Rectangle, Moom, etc. use) and is *not*
   related to disabling SIP.

   The reliable test is step 5: without this permission the panel still loads and lists your
   Desktops, but every label comes out blank or `—`.

3. **Clone the repo** — put it wherever you keep your projects. From that folder:

   ```sh
   git clone https://github.com/pcornillon/claude-switchboard.git
   ```

   `git clone` creates the `claude-switchboard` folder itself, so there's no destination to
   name. Put it anywhere — step 4 works out where it landed, and where you keep repos,
   without being told.

4. **Wire it up.** From the repo you just cloned:

   ```sh
   ./install.sh
   ```

   It works out both paths itself — the repo's, from where the script sits, and where you
   keep repositories, from the repo's parent — writes them into `~/.hammerspoon/init.lua`,
   and restarts Hammerspoon. It asks nothing and prints what it did:

   ```
   repo:   /Users/you/Git_Repos/claude-switchboard
   repos:  /Users/you/Git_Repos
   target: /Users/you/.hammerspoon/init.lua

   OK   Hammerspoon is installed
   WRITE created /Users/you/.hammerspoon/init.lua with the claude-switchboard block

   restarted Hammerspoon
   ```

   Two options, if you want them:

   ```sh
   ./install.sh --repos ~/work/repos --repos ~/Dropbox/projects   # repos live elsewhere
   ./install.sh --no-ipc                                          # skip the shell bridge
   ```

   `--repos` matters only if you keep repositories somewhere other than the folder this
   repo sits in. The shell bridge is `require("hs.ipc")` and `_G.dd = dd`, written into
   the block by default: it lets you ask the running panel questions — `hs -c "return
   dd.version"` — and `--no-ipc` leaves it out.

5. **Updating an earlier install: `~/.hammerspoon/init.lua` may need replacing.**

   **An `init.lua` you already had is kept.** Hotkeys, window rules, anything of yours:
   step 4 puts its block below them, after a backup. The block sits between two markers,
   so running the script again replaces that block rather than adding a second copy —
   which is what makes it safe to re-run after a `git pull`, or after moving the repo.

   **The one case where step 4 stops rather than writes** is an `init.lua` that already
   loads this panel from an install done by hand. Rather than set `package.path` twice
   and start the panel twice, it lists those lines and does nothing else.

   - **Skip the rest of this step if you have never installed claude-switchboard before.**
   - **Skip it if you have never edited `~/.hammerspoon/init.lua` yourself.**

   Anyone still here: one command replaces those lines.

   ```sh
   ./install.sh --upgrade
   ```

   It backs your `init.lua` up to `init.lua.pre-switchboard.bak`, prints every line it
   removes, and writes the block in their place. **Only the old install is removed** —
   loader lines, and comments sitting against them. Hotkeys, window rules and anything
   else you keep in that file stay exactly where they are.

6. **Look at the screen.** 🧑 This part is yours: the panel is an on-screen overlay, and a
   script cannot see it.

   The panel should be in a corner, and the Hammerspoon Console should say
   `desktop_dashboard vNN … loaded`.

   **If every Desktop label is blank or `—`**, Hammerspoon does not have Accessibility
   permission — go back to step 2. That is the one failure that looks like a bug and is
   not.

   You can also ask the running panel directly, which is a stronger check than reading the
   file — it answers only if the code really loaded:

   ```sh
   hs -c "return dd.version"
   ```

   To ask later whether this machine is still wired up, without changing anything:

   ```sh
   ./install.sh --check
   ```

## Optional: the red dot (Claude Code hooks)

The yellow and green dots work out of the box. **Red** — "this session is asking you
something" — needs Claude Code to tell us, because a session blocked on a question puts
exactly the same thing in its terminal title as one that has finished.

**Nothing here is manual.** One command, from the repo, and it does the whole job:

```sh
./install.sh --hooks
```

It copies `claude-dashboard-state.sh` to `~/.claude/`, then registers it on five Claude
Code events in `~/.claude/settings.json`. That file usually holds your permissions and
whatever hooks you already run, so it is **merged, never replaced**: the script backs it
up to `settings.json.pre-switchboard.bak`, adds its five entries alongside anything
already there, and refuses to touch the file at all if it does not already parse as JSON.
It writes to a temporary file and parses that before moving it into place — malformed
JSON there silently disables *every* setting in the file, permissions and all, with no
error anywhere.

Run it twice and the second run reports `the red-dot hook is already registered (5
event(s)) — nothing added`. If `~/.claude/settings.json` is a symlink — to a configuration
repo, or a synced folder — it says so and names the file it is really editing.

**The five events are not interchangeable.** `SessionStart` is the one people leave off by
hand, and it is the one that makes a session visible before you have typed anything:
without it, a session in a terminal the panel cannot read directly — Ghostty, kitty,
Cursor — appears nowhere until your first prompt.

**One thing the script cannot do for you:** Claude Code reads its hook configuration when
a session starts, so sessions already running will not have it. Start a new one.

**Check it:** `ls ~/.hammerspoon/claude_state/` should show one JSON file per live session
as soon as that session starts. If nothing appears, open `/hooks` in Claude Code once
(that reloads the configuration) or restart the session.

The script writes only to `~/.hammerspoon/claude_state/`, exits 0 unconditionally, and
does nothing at all on a machine with no `~/.hammerspoon` — so these settings are safe to
sync across machines.

## Doing step 4 by hand

`install.sh` writes this into `~/.hammerspoon/init.lua`, and nothing else:

```lua
-- >>> claude-switchboard >>>
package.path = package.path .. ";" .. "/absolute/path/to/claude-switchboard/?.lua"
require("hs.ipc")                       -- omitted with --no-ipc
local dd = require("desktop_dashboard")
_G.dd = dd                              -- omitted with --no-ipc
dd.repoRoots = {
  "/absolute/path/to/where/you/keep/repos",
}
dd.start()
-- <<< claude-switchboard <<<
```

Write it yourself if you prefer; `init.lua.example` is the same thing with its reasoning.
Two things to know if you go this way:

- **`dd.repoRoots` is why `desktop_dashboard.lua` never needs editing.** It overrides the
  `~/Git_Repos` default in the module, after `require` and before `dd.start()`, so a
  `git pull` cannot conflict with your own configuration.
- **An old copy at `~/.hammerspoon/desktop_dashboard.lua` wins over the repo**, because
  `require` looks there first. Move it aside. `install.sh` does this for you and says so.

Reload Hammerspoon afterwards — the menu-bar hammer → **Reload Config**, or from a shell:

```sh
osascript -e 'quit app "Hammerspoon"'; /bin/sleep 3; open -a Hammerspoon
```

(`/bin/sleep` rather than plain `sleep` — some agent setups block the latter.)


## First run

Press **⌘⌃⌥s** once to walk every Desktop and label them all. After that it keeps itself
up to date on its own.

## Testing

A scripted way to watch all three dot colors happen on cue.

**Set up:** open a terminal on a Desktop of its own, `cd` into a repo under your
`M.repoRoots`, and start `claude` there. Confirm that Desktop's line shows the repo name.
Then **switch to a different Desktop** and keep the panel in view — the point is watching a
session you can't see. Paste the prompt below into that session.

````text
I am testing a status dashboard that watches Claude Code sessions. This is a scripted
rehearsal, not real work.

Follow these steps exactly, in order. Do nothing else: no file reads, no searches, no
extra commands, no summarising between steps.

STEP 1 — wait 30 seconds by running exactly this, and let it finish:
    for i in $(seq 1 30); do /bin/sleep 1; done

STEP 2 — ask me a single multiple-choice question using your question tool. The subject
does not matter; my answer does not matter. Wait for my answer.

STEP 3 — wait 30 seconds again by running exactly this:
    for i in $(seq 1 30); do /bin/sleep 1; done

STEP 4 — run exactly this command, which is meant to require my approval:
    touch /tmp/dashboard-test.txt && rm /tmp/dashboard-test.txt
If it runs without asking my permission, tell me so and stop.

STEP 5 — wait 20 seconds by running exactly this:
    for i in $(seq 1 20); do /bin/sleep 1; done

Then reply with exactly: done

The waits are the thing being measured, so do not shorten or skip them.
````

**What you should see on that Desktop's line:**

| when | dot |
|------|-----|
| Step 1, during the wait | 🟡 yellow — computing |
| Step 2, question on screen | 🔴 red — waiting on you |
| after you answer | 🟡 yellow — resumed |
| Step 4, permission prompt | 🔴 red — waiting on you |
| after you approve or deny | 🟡 yellow — resumed |
| after `done` | 🟢 green — finished, unseen |
| when you switch to that Desktop | *(no dot)* — acknowledged |

Notes:

- **Steps 2 and 4 test different things.** A question box and a permission prompt are
  separate mechanisms; both should turn the dot red.
- **Step 4 assumes `rm` needs approval on your setup.** If your `permissions` settings
  auto-allow it, substitute any command yours does ask about.
- **Red only appears if the hooks are installed** (previous section). Without them steps 2
  and 4 show green instead of red; everything else is the same.
- If the dot never appears at all, the Desktop probably isn't labeled with the repo name —
  press ⌘⌃⌥s and check the line reads the repo, not `Utility` or an app name.

## Configuration

Everything is in the `CONFIG` block at the top of `desktop_dashboard.lua`. The one that
matters on a new machine, `M.repoRoots`, is already handled: `install.sh` writes it into
`~/.hammerspoon/init.lua` as `dd.repoRoots`, which overrides the default without editing a
tracked file. Re-run `./install.sh --repos DIR` to change it. The rest — `M.categories`,
`M.docApps` and the like — are edited in `desktop_dashboard.lua` itself; see the
Configuration section of `README.md` for the full list.

## Troubleshooting

- **No panel / everything blank:** confirm Accessibility is enabled for Hammerspoon
  (step 2), then Reload Config.
- **Wrong version in the Console (or old behavior):** an old copy is shadowing the repo —
  remove `~/.hammerspoon/desktop_dashboard.lua` (step 4 note) and reload.
- **A Desktop won't label until you visit it:** expected — macOS only lets an app read a
  Desktop's windows while it's active. Press ⌘⌃⌥s to fill them all in.
