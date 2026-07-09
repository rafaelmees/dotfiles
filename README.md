# dotfiles

Personal terminal configuration, centralized and version-controlled.

Style: **monochromatic (grayscale)**, in the spirit of
[lackluster](https://github.com/slugbyte/lackluster.nvim) — color only where it
feels natural (syntax highlighting, git status). Grayscale powerline.

## What's here

| Tool | Repo file | System symlink |
|---|---|---|
| **Ghostty** (terminal) | `ghostty/config` | `~/.config/ghostty/config` |
| **Neovim** | `vim/init.lua` | `~/.config/nvim/init.lua` |
| **Starship** (powerline prompt) | `starship/starship.toml` | `~/.config/starship.toml` |
| **mise** (version manager) | `mise/config.toml` | `~/.config/mise/config.toml` |
| **tmux** | `tmux/tmux.conf` | `~/.config/tmux/tmux.conf` |
| **zsh** | `zsh/.zshrc` | `~/.zshrc` |

## Installation

```sh
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./install.sh            # install deps via brew + create the symlinks
```

Flags:

```sh
./install.sh --upgrade  # also run `brew upgrade` on the setup's packages
./install.sh --add-ssh  # also run ./add-ssh.sh to generate SSH keys
```

brew always runs (already-installed packages are skipped, not re-installed);
pass `--upgrade` when you also want to update them.

**Platforms:** works on **macOS** and **Linux** (server/WSL) — CLI tools come from
Homebrew on both. On Linux the GUI bits (ghostty, Nerd Font) are skipped; for the
tmux clipboard, install `xclip` or `wl-clipboard` via your distro.

`install.sh` is **idempotent** and **backs up** any existing file to
`~/.dotfiles-backup/<timestamp>/` before replacing it. Since it uses symlinks,
editing a file here in the repo is immediately reflected on the system.

### SSH keys

`add-ssh.sh` generates SSH keys (ed25519) interactively — handy when you need to
add a key after the initial install. It loops asking for a key name (e.g.
`bitbucket_personal`, `github_personal`), generates each pair, and prints the
public key so you can register it on the remote. Leave the name blank to finish.
Existing keys are never overwritten.

```sh
./add-ssh.sh            # standalone
./install.sh --add-ssh  # or as part of install
```

## Components

### Prompt — Starship (grayscale powerline)
Segments with a gray background and powerline separators (``): directory →
git branch/status → duration of long-running commands. Requires a **Nerd Font**
(`install.sh` installs the JetBrains Mono Nerd Font).

### Version management — mise
Manages tool versions (node, etc.) and automatically switches per directory. It
reads `.nvmrc`, `.tool-versions`, and `mise.toml`. Reading `.nvmrc`/`.node-version`
is enabled via `idiomatic_version_file_enable_tools` in `mise/config.toml`, and a
global node LTS is set as the default. In a project with a `.nvmrc`, run
`mise install` once and the right version is selected automatically from then on.

### Neovim
- Plugin manager: **lazy.nvim**
- Theme: **lackluster** (gray)
- Plugins: telescope, treesitter, gitsigns, lualine, autopairs, neo-tree,
  vim-tmux-navigator
- `<leader>` = `,`

Main shortcuts:

| Shortcut | Action |
|---|---|
| `<C-e>` | Toggle the explorer (neo-tree) |
| `<C-p>` / `,f` | Find files (telescope) |
| `,g` | Live grep |
| `,b` | Open buffers |
| `<C-d>` | Replace the word under the cursor |
| `<C-s>` | Save |
| `gcc` / `gc` | Comment (native to Neovim) |

Commands: `:Convert4SpacesTo2` and `:Convert2SpacesTo4` to reindent.

### tmux
- Prefix: `C-a`
- Pane navigation integrated with vim (`C-h/j/k/l`)
- "Noir" theme (gray), truecolor enabled
- Auto-attach to the `main` session (via `.zshrc`)
- Clipboard yank (`y`) uses `pbcopy` on macOS, `wl-copy`/`xclip` on Linux

### Ghostty
JetBrains Mono, dark background (`#181818`) with slight transparency.
