# mactools

[![Test](https://github.com/szokel/mactools/actions/workflows/test.yml/badge.svg)](https://github.com/szokel/mactools/actions/workflows/test.yml)

Small, inspectable command-line utilities for macOS.

The first tool, `mi-ez-a-hatterkep` (Hungarian for “What is this wallpaper?”), identifies the Apple Aerial wallpaper currently displayed by macOS—including wallpapers selected by Landscape shuffle.

Magyar dokumentáció: [README.hu.md](README.hu.md)

## Usage

```sh
mi-ez-a-hatterkep
```

Example:

```text
Aktuális háttérkép: The Ganges
```

Additional output modes:

```sh
mi-ez-a-hatterkep --dialog
mi-ez-a-hatterkep --details
mi-ez-a-hatterkep --json
```

## Installation

```sh
git clone https://github.com/szokel/mactools.git
cd mactools
./install.sh
```

The installer uses `/opt/homebrew` on Apple silicon when available, otherwise `/usr/local`. Set `PREFIX` to install elsewhere:

```sh
PREFIX="$HOME/.local" ./install.sh
```

## How wallpaper identification works

Apple's Wallpaper process keeps the active Aerial `.mov` file open. The filename is an Apple asset UUID. This tool:

1. inspects the Wallpaper process's open files with the built-in `lsof` utility;
2. extracts the active video's asset UUID;
3. reads Apple's local Aerial catalog at `~/Library/Application Support/com.apple.wallpaper/aerials/manifest/entries.json`;
4. matches the UUID against the catalog and returns its accessibility label.

Everything happens locally and read-only. The command does not modify wallpaper settings or make network requests.

## macOS Shortcuts

Create a Shortcut with a **Run Shell Script** action containing:

```sh
/opt/homebrew/bin/mi-ez-a-hatterkep --dialog
```

The Shortcut can then be pinned to the menu bar or assigned a keyboard shortcut.

## Requirements and limitations

- macOS with Apple Aerial wallpapers
- `/usr/bin/python3` and `/usr/sbin/lsof`
- The current implementation depends on undocumented Apple storage paths, which may change in a future macOS release.
- Only Apple Aerial wallpapers can be identified from the local catalog.
- If the Wallpaper process has no Aerial video open, show the desktop or Lock Screen and try again.

## Development

```sh
zsh -n bin/mi-ez-a-hatterkep
./tests/test_wallpaper_info.zsh
```

## License

MIT
