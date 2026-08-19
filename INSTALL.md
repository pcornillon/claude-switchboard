# Installing Claude Switchboard

How to install Claude Switchboard. Do this once on each Mac you want the panel on.

## Who this is for

Claude Switchboard watches the `claude` sessions you have running and shows, on one
always-visible panel, what each of them is doing. It is for you if you run Claude Code:

- in a **terminal window** — either **Terminal**, the one macOS comes with, or
  **iTerm2**; or
- inside **VS Code**, **Cursor**, or another editor that hosts Claude Code.

All of those work. Sessions in Terminal and iTerm2 are the ones the panel can read most
directly, so they always land on the right Desktop line; everywhere else the panel learns
about the session from Claude Code itself, which is what step 6 sets up.

**It is most useful if you keep several Desktops.** A Desktop (macOS also calls them
Spaces) is a full-screen workspace you switch between with Control-→ and Control-←. If you
have only one or two, the panel still works — but the problem it solves is *"which of my
six sessions stopped to ask me something"*, and that only shows up once you spread work
across Desktops. To add one: press **Control-↑** for Mission Control, then click the **+**
at the top right.

## What you need first

- **macOS.** Built and used on an Intel Mac; it should be fine on Apple Silicon.
- **[Hammerspoon](https://www.hammerspoon.org)** — free, open-source, notarized by Apple.
  Step 1 installs it. **It does not require turning off any macOS security setting.**
- **`git`.** You almost certainly have it; if `git --version` prints a version in a
  terminal window, you are set.
- **Nothing else to install.**

**Two of the six steps only you can do**, because macOS will not let software grant itself
permissions, and because nothing but a person can look at a screen and say whether a panel
appeared: those are **step 2** and **step 5**. A Claude Code session can do the rest for
you — see *[Let Claude Code install it](README.md#let-claude-code-install-it)*.

## The installation

### Step 1 — Install Hammerspoon

In a terminal window:

```sh
brew install --cask hammerspoon
```

If you don't use Homebrew, download it from https://www.hammerspoon.org instead. Either
way, **launch Hammerspoon once** before going on.

### Step 2 — Let Hammerspoon see your windows 🧑

**This one is yours to do.** Open **System Settings → Privacy & Security → Accessibility**
and switch **Hammerspoon** on.

This is the ordinary per-app permission that window tools like Rectangle and Moom also ask
for. It is what lets the panel read which windows are on which Desktop. Without it the
panel still appears, but every Desktop comes out blank or `—`.

### Step 3 — Download Claude Switchboard

**Put it beside your other projects.** The panel watches one folder and treats each folder
directly inside it as a project — so the simplest arrangement is a single folder holding
all your git repositories, with this one among them.

**If you don't already have such a folder, make one now:**

```sh
mkdir -p ~/Git_Repos
cd ~/Git_Repos
```

Any name works, but `Git_Repos` is the one I use, and using the same one makes life easier
if you ever end up sorting out a problem with me — the paths in your setup and in my notes
will match. If you already keep projects together somewhere else, go there instead; step 4
will find it either way. If they are spread over several places, see
*[Less usual cases](#less-usual-cases)*.

From that folder:

```sh
git clone https://github.com/pcornillon/claude-switchboard.git
```

That creates a folder called `claude-switchboard`. Move into it:

```sh
cd claude-switchboard
```

### Step 4 — Run the installer

From inside that folder:

```sh
./install.sh
```

That is the whole step. It asks nothing, works out the paths itself, and tells you what it
did:

```
this tool:         /Users/you/Git_Repos/claude-switchboard
your repositories: /Users/you/Git_Repos
configuring:       /Users/you/.hammerspoon/init.lua

OK   Hammerspoon is installed
WRITE created /Users/you/.hammerspoon/init.lua with the claude-switchboard block
restarted Hammerspoon
```

The three paths are what it worked out for itself, and the middle one is the only one worth
a look. **`your repositories` is the folder the panel will watch**, and it is simply the
folder you cloned into in step 3 — every folder directly inside it counts as a project.
Nothing about the name matters; this is only what that line looks like if you followed step 3.

If your projects live somewhere else, or in more than one place, or you have set Hammerspoon
up by hand before, see *[Less usual cases](#less-usual-cases)* at the end. Most people need
nothing from there.

### Step 5 — Look at the screen 🧑

**This one is yours too:** the panel is an overlay drawn on your screen, and a script
cannot see it.

You should see a translucent panel in a corner of the screen, listing your Desktops.

**If every Desktop label is blank or `—`**, Hammerspoon does not have the permission from
step 2. Go back and grant it. That is the one failure that looks like a bug and isn't.

**If there is no panel at all**, open the Hammerspoon Console from the hammer icon in the
menu bar; it should carry a line reading `desktop_dashboard vNN … loaded`.

### Step 6 — Turn on the red dot

The panel gives each session a colored dot: **yellow** while it is working, **green** when it has
finished, and **red** when it has stopped to ask you something. Red is the one you actually
want, and it is the one that needs a moment of setup — from the outside, a session waiting
on a question looks exactly like one that is done.

From the `claude-switchboard` folder:

```sh
./install.sh --hooks
```

That teaches Claude Code to tell the panel what your sessions are doing. Your existing
Claude Code settings are backed up first and added to, never replaced, and running the
command twice is harmless — it will just say everything is already registered.

**Claude Code reads this setting when a session starts**, so sessions you already have
running won't have it. Start a new one.

**To check it worked:** with a session running, `ls ~/.hammerspoon/claude_state/` should
list one file per live session.

## First run

Press **⌘⌃⌥s** once. The panel walks through every Desktop and labels them all — it has to
visit a Desktop to see what is on it, which is a macOS restriction, not a choice. After
that it keeps itself up to date on its own.

## If something looks wrong

- **No panel, or everything blank:** Hammerspoon is missing the Accessibility permission
  from step 2. Grant it, then click the menu-bar hammer → **Reload Config**.
- **A Desktop stays unlabeled until you go to it:** expected. macOS only lets an app read a
  Desktop's windows while that Desktop is active. Press **⌘⌃⌥s** to fill them all in.
- **The version in the Console is older than you expect,** or behavior seems stale: an old
  copy of the tool is sitting in `~/.hammerspoon/desktop_dashboard.lua` and taking
  precedence. Delete it and reload.
- **To ask whether this machine is still set up correctly**, without changing anything:

  ```sh
  ./install.sh --check
  ```

## Watching the dots change, on purpose

A short rehearsal that makes all three dot colors happen on cue — worth doing once, so you
know what you are looking at later.

**Set it up:** open a terminal on a Desktop of its own, `cd` into one of your repositories,
and start `claude` there. Check that that Desktop's line on the panel shows the repository
name. Then **switch to a different Desktop** and keep the panel in view — the whole point is
watching a session you cannot see. Paste the prompt below into that session.

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

A few notes:

- **Steps 2 and 4 are testing different things.** A question and a permission prompt are
  separate mechanisms inside Claude Code; both should turn the dot red.
- **Step 4 assumes `rm` asks your permission.** If your settings allow it automatically,
  use any command yours does ask about.
- **Red only appears if you did step 6.** Without it, steps 2 and 4 show green instead;
  everything else is the same.
- If no dot appears at all, that Desktop probably isn't labeled with the repository name —
  press **⌘⌃⌥s** and check that the line reads the repository, not `Utility` or an app name.

## Less usual cases

Most people never need this section.

### Your repositories are somewhere else

By default, step 4 watches the folder `claude-switchboard` sits in. If your projects are
elsewhere, name the folder — and you can name more than one:

```sh
./install.sh --repos ~/work/repos --repos ~/Dropbox/projects
```

**Each folder you name is read one level deep.** A project has to sit directly inside it —
`~/work/repos/my-analysis` is found, `~/work/repos/2026/my-analysis` is not. Re-run the
command with different folders whenever this changes; it replaces the setting rather than
adding to it.

### You already had a Hammerspoon setup

**Anything already in `~/.hammerspoon/init.lua` is kept.** Step 4 backs the file up and
adds its own block below whatever you had. That block sits between two marker comments, so
running `./install.sh` again replaces the block rather than adding a second copy — which is
what makes it safe to re-run after a `git pull`.

**One case stops the installer:** an `init.lua` that already loads this panel from an
earlier installation you did by hand. Rather than start the panel twice, it lists those
lines and does nothing. Replace them with:

```sh
./install.sh --upgrade
```

It backs the file up to `init.lua.pre-switchboard.bak`, prints every line it removes, and
writes its own block in their place. **Only the old installation lines go** — your hotkeys,
window rules and everything else stay exactly where they are.

### Other options

<table style="width: 100%; table-layout: fixed;">
<colgroup>
<col style="width: 26%;">
<col style="width: 74%;">
</colgroup>
<thead>
<tr>
<th align="left">Option</th>
<th align="left">What it does</th>
</tr>
</thead>
<tbody>
<tr style="background:transparent;">
<td><code style="background:transparent; padding:0; border:none; border-radius:0;">--check</code></td>
<td>Report what is installed on this machine and change nothing.</td>
</tr>
<tr style="background:transparent;">
<td><code style="background:transparent; padding:0; border:none; border-radius:0;">--no-reload</code></td>
<td>Don't restart Hammerspoon at the end; you will restart it yourself.</td>
</tr>
<tr style="background:transparent;">
<td><code style="background:transparent; padding:0; border:none; border-radius:0;">--no-ipc</code></td>
<td>Leave out the small bridge that lets a command line ask the running panel questions. Harmless either way.</td>
</tr>
</tbody>
</table>

### Setting it up without the installer

`install.sh` writes this into `~/.hammerspoon/init.lua`, and nothing else — you can type it
yourself if you would rather:

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

`init.lua.example` is the same thing with its reasoning. Two things to know:

- **Setting `dd.repoRoots` here is why you never edit `desktop_dashboard.lua`.** It
  overrides the default inside the tool, so a `git pull` can't collide with your own
  settings.
- **An old copy at `~/.hammerspoon/desktop_dashboard.lua` wins over the repository**, so
  move any such file aside.

Then reload Hammerspoon — the menu-bar hammer → **Reload Config**, or:

```sh
osascript -e 'quit app "Hammerspoon"'; /bin/sleep 3; open -a Hammerspoon
```

### Changing anything else

The rest of the settings live in the `CONFIG` block at the top of `desktop_dashboard.lua`;
the Configuration section of `README.md` lists them.
