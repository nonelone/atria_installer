# 🌠 Atria installer  
Atria installer is a lua post-install script created to quickly configure any Arch-based OS.  

### What it does:
- adds additional repos to `pacman.conf`
- installs packages
- (optional) configures firefox
- (optional) installs my config files
- (optional) modifies `os-release` & `lsb-release`

### Requirements:
- any Arch-based distro
- lua

### Usage:
`git clone https://github.com/nonelone/atria_installer`  
`cd atria_installer`  
`lua installer.lua`

**Name inspiration**: [Atria](https://en.wikipedia.org/wiki/Alpha_Trianguli_Australis) is a star in [Triangulum Australe](https://en.wikipedia.org/wiki/Triangulum_Australe) constellation. I like space themes and since the script is written in [Lua](https://lua.org) - Portuguese for "Moon" - I think it fits the theme quite well.