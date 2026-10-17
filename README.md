# Dotfiles

Shared configs live at the root. `linux/`, `wsl/` and `macos/` hold what only applies there.

## WSL

```powershell
wsl --install Ubuntu-24.04 --name <distroname>
wsl --install FedoraLinux-44 --name <distroname>
```

Password can be anything (bootstrap removes it).

```bash
sudo dnf install -y git                             # Fedora
sudo apt-get update && sudo apt-get install -y git  # Ubuntu

git clone https://github.com/lenkan/.dotfiles ~/.dotfiles
~/.dotfiles/wsl/bootstrap.sh
```

```powershell
wsl --terminate <distroname>
```

## Linux

```bash
git clone https://github.com/lenkan/.dotfiles ~/.dotfiles
~/.dotfiles/linux/bootstrap.sh
```

Optional installers from `linux/bin/` are on `PATH`, e.g. `install-ghostty.sh`.

## macOS

```bash
git clone https://github.com/lenkan/.dotfiles ~/.dotfiles
~/.dotfiles/macos/bootstrap.sh
```

## Machine-specific git config

`~/.gitconfig.local` is included last and overrides `.gitconfig`, e.g. a work identity:

```ini
[user]
	name = ...
	email = ...
	signingkey = ...
```

## Neovim

Needs Neovim 0.12+, ripgrep, gcc, tree-sitter-cli and Node 22+ (Copilot).
Plugins and language servers install on first start; run `:Copilot setup` once.

## Other

- `scripts/sync.sh` — re-link dotfiles
- `scripts/lint.sh` — shellcheck + shfmt
