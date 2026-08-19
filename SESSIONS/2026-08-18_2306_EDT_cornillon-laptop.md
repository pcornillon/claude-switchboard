# Session — 2026-08-18 23:06 EDT · cornillon-laptop

<!-- session: 501db254-c603-44ee-b442-95a65e4c5b53 -->

Repo: `claude-switchboard`. Lane: `INSTALL.md` and the spine.

Prompt and response sections are rebuilt by `session-transcript.sh`; the subject lines and
`### Notes` blocks below are written by hand.

## P1 · 2026-08-18 23:06 EDT · rewrite INSTALL.md for a non-terminal reader

### Prompt

> I tthink that we need to simplify the INSTALL.md file. Think of it this way. Many of those whom I'm trying to reach are, for example, physical oceanographers without a lot of experience with regard to the inner workings of today's computers so I don't think that discussion of hs.ipc and _G.dd...will mean much--it doesn't to me. And the paragraph beginning "Which terminal you run claude in matters, but less than it used to." is really confusing. I would start by saying that this tool is really for those who run Claude Code from a terminal window (a.k.a. iTerm2), from VSCode, from Cursor or some other interface, which supports Claude Code. Maybe something in the sentence about the OSX default terminal window. Bottom line: I think that this should be written for someone without a lot of experience working in the terminal window or using Desktops. I was shocked to find that people whom I know well and who have been working with Macs for years run with only two desktops, because they are running with two screens. The INSTALL.md file should be written for them where it is very clear what the t next step in the installation is and, if there is an option , such as in Step 4, that most people don't exercise it. Otherwise, it's just noise.

### Response

I'll read the current INSTALL.md before changing it.

_[Bash: wc -l INSTALL.md && cat -n INSTALL.md]_

Now checking `install.sh`'s actual flags and README's framing so the rewrite stays accurate.

_[Bash: grep -n -- '--[a-z]' install.sh | head -60; echo ---; sed -n '1,60p' README.md; echo --…]_

Checking how README and DECISIONS describe terminal support, so the simplified wording stays true.

_[Bash: grep -n -i 'ghostty\|kitty\|iTerm\|Terminal.app\|Cursor\|VS Code' README.md | head -40;…]_

_[Skill: markdown-tables]_

Now rewriting the file. Writing it fresh rather than patching, since the ordering changes.

