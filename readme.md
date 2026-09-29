# Dotfiles

Personal dotfiles for Linux (CachyOS + Hyprland) and macOS, managed with
[dotbot](https://github.com/anishathalye/dotbot).

`./install` always applies `shared.conf.yaml`, then `linux.conf.yaml` or
`mac.conf.yaml` depending on the OS.

## Linux

Targets CachyOS with the Hyprland edition. Other Arch-based distros should work,
but the base Hyprland stack (hyprland, hyprlock, hyprpaper, ...) must already be
installed.

1. Install base tools:

   ```bash
   sudo pacman -S --needed git zsh base-devel
   ```

2. Install [yay](https://github.com/Jguer/yay) for AUR packages (optional,
   AUR packages are skipped without it).

3. Clone the repo:

   ```bash
   git clone --recursive https://github.com/JorenRothman/.dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

4. Install packages:

   ```bash
   ./linux/packages.sh
   ```

5. Link the dotfiles:

   ```bash
   ./install
   ```

6. Make zsh the default shell and log out/in:

   ```bash
   chsh -s "$(which zsh)"
   ```

## macOS

1. Install the Xcode command line tools:

   ```bash
   xcode-select --install
   ```

2. Install [Homebrew](https://brew.sh):

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. Clone the repo:

   ```bash
   git clone --recursive https://github.com/JorenRothman/.dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

4. Link the dotfiles (this also links `~/.Brewfile`):

   ```bash
   ./install
   ```

5. Install packages from the Brewfile:

   ```bash
   brew bundle --global
   ```

6. Open a new terminal. zsh is the default shell on macOS.

## SSH keys

`./install` pulls SSH keys from Bitwarden unless `~/.ssh/id_ed25519` already
exists. Log in with the [Bitwarden CLI](https://bitwarden.com/help/cli/) first:

```bash
bw login
export BW_SESSION=$(bw unlock --raw)
./install
```

## Claude skills

Global Claude skills are restored from `~/.agents/.skill-lock.json` via `npx`.
Install Node first; the step is skipped if `npx` is missing. Re-run with:

```bash
sh ./scripts/shared/setup-claude-skills.sh
```

## Shell

zsh runs without a framework. Plugins are git submodules in
`shared/zsh/plugins`, the prompt is [starship](https://starship.rs), and extra
config goes in `shared/zsh/config.d/*.zsh` (or the `linux/` / `mac/`
equivalents), which is sourced automatically.
