# Dotfiles

## Wat dis?

"Dotfiles" generally refers to a set of files starting with a dot (e.g. `.bashrc`) which are used to configure various things in a UNIX system.

Putting them in a repository allows you to have a uniform experience across multiple machines!

## Usage

Simply run `./install.sh` to symlink the dotfiles
and, optionally, install some cool tools.

If you want to define extra unversioned aliases,
add them to the `.extra_aliases` file.

## Notable tools included

In no particular order:

- [Homebrew](https://brew.sh) as package manager
- [Topgrade](https://github.com/topgrade-rs/topgrade) to update all the things
- [lsd](https://github.com/lsd-rs/lsd) for a more premium `ls` experience
- [linuxify](https://github.com/pkill37/linuxify) to upgrade some BSD utilities (Mac only)
- [Raycast](https://www.raycast.com) for ultimate productivity (Mac only)
- [nvm](https://github.com/nvm-sh/nvm) bacuase you always need 4-5 different node versions
- [powerlevel10k](https://github.com/romkatv/powerlevel10k) and [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) to pimp your `zsh`