_[Bash: cat > INSTALL.md <<'INSTALL_EOF' # Installing Claude Switchboard Everything here happen…]_

_[Bash: python3 - <<'EOF' import re p='INSTALL.md'; s=open(p).read() s=s.replace("| after you a…]_

_[Bash: grep -rn -i 'step [0-9]' README.md install.sh init.lua.example STATUS.md CLAUDE.md 2>/d…]_

Now the bookkeeping: checking for this session's log and the open complaint in STATUS.md.

_[Bash: grep -l '501db254' SESSIONS/*.md 2>/dev/null; ls -t SESSIONS | head -5; echo '--- STATU…]_

_[Bash: git log --oneline -8 --name-only | head -40; echo '--- today sessions ---'; ls SESSIONS…]_

_[Bash: ls -la ~/.claude/projects/-Users-petercornillon-Git-Repos-claude-switchboard/501db254*.…]_

_[Bash: python3 - <<'EOF' import json,glob f=glob.glob('/Users/petercornillon/.claude/projects/…]_

_[Bash: grep -n '^### \|^Status:' TASKS.md | tail -20; echo ---; sed -n '1,12p' SESSIONS/2026-0…]_

_[Bash: grep -n 'Status:' TASKS.md | tail -12; echo '--- headings ---'; grep -n '^## \|^#### \|…]_

_[Bash: sed -n '601,640p' TASKS.md; echo '=== LOG tail ==='; tail -20 LOG.md]_

Now writing the bookkeeping: session log, LOG.md line, Task #20, and the STATUS.md active thread.

_[Bash: cat > SESSIONS/2026-08-18_2306_EDT_cornillon-laptop.md <<'EOF' # Session — 2026-08-18 2…]_

_[Bash: cat >> LOG.md <<'EOF' - ★ **P1** `2306_cornillon-laptop` · 2026-08-18 23:06 EDT · `INST…]_

_[Bash: python3 - <<'EOF' s=open('TASKS.md').read() s=s.replace("rewritten 2026-08-18 23:0x EDT…]_

_[Bash: echo -n 'old: '; git show HEAD:INSTALL.md | wc -w; echo -n 'new: '; wc -w < INSTALL.md …]_

_[Bash: sed -n '1,120p' INSTALL.md]_

_[Bash: python3 - <<'EOF' p='INSTALL.md'; s=open(p).read() s=s.replace("Everything here happens…]_

#### Findings

**INSTALL.md** is rewritten end to end. The numbered install path (everything before the dot rehearsal) went from 1262 words to 1029, and that is *after* adding a new paragraph, so the cut is larger than the number looks.

**What now opens the file.** A *Who this is for* section that starts from how people actually run Claude Code — Terminal (the one macOS ships), iTerm2, VS Code, Cursor — and says all of them work. The Terminal/iTerm distinction is one clause: those two are read most directly and always land on the right Desktop line; everywhere else the panel learns about the session from Claude Code itself, which step 6 sets up. The paragraph beginning *"Which terminal you run `claude` in matters, but less than it used to"* is gone.

**Cut from the numbered path entirely:** `hs.ipc` and `_G.dd`, the `hs -c "return dd.version"` check, the `jq` history in the requirements, the five-events paragraph, and the `settings.json` JSON-safety paragraph (now one sentence: backed up first and added to, never replaced).

**Step 4 is one command with no options in view.** `--repos`, `--upgrade`, `--check`, `--no-reload` and `--no-ipc`, plus the by-hand `init.lua` block, all moved to a closing section called *Less usual cases* that opens "Most people never need this section." The old step 5 — everything about an `init.lua` that already exists — leaves the numbered path; looking at the screen takes its number; **the red dot is now step 6 rather than an "Optional:" heading**, since it is the dot that makes the panel worth having.

**One thing added rather than cut,** which runs against your instruction to shorten: a short paragraph in *Who this is for* saying what a Desktop is, that Control-↑ then **+** adds one, and that the panel's value only appears once work is spread across several. That is your two-screens/two-Desktops observation made actionable — without it the doc installs a tool the reader has no use for. Delete it if you disagree.

**What I did not do.** I did not touch `README.md`, `install.sh`, or any flag or behaviour — so `claude-config-public`'s generated "Optional: the session panel" section, which names `./install.sh`, `--check`, `--hooks` and `--upgrade`, does not need rebuilding. I did not re-try any of the three approaches STATUS recorded as already tried and rejected. Nothing is committed.

**Verified rather than assumed:** the flag list and their meanings were read out of `install.sh`'s own header; the README anchor `#let-claude-code-install-it` exists; no other file cites INSTALL.md by step number except `STATUS.md`, which I rewrote.

#### DECISIONS

- **Task #20** opened for this, `Status: doing` — it stays `doing` until you have read the file, since your revisions would be the same task.
- Session log opened at **SESSIONS/2026-08-18_2306_EDT_cornillon-laptop.md** (new session, id `501db254…`; today's earlier work sits in the 2026-08-16 log). `LOG.md` line and `STATUS.md` active thread updated. Prompt/Response sections still need `session-transcript.sh` — I'll run it when you wrap up.
- The dot rehearsal and its table are kept as they were. You didn't complain about them, and they are the only part that shows what the colours mean in practice.
- I briefly rewrote one row of that table and reverted it — the "after you approve or deny" row reads `🟡 yellow — resumed`, as it did, because that row is an observation from a real run.

**ASK 1:** Read **INSTALL.md** as if you were one of those oceanographers — is the numbered path now short enough, and is the Desktop paragraph welcome or noise?

**ASK 2:** Commit this, or hold it until you have read it?

RESPONSE COMPLETE

### Notes

**The audience was named for the first time:** physical oceanographers and other Mac users
of long standing who do not work in a terminal and who, in Peter's experience, run **two
Desktops because they have two screens**. Every cut below follows from that, not from a
general preference for brevity.

**What was removed, and why each was noise for that reader:**

- **`hs.ipc` and `_G.dd`** — named as meaningless to Peter himself, so certainly to the
  audience. The command-line bridge survives as one row in a flags table at the end
  ("lets a command line ask the running panel questions. Harmless either way") and as the
  two commented lines in the by-hand block, which must stay accurate because
  `install.sh` writes them.
- **`hs -c "return dd.version"` as the step-5 check** — a stronger test, but only for
  someone who would type it. Step 5 is now "look at the screen", and the Console line is
  the fallback.
- **The `jq` history** in the requirements — true, and about a version nobody installing
  today will have.
- **"Which terminal you run `claude` in matters, but less than it used to"** — flagged as
  confusing. Replaced by a *Who this is for* section that opens with the four ways people
  actually run Claude Code (Terminal, iTerm2, VS Code, Cursor), says all of them work, and
  puts the Terminal/iTerm distinction in one clause instead of a paragraph.
- **The five-events paragraph** and the `settings.json` JSON-safety paragraph in the
  red-dot section — compressed to one sentence of reassurance ("backed up first and added
  to, never replaced").

**Step 4 is now one command with no options in view.** `--repos`, `--upgrade`, `--check`,
`--no-reload` and `--no-ipc` all moved to a *Less usual cases* section that opens with
"Most people never need this section." Step 5, which had been everything about an existing
`init.lua`, is gone from the numbered path entirely; the old step 6 (look at the screen)
took its number, and the red dot became step 6 — a numbered step rather than an
"Optional:" heading, because it is what makes the panel worth having.

**One thing was added rather than cut,** against the general instruction to shorten: a
paragraph saying what a Desktop is, that Control-↑ then **+** adds one, and that the panel's
value only appears once work is spread across several. It is the two-Desktop observation
made actionable; without it the doc installs a tool the reader has no use for.

**No flag or behaviour of `install.sh` changed**, so `claude-config-public`'s generated
"Optional: the session panel" section — which names `./install.sh`, `--check`, `--hooks`
and `--upgrade` — does not need rebuilding.

**Verified, not assumed:** the flags and their meanings were read out of `install.sh`'s own
header before being described; the README anchor `#let-claude-code-install-it` was
confirmed to exist; no other file in the repo cites `INSTALL.md` by step number (only
`STATUS.md`, which is rewritten here).

**One edit was made and reverted within the same pass:** the dot table's "after you approve
or deny" row was briefly rewritten as "red, then yellow". That is an observation from a
real run, and changing it would have been an invented measurement. It reads
"🟡 yellow — resumed" as before.

## P2 · 2026-08-18 23:47 EDT · step 4's `repo:` / `repos:` output is confusing

### Prompt

> Much, much better. The only point of confusion I have is again in Step 4. It says /repo:   /Users/you/Git_Repos/claude-switchboard
> repos:  /Users/you/Git_Repos"

### Response

Looking at where those labels come from in `install.sh`, since the confusing text is the script's own output.

_[Bash: grep -n 'repo:\|repos:\|target:\|printf\|echo' install.sh | head -40]_

_[Bash: sed -n '50,70p' install.sh; echo '--- check section ---'; sed -n '104,140p' install.sh]_

Changing the labels in `install.sh` itself, then matching the doc to it.

_[Bash: python3 - <<'EOF' p='install.sh'; s=open(p).read() old = 'echo "repo: $REPO"\necho "rep…]_

_[Bash: bash -n install.sh && echo 'syntax OK'; grep -rn 'repos: \|^repo: \|target: ' README.md…]_

_[Bash: rm -rf /private/tmp/claude-502/*/501db254-c603-44ee-b442-95a65e4c5b53/scratchpad/fakeho…]_

### Notes

**The confusion was in `install.sh`, not in `INSTALL.md`.** Step 4 quotes the script's own
output, and the script printed `repo:` / `repos:` / `target:` — two labels differing by one
letter and naming unrelated things. Fixing only the doc would have left the reader meeting
the same two words the moment they ran it. `install.sh:58-60` now prints `this tool:` /
`your repositories:` / `configuring:`, padded to one column; the sample block and the
paragraph under it follow.

**Verified:** `bash -n install.sh`, then `./install.sh --check` under a sandbox `HOME` in
the scratchpad — the three new labels printed and the check behaved as before (`MISS`,
exit 1). **Not run against the live install.**

## P3 · 2026-08-18 23:49 EDT · the same point, retyped — `repo:` and `repos:`

### Prompt

> Sorry hit return by accident. What I meant to say: It says 
>
> repo:   /Users/you/Git_Repos/claude-switchboard
> repos:  /Users/you/Git_Repos

### Response

That's exactly the line I changed while you were typing. It now reads:

```
this tool:         /Users/you/Git_Repos/claude-switchboard
your repositories: /Users/you/Git_Repos
configuring:       /Users/you/.hammerspoon/init.lua
```

`repo:` and `repos:` differed by one letter and meant two unrelated things, so I fixed it at the source — the labels come from `install.sh` (line 58), not from the doc — and matched the sample output and prose in **INSTALL.md** to it. I did not run `--check` against your live install; the sandbox run confirmed the new labels print correctly.

_[Bash: rm -rf "/private/tmp/claude-502/-Users-petercornillon-Git-Repos-claude-switchboard/501d…]_

## P4 · 2026-08-18 23:52 EDT · does `claude-switchboard` have to live in `Git_Repos`?

### Prompt

> I did it again. The issue I have relates to Git_Repos. It sounds like it is a requirement that claude-swithboard lives in Git_Repos but I think that you said earlier that it could  be put anywhere? Does it have to be in Git_Repos and the other repos here as well or it needs to be specified where they are?

### Response

Good question — let me check what the code actually requires before answering.

_[Bash: grep -n 'repoRoots' desktop_dashboard.lua | head -20; echo '=== derivation ==='; sed -n…]_

_[Bash: sed -n '1495,1520p' desktop_dashboard.lua; echo '=== 760-780 ==='; sed -n '762,780p' de…]_

That question exposes a real error in my step 3. Checking the answer against the code first: `loadRepos` (**desktop_dashboard.lua:763**) lists only the *immediate children* of each root, and `repoForPath` matches `<root>/<project>/…` — one level, not recursive.

_[Bash: python3 - <<'EOF' p='INSTALL.md'; s=open(p).read() old3 = """### Step 3 — Download Clau…]_

_[Bash: python3 - <<'EOF' import json,glob,datetime f=glob.glob('/Users/petercornillon/.claude/…]_

_[Bash: cat >> SESSIONS/2026-08-18_2306_EDT_cornillon-laptop.md <<'EOF' ## P2 · 2026-08-18 23:4…]_

#### Findings

**No — `claude-switchboard` can live anywhere, and so can your repositories.** The doc implied otherwise, and one line of it was outright wrong. Both are fixed.

**What the code actually requires** (read from **desktop_dashboard.lua**, not recalled): the panel watches a list of *root folders* and treats **each folder directly inside a root** as a project. `loadRepos` at line 763 lists immediate children only; `repoForPath` at line 1497 matches `<root>/<project>/…`. **It is one level deep, never recursive** — `~/work/repos/my-analysis` is found, `~/work/repos/2026/my-analysis` is not.

**Where `Git_Repos` came from:** nowhere but my machine. `install.sh` derives the root from wherever you cloned to — it takes `claude-switchboard`'s **parent folder** as the default guess — and `--repos` overrides it with as many folders as you like. `Git_Repos` is only the module's built-in fallback, which the installer always overwrites.

**My step 3 was wrong and I have removed it.** It said "if you have no such place, your home folder is fine." Given the one-level rule, cloning into your home folder would make `Documents`, `Downloads` and `Desktop` candidate projects. Step 3 now opens *"Put it beside your other projects"* and explains the arrangement in two sentences.

**Three edits followed from your question:** the sample paths now read `/Users/you/projects/…` so no folder name looks required; step 4's paragraph says plainly that `your repositories` is the folder that will be watched and that the name is just an example; and *Less usual cases* states the one-level rule with the failing example spelled out.

**Also fixed, from your previous message:** `repo:` / `repos:` / `target:` are gone. **install.sh:58-60** now prints `this tool:` / `your repositories:` / `configuring:`. I verified with `bash -n` and a `--check` run under a sandbox `HOME`; I have **not** run it against your live install.

#### DECISIONS

- Fixed the labels in **install.sh** rather than papering over them in the doc — the reader meets the script's own words the moment they run it. No flag or behaviour changed, so `claude-config-public`'s generated section still holds.
- P2 and P3 logged in **SESSIONS/2026-08-18_2306_EDT_cornillon-laptop.md** and **LOG.md**; Task #20 still `doing`. Nothing committed.

**ASK 1:** Should step 3 go further and tell someone with no single projects folder to *make* one (`mkdir ~/projects`), or is "put it beside your other projects" enough?

RESPONSE COMPLETE

### Notes

**It does not, and the rewrite had made it look as if it did** — every example path read
`/Users/you/Git_Repos/…`, which is Peter's own folder name and nothing more.

**Worse, my own step 3 was wrong.** It said *"go to wherever you keep projects — if you have
no such place, your home folder is fine"*. **Read from the code, not assumed:**
`loadRepos` (`desktop_dashboard.lua:763`) lists the **immediate children** of each root and
`repoForPath` matches `<root>/<project>/…` — one level, never recursive. So cloning into the
home folder would make every folder in it — `Documents`, `Downloads`, `Desktop` — a
candidate project. That advice is removed.

**What the doc now says**, in three places: step 3 opens *"Put it beside your other
projects"* and explains the one-folder arrangement; step 4's paragraph says the middle line
is the folder that will be watched and that the name is only an example (the sample paths
now read `/Users/you/projects/…`); and *Less usual cases* states the one-level rule outright,
with `~/work/repos/2026/my-analysis` as the case that is **not** found.

**Still true and unchanged:** the clone can go anywhere. Its location matters only because
its parent folder is the default guess for where the projects are, and `--repos` overrides
that.

## P5 · 2026-08-18 23:58 EDT · tell the reader to make the folder, and call it `Git_Repos`

### Prompt

> Ask 1. I would tell the user to make one and that Git_Repos is a good name and makes debugging easier if you end up working with Peter on it.

### Response

_[Bash: python3 - <<'EOF' p='INSTALL.md'; s=open(p).read() old = """**Put it beside your other …]_

The sample in step 4 should now match what someone following step 3 will actually see.

_[Bash: python3 - <<'EOF' p='INSTALL.md'; s=open(p).read() s=s.replace("""this tool: /Users/you…]_

_[Bash: python3 - <<'EOF' open('SESSIONS/2026-08-18_2306_EDT_cornillon-laptop.md','a').write(""…]_

#### Findings

Step 3 now tells the reader to create the folder, recommends the name, and gives your reason:

> **If you don't already have such a folder, make one now:** `mkdir -p ~/Git_Repos` … Any name works, but `Git_Repos` is the one I use, and using the same one makes life easier if you ever end up sorting out a problem with me — the paths in your setup and in my notes will match.

It still says what to do if they already keep projects elsewhere, so nobody with a working arrangement is told to rebuild it.

**One thing I changed back:** step 4's sample output reads `/Users/you/Git_Repos/…` again. I had switched it to `projects` an hour ago precisely to stop `Git_Repos` looking mandatory — but with step 3 now recommending that name, an example disagreeing with the step above it is the worse confusion. The sentence under the block carries that job in prose instead: the name doesn't matter, this is just what the line looks like if you followed step 3.

#### DECISIONS

- P4 logged in the session log and **LOG.md**. Task #20 remains `doing`.
- Uncommitted: **INSTALL.md**, **install.sh**, **LOG.md**, **STATUS.md**, **TASKS.md**, and the new session log.

**ASK 1:** Commit these now, or do you want another read of **INSTALL.md** first?

RESPONSE COMPLETE

### Notes

Peter's answer to ASK 1: make the folder, recommend the name, and give the reason —
**matching path names makes a problem easier to sort out with him later**. Step 3 now carries
`mkdir -p ~/Git_Repos` and that reason, with "any name works" kept so it does not read as a
requirement again (P4).

**Step 4's sample went back to `Git_Repos`.** P4 had changed it to `/Users/you/projects/…`
to break the impression that the name was required; with step 3 now recommending
`Git_Repos`, an example that disagrees with the step just above it is worse. The sentence
under it does the same work in prose — the name does not matter, this is just what the line
looks like if you followed step 3.

## P6 · 2026-08-19 00:10 EDT · commit it

### Prompt

> Ask 1: Yes commit.

### Response

_[Bash: CONFIG=$(dirname "$(dirname "$(readlink ~/.claude/commands)")"); echo "$CONFIG"; ls -l …]_

Rebuilding the session log's verbatim sections before committing.

_[Bash: cp SESSIONS/2026-08-18_2306_EDT_cornillon-laptop.md /private/tmp/claude-502/-Users-pete…]_

The rebuild shifted my subject lines — the interrupted prompts count as prompts. Inspecting before fixing.

_[Bash: sed -n '92,110p;150,200p' SESSIONS/2026-08-18_2306_EDT_cornillon-laptop.md]_

_[Bash: python3 - <<'PY' import re p='SESSIONS/2026-08-18_2306_EDT_cornillon-laptop.md' s=open(…]_

_[Bash: python3 - <<'PY' p='SESSIONS/2026-08-18_2306_EDT_cornillon-laptop.md' s=open(p).read() …]_

_[Bash: python3 - <<'PY' p='TASKS.md'; s=open(p).read() s=s.replace("**Status:** doing — rewrit…]_

_[Bash: git add INSTALL.md install.sh LOG.md STATUS.md TASKS.md SESSIONS/2026-08-18_2306_EDT_co…]_

Committed as `121194c`; working tree is clean. I did not push — you said commit, not commit and push.

#### Findings

**What went into the commit:** **INSTALL.md**, **install.sh** (the three relabelled output lines), **LOG.md**, **STATUS.md**, **TASKS.md**, and the new **SESSIONS/2026-08-18_2306_EDT_cornillon-laptop.md**. Nothing else in the tree was touched.

**The session log is a full transcript now.** I ran `session-transcript.sh` before committing, which rebuilt every prompt and response verbatim. It shifted my hand-written subject lines by one entry — **both of your interrupted prompts count as prompts**, so the accidental return became its own `P3` — so I realigned the subjects and `Notes` blocks and renumbered the matching `LOG.md` lines. The Git_Repos question is `P4`, not `P3`.

**Task #20 is `done (2026-08-19)`**, and `STATUS.md`'s active thread now records the complaint as closed rather than open.

**Still not done, and it is the same gap as before:** none of this has been run against your live install. The relabelled output was only verified under a sandbox `HOME`, so `./install.sh --check` on this machine remains the safe first move whenever you want to confirm the real thing.

RESPONSE COMPLETE

## P7 · 2026-08-19 00:28 EDT · what commands should the student run to update his install?

### Prompt

> What commands should my student use to complete the installation on his machine? He has already cloned claude-switchboard but it will need to be updated. And he hs Hammperspoon running. He also has an old version on his computer. Is a git pull enough and then

### Response

Checking what's actually on the remote — that determines whether a `git pull` gets him anything.

_[Bash: git log --oneline -1 origin/main 2>/dev/null; echo "--- unpushed ---"; git log --onelin…]_

_[Bash: grep -n 'M.version' desktop_dashboard.lua | head -3; git remote -v | head -2]_

#### Findings

**First, a blocker on your side: today's commit is not pushed.** `origin/main` is still at `fc4959c`. A `git pull` right now gets him `install.sh` (that was pushed yesterday) but **not** the rewritten `INSTALL.md` and not the `this tool:` / `your repositories:` labels — so he'd be reading the confusing version while you talked him through the new one.

**Then yes, `git pull` plus two commands.** From inside his clone:

```sh
git pull
./install.sh --check
```

`--check` writes nothing. It reports which of two situations he is in, and that decides the next command:

- If it says **`DIFF … loads desktop_dashboard outside the markers too`**, his `init.lua` has an old by-hand install in it. He runs `./install.sh --upgrade`, which backs the file up, prints every line it removes, and writes the new block in place of them.
- **Anything else** — `MISS … does not exist`, `MISS … has no claude-switchboard block`, or an `OK` that just needs repointing — he runs plain `./install.sh`.

Then, for the red dot:

```sh
./install.sh --hooks
```

**Two things that need no action from him**, because the script handles them: an old `~/.hammerspoon/desktop_dashboard.lua` is moved aside to `.stale.bak` automatically (line 144), and Hammerspoon is restarted at the end. That last part matters given it's already running — he does not need to quit it first.

**Afterwards:** his existing `claude` sessions won't have the hook, since Claude Code reads that configuration at session start, so he should start a fresh one. Then **⌘⌃⌥s** to label every Desktop. The Hammerspoon Console should say `desktop_dashboard v65 … loaded` — if it says something older, the stale copy is still winning.

**One thing to check with him first:** if he cloned before 2026-08-12 his folder is probably still called `Desktop_Dashboard`. `git pull` will work (GitHub redirects the old URL) and `install.sh` derives its paths from wherever the folder actually is, so nothing breaks — but the folder name will disagree with everything you say to him. Cleaner to have him `git clone` fresh into `~/Git_Repos/claude-switchboard` and delete the old folder after `install.sh` runs.

**What I have not verified:** none of this has been run on his machine or yours — the sandbox runs are the only evidence. `--check` is safe to run first precisely because it never writes.

#### DECISIONS

- Recommending `--check` before choosing between plain install and `--upgrade`, rather than having him guess from what he remembers installing.

**ASK 1:** Shall I push `121194c` now, so his `git pull` actually gets the rewritten instructions?

RESPONSE COMPLETE

## P8 · 2026-08-19 00:30 EDT · push it

### Prompt

> Ask 1. Yes

### Response

_[Bash: git push origin main 2>&1 | tail -3; echo "---"; git log --oneline -1 origin/main]_

### Notes

**The answer had a blocker in front of it:** `origin/main` was still at `fc4959c`, so the
student's `git pull` would have brought `install.sh` (pushed 2026-08-18) but neither the
rewritten `INSTALL.md` nor the relabelled output — he would have been reading the confusing
version while Peter talked him through the new one. Pushed on Peter's word in P8;
`origin/main` is `121194c`.

**The sequence given**, and why `--check` comes before the choice rather than after it:
`git pull`, then `./install.sh --check`, which writes nothing and distinguishes the two
cases his machine could be in. `DIFF … loads desktop_dashboard outside the markers too`
means an old by-hand install in `init.lua` and calls for `./install.sh --upgrade`; anything
else takes plain `./install.sh`. Then `./install.sh --hooks`, a fresh `claude` session
(Claude Code reads hook configuration at session start), and ⌘⌃⌥s.

**Two things deliberately left out of his instructions, because the script does them:** an
old `~/.hammerspoon/desktop_dashboard.lua` is moved to `.stale.bak` (`install.sh:144`), and
Hammerspoon is restarted at the end — he does not have to quit it first, which was worth
saying since his is already running.

**One thing flagged rather than solved:** a clone older than 2026-08-12 sits in a folder
called `Desktop_Dashboard` (D92). `git pull` still works through GitHub's redirect and
`install.sh` derives its paths from wherever the folder is, so nothing breaks — but the name
disagrees with everything Peter would say to him, so a fresh clone is cleaner.

**Unverified, and said so:** none of this has been run on the student's machine or on
Peter's. `--check` is the safe first move precisely because it never writes.

