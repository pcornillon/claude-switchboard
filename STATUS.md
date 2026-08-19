# STATUS.md — `claude-switchboard`

Living snapshot of where this project stands. Rewritten, not appended.
Last updated: **2026-08-18 17:40 EDT** (`cornillon-laptop`) — `install.sh`, D93.
Before that, 2026-08-12 22:30 EDT — `v65`, the yellow dot restored.

---

## State

- **The tool is at `v65`, in daily use, and everything since `v52` has now been run.**
  `M.version` reads `"v65 (the spinner is read by exclusion — Claude Code changed it and the
  yellow dot died, 2026-08-12)"`.
  `v51` before it was the **merge of two machines' parallel work**. One file.
- **`v53` fixed two connected naming faults, both found from the laptop on 2026-08-05.**
  `M.docApps` listed `["MacDown 3000"]` and the app is called **`MacDown`** — so no MacDown
  window was ever asked for its document and **D75**'s first rule could not fire for the
  editor Peter reads every `.md` in. Wrong since the first commit; invisible until D75 made
  a document the only evidence (Task **#8**). And the per-Desktop ⌘⌃⌥N override is **gone**:
  ⌘⌃⌥N now renames a **project** on every line, so the name follows the work and leaves a
  Desktop when the work does (**D76**, Task **#9**). **Both are now verified live** — see the
  active thread for what was measured.
- **The last functional change was today**, and it was a repair. Every dot on the panel had
  gone dead: `hs.task` deadlocks on more than ~512 bytes of output unless a streaming
  callback drains the pipe, which took out four of the six subprocess reads at once, and
  the in-flight guards above them stayed pinned — one child ran 5 h 21 min. Neither ⌘⌃⌥S
  nor a Hammerspoon restart could clear it. Fixed by routing every read through one
  `runTask` helper that streams and times out (**D65**, Task **#4**). That fix then
  **truncated** the session list — `hs.task` splits its output between its two callbacks and
  drops any chunk ending inside a multi-byte character — so `runTask` now captures to a file
  instead of a pipe (**D66**, Task **#6**). Verified: 62 consecutive samples of the live
  session list, no truncation, against 8 truncated in 56 before. The measurements are in D65
  and D66.
- **A Desktop is named by the projects with live sessions on it** (Task #5, **D67**), one
  line each, joined to their Desktops by **window** rather than by name — and those lines
  are the only coloured ones on the panel (**D75**, teal). A Desktop with no session is
  named after the projects whose **documents** are open on it, in white, with no dots;
  nothing reads a window's title any more (**D75**, Task #7).
- **The two machines are merged.** The laptop's `73803a4` (clickable legend words,
  cross-machine alerts) and this machine's `a6a8c5b` (v47–v50) diverged from `6442953` and
  are now one history. Only three hunks conflicted — the version line, `M.stop`, and one
  block in `CLAUDE.md` — and the laptop's 59 lines of decision prose were **lifted into
  `DECISIONS.md` as D68–D73** rather than discarded with the conflict.
- **Task #1 is closed by the merge:** this repo's `claude-dashboard-state.sh` is now 206
  lines, byte-identical to the `claude-config` copy that actually runs (`diff`, after the
  merge).
- **This repo was migrated onto the project spine on 2026-08-03** (`claude-config`
  Tasks #11 and #19). What changed:
  - `DECISIONS.md` now exists and holds **D1–D64**, lifted out of `CLAUDE.md` where they
    had accumulated for want of such a file. **The measurements came across intact** —
    the ~40 ms `hs.window.get` cost, the ~750-sample dot study of 2026-07-28, the Menlo 13
    glyph widths, the 26-second blocked-session observation, the ~14 ms CoreGraphics pass.
    Nothing was added, dropped or softened.
  - `CLAUDE.md` went from **556 lines to architecture and layout only**, and gained the
    **What / Produces / State** block.
  - `docs/` → `DOCS/`, `archive/` → `PRE_CONVERSION/` (**D63**); `SESSIONS/`, `LATEX/`
    and `ISSUE_ANALYSES/` added empty.
  - **The code did not move** (**D64**) — `~/.hammerspoon/init.lua` and
    `~/.claude/settings.json` both name files here by path.

## Verified during the migration

Everything in this section was run or read, not recalled.

- **The two copies of `claude-dashboard-state.sh` have drifted, and the one in this repo
  is the stale one.** `diff` against
  `~/Git_Repos/claude-config/hooks/claude-dashboard-state.sh` — which is what
  `~/.claude/settings.json` actually registers on all four events — shows the
  `claude-config` copy is **~90 lines longer**. It has an opt-in remote-alerting block
  (Dropbox marker, ntfy, Pushover, all off by default) that this repo's copy does not, and
  it hoists the `message` extraction out of the state write so the alert can use it.
  **Consequence:** anyone installing from this repo by following `INSTALL.md` gets a
  script without that feature, and an edit made here would never reach this machine.
  **Reported, not fixed** — which copy is authoritative is a decision, not a cleanup.
  Tracked as **Task #1**.
- `~/.claude/settings.json` registers the `claude-config` path four times, once per state:
  `working`, `waiting`, `done`, `gone`.
- Working tree clean and level with `origin/main` before the migration began
  (`6442953`).

## Decisions taken (D1–D90)

D1–D64 were lifted from `CLAUDE.md` on 2026-08-03. **Eleven are new on 2026-08-04.** Written
here: every `hs.task` carries a timeout (**D65**), a subprocess writes to a file rather than
a pipe (**D66**), a Desktop is named by its live sessions and failing that by the projects
its windows belong to (**D67**), that colour lands on the session lines instead (**D74**,
**D75**), and only a document names a project (**D75**). Lifted out of the
laptop's `CLAUDE.md` prose by the merge, measurements intact: the clickable legend
(**D68**–**D71**) and the cross-machine alert (**D72**, **D73**).

Platform: overlay rather than renaming (D1), Hammerspoon (D2), active-Space-only reads
(D3), one `allWindows()` snapshot per read (D4), the `docApps` allowlist (D5).
Detection: what decides a subject and what only hints at a repo (D6–D12), a live
session's cwd outranks prose (D13–D14), single app vs category (D15), manual overrides
(D16).
The claude dot: the title carries two states, not three (D17), red comes from hooks
(D18), tell the two `Notification` kinds apart by ordering (D19), ageing (D20),
"finished and unseen" (D21), key off the detected label (D22), acknowledge by focus in
sessions mode (D23), and four cost/latency rulings (D24–D27).
Git: the dot is local-only (D28), `ls-remote` not `fetch` (D29), `--ff-only` (D30), the
two pre-pull checks (D31–D32), the confirmation (D33–D34), git speaks for itself (D35),
no push button (D36), plus D37–D39.
Rendering: D40–D59.
Lifecycle: D60–D62.
Repo: `PRE_CONVERSION/` (D63), the code stays at the top level (D64).
Subprocesses: time out every read (D65), capture to a file (D66).
Naming: sessions first and in teal (D67, D74, D75), then the projects whose documents are
open there, in white (D75). A name typed by hand belongs to a **project**, never to a
Desktop (D76, superseding D16).
Portability: no synced folder, no polling (D77); the code's own install steps must not
contradict INSTALL.md (D78). TeXShop measured at 0.1 ms and let into docApps, closing D32's
five-day-old live tension (D79). The hook carries no external dependency (D80), and a session
with no window still gets a line (D81). iTerm2 is read by the same poll as Terminal, after
both blocking questions were measured (D82), and the hook fires on session start so a session
exists before it is prompted (D83). A session running inside an editor is placed by the window
that hosts it, identified by title and never named from one (D84) — or better, by the window
it started in, which needs no title at all (D85). Reaching that window never opens Mission
Control (D86), and the app it belongs to is found by exact name, because
`hs.application.get("Code")` returns Xcode (D87).
Remote work: legend words are buttons (D68–D71), the hook raises the alert (D72–D73).

## Active thread — resume here

**NEXT, and it is Peter's live complaint: `INSTALL.md` is still too long.** After four
rewrites on 2026-08-18 he said *"Still seems like a lot of extra stuff, which will confuse
a lot of potential users."* The structure is now right — step 4 installs, step 5 is
everything about an `init.lua` that already exists, step 6 is looking at the screen — but
the volume is not. **What has already been tried, so it is not re-tried:** conditionals
inlined in step 4 (confusing), the by-hand alternative kept beside the command (confusing),
skip-bullets before the cases they refer to (worse). The remaining move is cutting, not
reordering. A first-time reader needs step 4 and step 6; everything else is for someone
who already has a working install.

**One cross-repo dependency to know before editing `INSTALL.md`:** `claude-config-public`
carries its own summary of this install, generated from
`claude-config/make-starter.sh` — the "Optional: the session panel" section of its
`README.md`. It names `./install.sh`, `--check`, `--hooks` and `--upgrade`. If those flags
or their behaviour change here, that section has to change there, and the starter has to be
rebuilt and pushed.

**2026-08-18 — installing is one command now (Task #19, D93).** `install.sh` derives the
repo's path and the repos folder, writes them into a marked block in
`~/.hammerspoon/init.lua`, moves a stale `~/.hammerspoon/desktop_dashboard.lua` aside, and
restarts Hammerspoon; `--hooks` merges the five red-dot events into
`~/.claude/settings.json`; `--check` reports without changing anything. `INSTALL.md` steps
3–5 and the red-dot section are rewritten around it and the by-hand version is an appendix.

- **Exercised against four sandbox `HOME`s, never against this machine.** Fresh install,
  re-run, a user's own `init.lua` plus a stale module, and a `--hooks` merge over an
  existing hook and permissions block — results in Task #19.
- **Nothing here has been run for real, and nothing is committed.** Peter's `init.lua` is
  live, and his `~/.claude/settings.json` is a symlink into `claude-config` where the
  dashboard hook is already registered. `./install.sh --check` is the safe first move.
- **This came out of a student install on 2026-08-18**, which is also what is driving the
  `claude-config-public` documentation work; the starter's own instructions for this repo
  are rewritten next, from what is settled here.

**Task #18, the rename to `claude-switchboard` (D92), is done — 2026-08-12.** This
section claimed it was in flight and unexecuted until 2026-08-18, which it was not. One
thing from it is still open, and it is cosmetic: the **deployed** hook,
`claude-config/hooks/claude-dashboard-state.sh`, has two comment lines still naming
`Desktop_Dashboard`. The hook does not read the name. `desktop_dashboard.lua` keeps its
filename on purpose (D64).

**`~/.hammerspoon/init.lua` is not in git and differs per machine**, which used to be the
easy thing to miss in any rename or move. It no longer needs hand-editing: run
`./install.sh` on each machine and it rewrites its own block.

**`v65` fixed a dot that had been dead for weeks (D91).** Claude Code changed the spinner in
its window title — `◑` U+25D1 now, Braille before — and both title parsers tested the Braille
block, so **every** Terminal and iTerm session read `idle` and the yellow dot could never
light. The hook file was correct throughout; it is the title that wins for a Terminal session
(D82 over D81). The test is now by exclusion — anything that is not `✳` and is a symbol means
computing. Verified by photographing the panel mid-prompt: Desktop 4 and `T1` yellow, the four
idle sessions gray.

**Worth carrying forward:** this failed *silently and permanently*, and it was found only
because Peter happened to say "the gray dot is not going yellow". Anything that pins the
panel's reading to a glyph, a title format or an app's UI will fail the same way. Ask of any
such test: when this breaks, does a dot get stuck on (noticed) or never light (not noticed)?

**The session of 2026-08-05/07 closed at `v64`**, with everything committed and pushed.

**What this run produced:** `v53` → `v64`, decisions **D76–D90**, Tasks **#8–#17**, and two
session logs including a reconstruction of one that was never written. It began with a Desktop
showing a name it should have lost, and ended with the panel able to see a claude session in
any terminal on the machine.

**The thread that ran through most of it** was a colleague who could not get the panel working
at all. That turned out to be two silent failures — a hook that needed `jq`, which macOS does
not ship, and a session poll that read Terminal.app only — and chasing them produced most of
what is listed above.

**Verified live, each photographed or measured:** MacDown's documents (`v54`); ⌘⌃⌥N renaming a
project; TeXShop at 0.10–0.23 ms (`v55`); the hook `jq`-free and **4× faster** (`v56`); iTerm's
two blocking measurements and a real Desktop line (`v57`); a VS Code session on its own Desktop
line (`v58`–`v59`); the click that raises its window (`v61`); **`gotoSpace` failing 2 times in
8** and every switch now verified (`v62`, `v63`); and the phantom daemon sessions removed
(`v64`).

**Where to pick up:**

1. **Watch D83 for a day.** The `SessionStart` hook has thrown off two bugs already — invisible
   new sessions, then Claude Code's own daemon appearing as `T#` lines. Both fixed; a third
   would not be a surprise.
2. **The iMac has pulled none of this**, and its hook is still the `jq` version. It is also the
   machine the cross-machine alert was built for, so it is the one place `NOTIFY_DROPBOX=1`
   still matters.
3. **The colleague needs both repos** — `Desktop_Dashboard` for `v64`, and whichever repo holds
   his hook, for the copy that needs no `jq`, records `TERM_PROGRAM`, and fires on
   `SessionStart`.

**Still never exercised, and unchanged by any of this:** click-to-cycle on a Terminal session
line; ⌘⌃⌥g and its pull through the rewritten `runTask`; the clickable legend words alongside
the per-project Desktop lines.

**Two tools this session added, both in `CLAUDE.md`:** photograph the panel with
`hs.window.snapshotForID` (`hs.screen:snapshot()` cannot see the canvases), and read
`M.walkStats` after a ⌘⌃⌥S to see whether any Desktop switch had to be retried.

**Finder tags do not travel in git.** After pulling this repo on the other machine, run
`~/Git_Repos/claude-config/tag-spine.sh ~/Git_Repos/Desktop_Dashboard`.
