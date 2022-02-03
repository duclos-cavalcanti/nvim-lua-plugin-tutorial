# Nvim Plugin Tutorial

# 1. Introduction
A learning experience to attempt to create a simple lua plugin for `nvim`. Tutorial and
the great work/explanation can be found [here](https://dev.to/2nit/how-to-write-neovim-plugins-in-lua-5cca)!

# Development

## Dependencies
1. `Lua`
2. `luarocks`
3. `luacheck`
4. `stylua`

### Arch
```sh
sudo pacman -S lua luarocks
sudo luarocks install luacheck
cargo install stylua # needs rust installed
paru -S stylua       # or available at the AUR
```

## Getting Started
1. Run
```sh
make
```

2. Lint
```sh
make lint
# also runs styling check before linting
```
3. Style
```sh
make style
```
