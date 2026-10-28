# Set up my Windows PC terminal to feel like my Mac

You are Claude Code running on my freshly installed Windows gaming PC. Make the terminal look and feel like my Mac's using the configs in this repo. This PC is mainly for gaming, so **don't install language toolchains, SDKs, Docker, Python/Node/Bun, Ollama, etc.** Install only what the terminal needs. **Don't edit any existing file in this repo** (it's shared with Mac/Linux); the Windows files live in `conf/windows/`. At the end, tell me what you did and anything that didn't work.

I've already said yes to: installing software from winget, MSYS2/pacman and GitHub; setting the `MSYS2_PATH_TYPE` user env var; editing `C:\msys64\etc\nsswitch.conf`; writing my fish config and running `script/baby.sh`/`chafa` from this repo. Ask before anything else risky (registry edits beyond that, uninstalling things).

## What's in `conf/windows/`

| File | Goes to |
|---|---|
| `alacritty.toml` | `%APPDATA%\alacritty\alacritty.toml` |
| `windows-terminal.json` | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json` |
| `config.fish` | `~/.config/fish/config.fish` |
| `logo.jpg` | source image for the fastfetch greeting logo (`~/.ans`) |

## Steps

### 0. Make sure winget works
Run `winget --version`. On a debloated install it can fail with **"No applicable app licenses found"** (no Microsoft Store, old App Installer). Fix: download the latest release from `https://api.github.com/repos/microsoft/winget-cli/releases/latest` — the `.msixbundle`, the `*_License1.xml`, and `DesktopAppInstaller_Dependencies.zip` — check the bundle's SHA256 against the published `.txt`, then (admin PowerShell):
```powershell
Add-AppxProvisionedPackage -Online -PackagePath <msixbundle> -DependencyPackagePath <x64 .appx files from the deps zip> -LicensePath <License1.xml>
```
winget then lives at `%LOCALAPPDATA%\Microsoft\WindowsApps\winget.exe`.

### 1. Install with winget
Use `--scope user` where possible; if a package fails with it, retry without.
`Git.Git`, `GitHub.cli`, `DEVCOM.JetBrainsMonoNerdFont`, `MSYS2.MSYS2`, `eza-community.eza`, `sharkdp.fd`, `BurntSushi.ripgrep.MSVC`, `chmln.sd`, `sharkdp.bat`, `Fastfetch-cli.Fastfetch`, `zyedidia.micro`, `Byron.dua-cli` (the `cd` auto-list calls `dua` unguarded), `Alacritty.Alacritty`, `Microsoft.WindowsTerminal`.

First check whether **Ghostty** has an official Windows release now. If it does, use it instead of Alacritty and translate `conf/windows/alacritty.toml` into a Ghostty config (black background, copy-on-select, no decorations, JetBrainsMono NF, launch MSYS2 fish).

The font installs as family **`JetBrainsMono NF`** (not "JetBrainsMono Nerd Font").

### 2. Git
`git config --global user.name lmqzzz`, `user.email laiminhquang3326@gmail.com`, `init.defaultBranch main`. Leave `gh auth login` to me (it's interactive).

### 3. fish via MSYS2
- Run in `C:\msys64\usr\bin\bash.exe -lc` with `MSYSTEM=UCRT64`: `pacman -Syu --noconfirm` **twice** (the first pass updates the core and exits), then `pacman -S --noconfirm --needed fish ncurses mingw-w64-ucrt-x86_64-fortune-mod mingw-w64-ucrt-x86_64-chafa`. The main mirror sometimes returns 503; pacman falls back to other mirrors on its own.
- In `C:\msys64\etc\nsswitch.conf` change `db_home: cygwin desc` → `db_home: windows` so `~` is `C:\Users\<me>`.
- Set user env var `MSYS2_PATH_TYPE=inherit` so fish sees winget tools and `claude`.
- This repo should already be at `~/arch` (I cloned my fork there). If not, clone it.
- Copy `conf/windows/config.fish` to `~/.config/fish/config.fish` (overwrite fish's default stub).
- Generate the greeting logo:
  ```sh
  chafa -f symbols --symbols vhalf --colors full --size 90x45 --animate off --polite on ~/arch/conf/windows/logo.jpg > ~/.ans
  ```
  (`~/arch/script/baby.sh > ~/.ans` gives the repo's original logo instead.)

### 4. Terminal configs
- Copy `conf/windows/alacritty.toml` to `%APPDATA%\alacritty\alacritty.toml`. Fix `[general] working_directory` if my Windows username isn't `Admin`. Validate with `alacritty migrate --dry-run -c <file>`.
- Copy `conf/windows/windows-terminal.json` to the Windows Terminal `LocalState\settings.json` (create the folder if it's missing). It adds a "fish" profile set as default, black background, JetBrainsMono NF, copyOnSelect.

### 5. Verify
Test from a shell whose PATH is reloaded from the registry (`[Environment]::GetEnvironmentVariable('Path','Machine')+';'+...('User')`) — a shell started before the installs has a stale PATH and fish will report `git`/`sd` missing when they're actually fine. Put fish test commands in a `.fish` file and `source` it; PowerShell 5.1 mangles quotes passed inline to fish/bash.

Confirm:
1. fish starts with **no** errors or warnings.
2. The greeting shows: calendar, fortune quote, fastfetch with the logo, and "The future depends on what you do today."
3. The prompt shows the git branch (magenta) inside a repo and the path (yellow).
4. `cd` into a folder auto-lists it. **Known test artifact:** when fish is run with a non-terminal stdin, eza reads paths from stdin and prints nothing — that's not a bug; it works in a real terminal window.
5. `claude --version` and `git --version` work from fish.

## Known Windows quirks (already handled in `config.fish`)
- `my.fish` runs `abbr pacdep $pacdep` but only sets `pacdep` on macOS → `config.fish` sets it **before** sourcing `my.fish`.
- `lolcrab` isn't packaged for Windows. `center`/`centerf` pipe through `$rainbow | head -n -1`, which relies on lolcrab's trailing newline, so plain `cat` would delete the quote and closing line → `config.fish` uses a `cat; echo` fallback.
- `dysk` doesn't exist on Windows; `my.fish` already guards it.
