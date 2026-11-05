# Dotfiles

Shared configs live at the root. `linux/`, `wsl/` and `macos/` hold what only applies there.

## Install

```bash
git clone https://github.com/lenkan/.dotfiles ~/.dotfiles
~/.dotfiles/linux/bootstrap.sh  # or macos/bootstrap.sh, wsl/bootstrap.sh
```

On Linux and WSL, optional installers from `linux/bin/` are on `PATH`, e.g. `install-ghostty.sh`.

### WSL

Create the distro first. The password can be anything (bootstrap removes it).

```powershell
wsl --install Ubuntu-24.04 --name <distroname>
wsl --install FedoraLinux-44 --name <distroname>
```

Inside it, install git before running the steps above:

```bash
sudo dnf install -y git                             # Fedora
sudo apt-get update && sudo apt-get install -y git  # Ubuntu
```

Then restart the distro:

```powershell
wsl --terminate <distroname>
```

## Machine-specific config

These optional files live outside the repo and override the shared config:

- `~/.gitconfig.local`, e.g. a work `[user]`
- `~/.bashrc.local`, for interactive shells only
- `~/.nvim.local.lua`, runs after plugins are set up

## Neovim

Needs Neovim 0.12+, ripgrep, gcc, tree-sitter-cli and Node 22+ (Copilot).
Plugins and language servers install on first start; run `:Copilot setup` once.

## Other

- `scripts/sync.sh` — re-link dotfiles
- `scripts/lint.sh` — shellcheck + shfmt
