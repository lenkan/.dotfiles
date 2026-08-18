# Dotfiles

## New distro

```powershell
wsl --install Ubuntu-24.04 --name <distroname>
wsl --install FedoraLinux-44 --name <distroname>
```

Password can be anything (bootstrap removes it).

```bash
sudo dnf install -y git                             # Fedora
sudo apt-get update && sudo apt-get install -y git  # Ubuntu

git clone https://github.com/lenkan/.dotfiles ~/.dotfiles
~/.dotfiles/scripts/bootstrap.sh
```

```powershell
wsl --terminate <distroname>
```

## Optional installers

```bash
install-nodejs.sh   install-deno.sh    install-rust.sh   install-uv.sh
install-aws.sh      install-gcloud.sh  install-docker.sh install-code.sh
```

## Other

- `scripts/sync.sh` — re-link dotfiles
- `scripts/lint.sh` — shellcheck + shfmt
