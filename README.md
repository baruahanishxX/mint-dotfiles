# My Linux Mint Dotfiles 💻

Welcome to my personal dotfiles repository! This repo contains the configuration files I use to customize my daily driver. It is managed using **GNU Stow** for easy installation and version control.

## 🛠️ My Setup
* **OS:** Linux Mint
* **Desktop Environment:** XFCE
* **Terminal:** Kitty (Configured with a Nord color scheme, 85% opacity, and JetBrainsMono Nerd Font)
* **Status Bar:** Polybar
* **Dotfile Manager:** GNU Stow

##  Installation

If you want to replicate this setup on a new machine, follow these steps:

**1. Clone the repository:**
```bash
git clone [https://github.com/baruahanishxX/mint-dotfiles.git](https://github.com/baruahanishxX/mint-dotfiles.git) ~/dotfiles
cd ~/dotfiles

2. Install GNU Stow (if not already installed):
sudo apt update && sudo apt install stow

3. Stow the configs:
Use stow to create symlinks in your ~/.config directory. For example, to install the Kitty and Polybar configs:
stow kitty
stow polybar

