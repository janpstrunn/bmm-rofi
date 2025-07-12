# bmm-rofi: Orchestrate your Bookmarks

`bmm-rofi` is an efficient `rofi` script designed to manage bookmarks by [bmm](https://github.com/dhth/bmm).

## Features

- **CRUD**: Add, edit and delete bookmarks.
- **Select by tags**: Show only bookmarks with a certain tag.

## Requirements

- [bmm](https://github.com/dhth/bmm)
- [rofi](https://github.com/davatorium/rofi)

## Installation

Note: You will have to compile `bmm` from source first.

```bash
git clone https://github.com/janpstrunn/bmm-rofi
cd bmm-rofi
chmod 700 src/bmm-rofi
mv src/bmm-rofi "$HOME/.local/bin"
```

### Using Nix

Note: You still need to compile `bmm` from source first.

````bash
nix run github:janpstrunn/bmm-rofi ```

## Notes

This script has been only tested in a Linux Machine.

## License

This repository is licensed under the MIT License, a very permissive license that allows you to use, modify, copy, distribute and more.
````
