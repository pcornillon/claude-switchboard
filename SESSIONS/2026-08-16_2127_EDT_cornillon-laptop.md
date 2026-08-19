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

## P31–P36 · 2026-08-18 18:22–22:05 EDT · the installer meets a real machine

### Notes

Three defects that four sandbox `HOME`s could not show, all found by pointing the script
at `cornillon-laptop`:

1. **A hand-written loader** in `init.lua` — appending the block would have set
   `package.path` twice and called `dd.start()` twice. The script refuses; `--upgrade`
   replaces it.
2. **The `hs.ipc` bridge was missing from the block.** Peter's `init.lua` had
   `require("hs.ipc")` and `_G.dd = dd`; upgrading would have silently cost him
   `hs -c "return dd.version"`. The bridge is now written by default.
3. **Appending to an empty file** left stray blank lines. An empty file is a blank sheet.

His `init.lua` was migrated in this session — original at `init.lua.hand-install.bak` —
and verified against the **running** instance rather than the file: `dd.version` → `v65`,
`dd.repoRoots` → the configured root.

`INSTALL.md` went through four structures. What Peter rejected, in order: conditionals
inlined in step 4; the by-hand alternative kept beside the command; step 4 describing an
existing `init.lua` while step 5 said the script stops (a real contradiction — two
different files, neither named); and skip-bullets placed before the cases they refer to.
**His verdict on the fourth is that it is still too long**, which is where this leaves off.
