# Lua Project Template

# 1. Introduction
Boilerplate folder structure for `lua` projects.

# 2. Dependencies
1. `Lua`
2. `luarocks`
3. `luacheck`
4. `stylua`

## 2.1 Debian
```sh
# TODO
```

## 2.2 Arch
```sh
sudo pacman -S lua luarocks
sudo luarocks install luacheck
cargo install stylua # needs rust installed
paru -S stylua       # or available at the AUR
```

# 3. Getting Started
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
