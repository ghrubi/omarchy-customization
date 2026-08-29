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
