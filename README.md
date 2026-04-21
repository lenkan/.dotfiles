# New WSL distro setup

```powershell
wsl --install Ubuntu-24.04 --name <distroname>
```

Password can be anything (bootstrap removes it).

```bash
git clone https://github.com/lenkan/.dotfiles ~/.dotfiles
```

```bash
~/.dotfiles/scripts/bootstrap.sh
```

```powershell
wsl --terminate <distroname>
```
