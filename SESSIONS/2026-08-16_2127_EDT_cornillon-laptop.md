# Session — 2026-08-16 21:27 EDT · cornillon-laptop

<!-- session: 0af73f11-3784-40dd-97fd-af5c842cab5c -->

Repo: `claude-switchboard`. Lane: `install.sh`, `INSTALL.md`, `README.md`, and the spine.

**This is one repo's share of a session that ran mostly in `claude-config`** (D34). The
session started there on 2026-08-16 and reached this repo on 2026-08-18; the verbatim
transcript of every prompt lives in
`claude-config/SESSIONS/2026-08-16_2127_EDT_cornillon-laptop.md`, under the same session
id. **`session-transcript.sh` cannot produce a scoped log** — it rebuilds every prompt of
a session into whichever file it is pointed at — so this log is written by hand and holds
only what happened here.

## P30 · 2026-08-18 17:24 EDT · Step 4 of INSTALL.md is beyond confusing

### Notes

Peter, after installing with a student: *"Instruction 4 in the INSTALL.md file is beyond
confusing … Can't we assume that they are installing for the first time and then say
exactly what they will find rather than the conditionals. And, make the folder name
changes automatic or a query."*

Diagnosed as structural rather than editorial and recorded as **D93**: step 4 offered two
mechanisms, warned about two files that might not exist, and hard-coded `~/Git_Repos` in
the one line that has to be right. A script knows all four answers; a first-time reader
knows none of them.

`install.sh` written and exercised against four sandbox `HOME`s — Task #19 has the
results. `--hooks` covers the red dot, which was worse than step 4: five hook entries
hand-merged into `~/.claude/settings.json`.

**Not run for real on this machine.** Peter's `init.lua` is live and his
`~/.claude/settings.json` is a symlink into `claude-config` with the hook already
registered. Left for him.
