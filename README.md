# Omarchy customization

Clone the Quattro branch and run the installer with the target host profile:

```bash
git clone --branch quattro https://github.com/ghrubi/omarchy-customization.git ~/omarchy-customization
cd ~/omarchy-customization
./install.sh mba-2017
```

The installer checks out the Quattro branch of the dotfiles repository, installs
common and host-specific packages, stows both dotfile layers, and then applies
the corresponding Omarchy customizations.

## Nextcloud home folders

The common installer installs the Nextcloud desktop client and configures
`~/Documents`, `~/Music`, `~/Pictures`, and `~/Videos` as links into a single
`/Home` to `~/Nextcloud` sync connection. It leaves `~/Downloads`, `~/Work`,
`~/Projects`, and MEGA alone.

Nextcloud browser authorization is a one-time interactive step. On a fresh
machine, follow the instructions printed by the installer to create the
`/Home` to `~/Nextcloud` connection, then rerun the installer. Alternatively,
run `common/setup-nextcloud-home.sh --provision` from the repository with
`REPO_ROOT` set to the repository path and enter a temporary Nextcloud app
password when prompted. Credentials are never stored in this repository.
