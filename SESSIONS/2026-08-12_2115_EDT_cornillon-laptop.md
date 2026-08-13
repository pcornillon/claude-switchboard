# Session — 2026-08-12 21:15 EDT · cornillon-laptop
<!-- session: 780ee6df-55b5-44b6-bdd2-09deb425bfe9 -->

Lane: repo naming / metadata. No changes to `desktop_dashboard.lua` behaviour.

## P1 · 2026-08-12 21:14 EDT · Can the repo be renamed, and is `claude-control-panel` a better name?

Asked whether a git repo can be renamed locally and on GitHub, and what I think of
`claude-control-panel` in place of `Desktop_Dashboard`, which "could apply to anything".

**Read:** `CLAUDE.md`, `STATUS.md` (active thread), `LOG.md` tail; `git remote -v`;
`~/.hammerspoon/init.lua`; `~/Git_Repos/claude-config/hooks/claude-dashboard-state.sh`.

**Found — every place the directory name is wired in:**

- `~/.hammerspoon/init.lua:2,3` — `package.path` points at
  `~/Git_Repos/Desktop_Dashboard/?.lua`. **On both machines.**
- `desktop_dashboard.lua:33` — the same path in the header comment / default.
- `init.lua.example:7,24` — the loader line and the symlink recipe.
- `claude-dashboard-state.sh:28` — a prose reference only (both copies).
- `claude-config` (`README.md`, `STATUS.md`, `TASKS.md`, `LOG.md`) and several session
  logs across three repos — prose, historical, should not be rewritten.

Remote is `https://github.com/pcornillon/Desktop_Dashboard.git`; GitHub's rename leaves a
redirect for the old URL, so a stale `origin` keeps working — which is exactly why a
missed `git remote set-url` goes unnoticed.

**Answered:** yes, renaming is routine; the cost here is the four wired paths and the
two machines, not git. Argued *against* `claude-control-panel` — claude state is one
column of three, "control panel" overstates a mostly-read-only overlay, and the
`claude-*` prefix already means "claude-config" in this account. Recommended
`macos-spaces-panel`, runner-up `macos-desktop-panel`. Nothing renamed; waiting on
the answer.

## P2 · 2026-08-12 21:27 EDT · The name has to capture *running claude sessions*

Peter answered ASK 1 by rejecting the premise of my argument rather than the names: the
tool was built to make working with **several claude projects at once** convenient, and
that is where its value is — the four dot colours, the per-repo git dot, and ⌘⌃⌥g. He
grants it is useful with no session running (and would have wanted it before claude), but
that is not what it is *for*.

**Conceded.** My "it isn't a Claude tool" was an argument from the code's surface area —
claude state is one column of three — and he owns intent. Withdrew it. The two objections
that survive are narrower: `control panel` overstates a mostly read-only overlay, and a
`claude-*` name costs the audience that wants a Spaces panel and no claude.

Proposed `claude-spaces` (recommended), `claude-session-panel`, `claude-mission-control`.
Still nothing renamed.

## P3 · 2026-08-12 21:39 EDT · One Desktop per project, or one VS Code window per project?

Peter uses the panel alongside a 4-finger-up Mission Control, one Desktop per project,
with Finder windows in the Desktop's configuration. Asked (a) whether claude can run in
VS Code from a given folder with the spine `.md` files tabbed elsewhere in the window, and
(b) whether one-VS-Code-window-per-project — several such windows on one Desktop — is the
better arrangement. Notes the answer may affect the tool's name.

**Verified on this laptop:** `anthropic.claude-code-2.1.224-darwin-arm64` is installed;
`code` CLI at `/usr/local/bin/code`; `M.docApps` already carries both
`Visual Studio Code` and `Code` (line 322); `M.maxProjects = 2` (line 448). **Not tested
live** — I did not open a window and lay it out.

