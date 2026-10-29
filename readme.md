# Dotfiles

Personal dotfiles for Linux (CachyOS + Hyprland) and macOS, managed with
[dotbot](https://github.com/anishathalye/dotbot).

`./install` always applies `shared.conf.yaml`, then `linux.conf.yaml` or
`mac.conf.yaml` depending on the OS.

## Quick start

On a new machine, `bootstrap` runs every step below for you: base tools,
cloning, packages, Bitwarden login, git-crypt unlock, `./install` and the
default shell. It works on both Linux and macOS and is safe to re-run.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/JorenRothman/.dotfiles/main/bootstrap)
```

Set `DOTFILES` to clone somewhere other than `~/.dotfiles`. The manual steps
are below.

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

5. Unlock the encrypted files, see [SSH hosts](#ssh-hosts).

6. Link the dotfiles:

   ```bash
   ./install
   ```

7. Make zsh the default shell and log out/in:

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

4. Unlock the encrypted files, see [SSH hosts](#ssh-hosts).

5. Link the dotfiles (this also links `~/.Brewfile`):

   ```bash
   ./install
   ```

6. Install packages from the Brewfile:

   ```bash
   brew bundle --global
   ```

7. Open a new terminal. zsh is the default shell on macOS.

## SSH keys

`./install` pulls SSH keys from Bitwarden unless `~/.ssh/id_ed25519` already
exists. Log in with the [Bitwarden CLI](https://bitwarden.com/help/cli/) first:

```bash
bw login
export BW_SESSION=$(bw unlock --raw)
./install
```

## SSH hosts

`shared/ssh/config` is linked to `~/.ssh/config` and includes everything in
`~/.ssh/config.d/`. Host entries go in `shared/ssh/config.d/hosts`, which is
encrypted in the repo with [git-crypt](https://github.com/AGWA/git-crypt).

Unlock the repo **before** running `./install` on a new machine. Otherwise
`~/.ssh/config` includes the still-encrypted file and ssh fails to parse it.

The key is stored base64-encoded in Bitwarden as the secure note
`dotfiles git-crypt key`. To unlock:

```bash
# Linux: sudo pacman -S git-crypt    macOS: brew install git-crypt
bw login
export BW_SESSION=$(bw unlock --raw)

key=$(mktemp)
bw get notes "dotfiles git-crypt key" | base64 -d > "$key"
git-crypt unlock "$key"
rm "$key"
```

Check that the file is readable plain text:

```bash
head shared/ssh/config.d/hosts
```

Once unlocked, files decrypt automatically on `git pull`. Anything new under
`shared/ssh/config.d/` is encrypted on commit. Run `git-crypt status -e` before
pushing to confirm.

## VSCodium

`settings.json`, `keybindings.json` and snippets live in `shared/vscodium` and
are symlinked into the VSCodium user dir on both OSes, so edits from the editor
land in this repo — commit and pull to sync. `./install` also syncs extensions to
`shared/vscodium/extensions.txt`: missing ones are installed, unlisted ones are
uninstalled. Refresh the list with:

```bash
codium --list-extensions > shared/vscodium/extensions.txt
```

New snippet files must be added to `shared/vscodium/snippets` and linked with
`./install`. On a machine with existing config, move the old `settings.json` and
`keybindings.json` out of the way before running `./install`.

## Shell

zsh runs without a framework. Plugins are git submodules in
`shared/zsh/plugins`, the prompt is [starship](https://starship.rs), and extra
config goes in `shared/zsh/config.d/*.zsh` (or the `linux/` / `mac/`
equivalents), which is sourced automatically.