**Answered:** yes to (a), both via the extension panel and via `claude` in the integrated
terminal, cwd = the workspace folder. Argued against (b) as posed, and for a hybrid: keep
one Desktop per project as the container — it holds Finder, MacDown, TeXShop, MATLAB,
which VS Code cannot — and use VS Code *inside* it as editor + claude host. The flaw is
specifically N VS Code windows on ONE Desktop: identical icons in ⌘-Tab, no spatial map,
and the panel degrades from a map to a list (`maxProjects` truncates at 2, and several
projects' session groups pile onto one Desktop line).

Naming consequence: the hybrid leaves `claude-spaces` correct.

## P4 · 2026-08-12 22:08 EDT · A name that advertises the round-robin use

Peter rejected both `claude-spaces` and `claude-desktops` ("leave me a bit cold"), and
corrected the vocabulary: **Space** = any Mission Control workspace, **Desktop** = a Space
behaving like the normal Mac desktop; a full-screen Safari is a Space labeled *Safari* in
Mission Control but `Desktop nn` here. Agreed — `desktops` is the accurate word, but
neither name is the problem.

**The use, from a screenshot of the live panel** (10 Desktops on the LG, 5 sessions
`T1`–`T5`): prompt session A, move to B, prompt it, move to C; B goes red and wants input,
so click B; A finishes green, so go there and tell it to commit; ⌘⌃⌥g on C to check GitHub
is not ahead after work on the other machine; check Mail while waiting. **The panel is
consulted continuously, and almost entirely to decide which session to attend to next.**

Proposed `claude-switchboard` (recommended), `claude-control-tower`, `claude-flight-deck`,
`claude-dispatch`. The argument for switchboard: the panel already *is* one — a column of
lines, each with indicator lamps, and the legend at line 503 reads
`"click a line, or a blue word"`. The operator does not make the calls, they see which
line is lit and connect you to it, which is exactly the objection `control panel` ran into.

## P5 · 2026-08-12 22:14 EDT · `agentic-switchboard`? — and is a second backend really trivial?

Peter asked whether a backend-neutral name would be better, assuming an agentic OpenAI
equivalent of claude code would be "almost trivial" to support.

**Checked, rather than assumed.** `claude-dashboard-state.sh` is 323 lines; it writes
`~/.hammerspoon/claude_state/<session_id>.json` and is registered in
`~/.claude/settings.json` on **five** events — `working`, `waiting`, `done`, `idle`,
`gone` (lines 41, 58, 70, 105, 116). The panel reads only those files. So the port is
trivial **iff** the other CLI exposes the same five lifecycle moments; if it does, the Lua
barely changes. **Unverified:** whether OpenAI's agentic CLI has a hook mechanism at all —
I did not look it up, and that unknown is the whole question. The Terminal/iTerm title
poll (D17–D19, D82) is separately claude-specific and would need its own work.

**Recommended `claude-switchboard` anyway**, on the ground that the rename cost is now a
*measured* small number (four wired paths, two machines, a GitHub redirect), so hedging
buys little; and that a neutral name today would be a promise five hook registrations do
not keep. If he wants the hedge regardless, **`agent-switchboard`** — noun, not the
adjective of the moment.

## P6 · 2026-08-12 22:19 EDT · The yellow dot is dead — Claude Code changed its spinner

Peter reported, as an aside, that the gray dot never goes yellow when he issues a prompt.
**Reproduced and diagnosed in four commands.**

The hook is innocent: `~/.hammerspoon/claude_state/780ee6df-….json` reads
`{"state":"working",…,"term":"Apple_Terminal"}`, written at `UserPromptSubmit`
(`~/.claude/settings.json` line 58). But for a Terminal session the panel takes its state
from the **title**, not the hook file (D82 over D81), and the title test is a codepoint
range:

    desktop_dashboard.lua:884 and :915
    local state = (cp and cp >= 0x2800 and cp <= 0x28FF) and "working" or "idle"

**Measured, this session, live:** a computing session's marker is now **`◑` U+25D1**
(Geometric Shapes), and the four idle ones are **`✳` U+2733`. Neither is in the Braille
block, so *every* Terminal session reads `idle` and the dot can never go yellow.** Claude
Code's spinner used to be Braille — `CLAUDE.md` still cites `⠂` among the glyphs titles
carry. Both parsers have the identical line, so iTerm is broken the same way (line 884 is
`parseITermSession`, 915 is `parseClaudeTitles`).

Sampled `◑` six times in a row with no rotation; **the sibling codepoints U+25D0/25D2/25D3
are an inference, not a measurement.**

Three fixes proposed — widen the range, invert the test (`✳` = not working, anything else
= working), or make the hook file authoritative for state on Terminal sessions too and
leave the title its window-id and summary duties. Recommended the last as the design and
the second as tonight's patch. **No code changed.**

## P7 · 2026-08-12 22:23 EDT · Fixed the yellow dot (`v65`, D91); name settled (D92)

Two answers. On the dot: Peter asked what the downside of the hook-file fix actually is,
since "2 tonight, 3 later" was not a distinction he could see. **He was right to press —
and reading the code changed my recommendation.** `readHookStates()` already exists and is
already repo-keyed, so option 3 is not the big change I implied; what it costs is that
**the hook is an event, not a state** — only `Stop` retracts a `working`, so a killed
session sits yellow until the 12 h age-out, and yellow would drop from per-session to
per-repo. So neither 2-then-3: just the title test, done properly.

Line 136 turned out to hold the measurement that made inversion safe — *"a session blocked
on a question shows the same `✳` as one that has finished (measured)"* — so `✳` covers both
resting states and inverting cannot mask red.

**Built (`v65`):** `M.claudeIdleGlyphs = { [0x2733] = true }` and `M.claudeGlyphMin =
0x2000` in CONFIG, a `glyphMeansWorking()` helper by `firstCodepoint`, and both call sites
switched (`parseITermSession`, `parseClaudeTitles`). D91 written, with the rejected
hook-authoritative design and its live tension recorded.

**Verified, not assumed:** `loadfile` clean → `hs.reload()` → console shows
`desktop_dashboard v65 … loaded` with no error → panel photographed with
`hs.window.snapshotForID`. **Desktop 4 and `T1` are yellow while this session computes;
the four idle sessions are gray.** The snapshot recipe in `CLAUDE.md` needed the raw
CoreGraphics keys (`kCGWindowOwnerName`, `kCGWindowLayer`, `kCGWindowNumber`) — my first
attempt used `w.app`/`w.layer` and reported "no panel window", which is the exact false
alarm that gotcha warns about.

On the name: **`claude-switchboard`** — D92, and Task #18 holds the six steps. Nothing
renamed yet; the directory move wants a clean tree and a deliberate moment.

## P8 · 2026-08-12 22:33 EDT · Executed the rename, and closed the session

"Commit and push, run `gh repo rename claude-switchboard`, then rename — I'm assuming you do
it all." Done, in an order chosen so that **nothing had to be written to the repo after the
directory moved**: every edit and the commit first, the GitHub rename next, the push, then the
`mv`, and only a Hammerspoon reload afterwards.

**Swept to the new name:** `CLAUDE.md`, `README.md` (7), `INSTALL.md` (7),
`init.lua.example` (3), `desktop_dashboard.lua` line 33, this repo's copy of
`claude-dashboard-state.sh` (2), and `~/.hammerspoon/init.lua` — which is **not in git** and
exists separately on satdat1. Two substitutions, not one: `Desktop_Dashboard` → the path
`claude-switchboard`, and the prose `Desktop Dashboard` → `Claude Switchboard`.

**Deliberately not swept:** `LOG.md`, `SESSIONS/`, `DECISIONS.md`, `PRE_CONVERSION/`. They
record what happened under the old name and rewriting them would be a lie. Also **not** the
deployed hook in `claude-config` — a live session (`T5`) is in that repo and lane discipline
says a cross-lane edit goes through Peter.

---

## Prompt index — machine-extracted, authoritative

Regenerated by `prompt-index.sh` from this session's transcript JSONL — **not**
reconstructed. Every prompt, in order, with the time the machine recorded.

**The `## P##` entries above are curated; their timestamps may be approximate**
(D28). Where the two disagree, this table wins.

- `01` · 2026-08-12 21:14 EDT · Is it possible to change the name of a git repo on my local computer and at Gi
- `02` · 2026-08-12 21:27 EDT · Ask 1. The thing is that I put this, well we did, together to make working wit
- `03` · 2026-08-12 21:39 EDT · I use the tool together with 4-fingers up, which shows all the desktops, conti
- `04` · 2026-08-12 22:08 EDT · Aks 1. As I understand it, the distinction between Spaces and Desktops is as f
- `05` · 2026-08-12 22:14 EDT · Ask 1. Sorry to keep throwing things at you but I'm assuming that if I start w
- `06` · 2026-08-12 22:23 EDT · Ask 1. It is not obvious to me with you are recommending 2 tonight 3 as a task
- `07` · 2026-08-12 22:33 EDT · Ask 1. Commit and pull, run gh repo rename claude-switchboard, then rename. I'

**7 prompts.** **`P6` has no row here on purpose**: the gray-dot report arrived as a
mid-turn message inside prompt `05`'s turn, so the machine recorded no separate prompt for
it. The curated entry is the only record of when it was asked, and its 22:19 is approximate.
