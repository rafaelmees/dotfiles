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
| **tmux theme** (shared palette) | `tmux/theme.conf` | `~/.config/tmux/theme.conf` |
| **zsh** | `zsh/.zshrc` | `~/.zshrc` |

## Installation

```sh
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./install            # install deps via brew + create the symlinks
```

Flags:

```sh
./install --upgrade         # also run `brew upgrade` on the setup's packages
./install --add-ssh         # also run ./add-ssh to generate SSH keys
./install --install-claude  # also run ./claude/install (Claude Code + plugins)
./install --install-fleet   # also run ./fleet/install (git worktree manager)
./install --primary 111 --secondary 24   # recolor the theme (see Colors)
```

**Install only what you want.** Each component is its brew package(s) plus its
symlinks: `tmux`, `neovim` (alias `vim`), `starship`, `mise`, `ghostty`, `fonts`,
`mediakeys`, `zsh`. Pick a subset with:

```sh
./install --skip tmux              # everything except tmux
./install --only zsh,neovim        # just these two
```

(`ghostty`/`fonts`/`mediakeys` are macOS-only and ignored on Linux.)

**Already have a `.zshrc` you don't want to lose?** By default `install` replaces
`~/.zshrc` with a symlink (backing up the old file first). Pass `--keep-zshrc` to
instead keep your `~/.zshrc` and append a small guarded block that sources ours —
your own config stays, this setup layers on top:

```sh
./install --keep-zshrc
```

The appended block is delimited by `# >>> dotfiles zsh ... >>>` markers, so re-runs
don't duplicate it and you can remove it by hand anytime.

Every run also creates `~/Development/projects` (the standard place for your repos).

brew always runs (already-installed packages are skipped, not re-installed);
pass `--upgrade` when you also want to update them.

**Platforms:** works on **macOS** and **Linux** (server/WSL) — CLI tools come from
Homebrew on both. On Linux the GUI bits (ghostty, Nerd Font) are skipped; for the
tmux clipboard, install `xclip` or `wl-clipboard` via your distro.

`install` is **idempotent** and **backs up** any existing file to
`~/.dotfiles-backup/<timestamp>/` before replacing it. Since it uses symlinks,
editing a file here in the repo is immediately reflected on the system.

### SSH keys

`add-ssh` generates SSH keys (ed25519) interactively — handy when you need to
add a key after the initial install. It loops asking for a key name (e.g.
`bitbucket_personal`, `github_personal`), generates each pair, and prints the
public key so you can register it on the remote. Leave the name blank to finish.
Existing keys are never overwritten.

```sh
./add-ssh            # standalone
./install --add-ssh  # or as part of install
```

### Claude Code + plugins

`claude/install` installs the [Claude Code](https://claude.ai/code) terminal
CLI, links a versioned personal config, and installs three community
**token-saving** tools.

**Linked config** (symlinks, like everything else here — edit the repo file and
it's live):

| Repo file | System symlink | What it holds |
|---|---|---|
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Personal instructions for **all** projects: code style, working agreements, quality gates, engineering principles. |
| `claude/templates/ROADMAP.md` | — (copy into a new project) | Skeleton for a project roadmap: structure, batch workflow, specs/prompts/notes, with templates. |
| `claude/settings.json` | `~/.claude/settings.json` | Vim mode, a permission allowlist (fewer prompts), and the status line. |
| `claude/statusline.sh` | `~/.claude/statusline.sh` | Grayscale **powerline** status line (pills + `` arrows, same style as the tmux bar): `vim mode ▸ model ▸ dir ▸ branch* ▸ ctx %`. Needs a Nerd Font, like tmux. |

**Token-saving tools**, each working at a different layer:

| Tool | What it does |
|---|---|
| [**rtk**](https://github.com/rtk-ai/rtk) | Compresses noisy command output (git, tests, `ls`, `grep`, …) before it reaches the model, via a global hook (`rtk init -g`). |
| [**caveman**](https://github.com/JuliusBrussee/caveman) | Cuts output tokens with terse "caveman-speak" replies. Its installer auto-configures every detected agent. |
| [**ponytail**](https://github.com/DietrichGebert/ponytail) | A "lazy senior dev" skill that pushes minimal, YAGNI-friendly code. Installed as a Claude Code plugin. |

```sh
./claude/install                 # standalone (Claude CLI + config always; then the plugins)
./install --install-claude       # or as part of install
./claude/install --skip caveman  # skip a plugin — components: jq, rtk, caveman, ponytail
./claude/install --only rtk      # or install just one
```

Safe to re-run — each step skips work that's already done. The Claude CLI and the
versioned config are always set up; `--only`/`--skip` choose among the optional
components (`jq`, `rtk`, `caveman`, `ponytail`). The config is linked **before**
the tools install their hooks, so rtk/caveman/ponytail merge into the versioned
`settings.json` rather than clobbering it. rtk comes from Homebrew when available
(falling back to its install script). Restart Claude Code afterwards so the new
config, hooks and plugins load.

> **Notes:**
> - caveman makes replies read as `me fix bug, me change file` — great for tokens,
>   a bit odd to read. Install without it via `--skip caveman` if it bugs you.
> - caveman also shows a `[CAVEMAN]` status-line badge; if it takes over the
>   custom status line, that's expected — keep whichever you prefer.
> - The tools append their hooks to `settings.json`, so after a real run `git`
>   will show those additions. Commit them or leave them out, your call.

### fleet — git worktree manager

`fleet` manages git worktrees so you can run several agents in parallel, each on
its own branch, without juggling clones. It uses a **"bare + worktrees"** layout:
each repo has one central bare clone (`.bare`) and every agent works in its own
isolated worktree, all sharing the same git objects (saves disk; one fetch
updates them all).

```sh
./fleet/install            # standalone
./install --install-fleet  # or as part of install
```

The installer symlinks `fleet` into `~/.local/bin`, links the shell completion
into `~/.config/fleet/completion.bash` (sourced by `.zshrc`), **asks where to keep
the fleet home** (default `~/Development/fleet`; pass `--home <dir>` to skip the
prompt), and seeds a `repositories.json` from `fleet/repositories.example.json`
there. Edit that file to register your repos:

```json
{
  "repositories": {
    "my-app": {
      "url": "git@github.com:acme/my-app.git",
      "base": "develop",
      "main": "main",
      "postCreate": "npm ci"
    }
  }
}
```

- `url` — clone URL. `base` — branch new worktrees branch off of. `main` — the
  repo's default branch (shown in `fleet repos`). `postCreate` — optional command
  run inside each new worktree (e.g. `npm ci`).
- The fleet home is the path chosen at install time (saved to
  `~/.config/fleet/home`). Precedence: `$FLEET_HOME` env > that saved path >
  the `~/Development/fleet` default.

Commands (`<target>` accepts a branch name, worktree folder, or agent number):

| Command | What it does |
|---|---|
| `fleet add <repo> <branch>` | Create a worktree on a new branch (+ seed `.env`, run `postCreate`). If the branch already exists, offers to open it (or reuse it) instead. |
| `fleet open <repo> <target>` | `cd` into a worktree (via the `fleet` shell wrapper in `.zshrc`). |
| `fleet list [repo]` | List worktrees (`git worktree list`). |
| `fleet status [repo]` | Dashboard: branch, ahead/behind, dirty state, last commit. |
| `fleet each <repo> -- <cmd...>` | Run a command inside every worktree of the repo. |
| `fleet rm [-f] [-b] <repo> <target>` | Remove a worktree, then ask whether to delete its branch (`-b` deletes it without asking, `-f` forces removal). If the worktree is already gone but the branch lingers, offers to delete the branch. |
| `fleet repos` | List configured repos and whether they're cloned. |
| `fleet help` | Full help. |

Tab completion (commands, repo names and worktree folders) works out of the box
in zsh after a new shell.

## Components

### Colors (shared palette)

Starship and tmux draw from **one palette** so the prompt and the status bar never
drift apart. Colors are semantic roles (256-color indices), not raw numbers:

| Token | Role | Default |
|---|---|---|
| `primary` / `on-primary` | highlight bg + its text (selected tab, git branch) | `250` / `239` |
| `secondary` / `on-secondary` | secondary segment bg + its text (session name, clock) | `240` / `252` |
| `surface` / `on-surface` | surface bg + its text (inactive tab, prompt segments) | `237` / `250` |
| `background` / `on-background` | tmux status-bar bg + its text (`on-background` reserved) | `235` / `250` |

`error` (`210`), pane borders (`236`) and dim text (`245`) are fixed, not exposed.

Recolor with flags on the installer — each writes both `starship/starship.toml`
(a native `[palettes.dotfiles]` block) and `tmux/theme.conf`:

```sh
./install --primary 33 --on-primary 231   # e.g. a blue highlight
./install --surface default               # restore one role to its default
```

- Any color flag accepts `default` to reset just that role.
- A plain `./install` **keeps** whatever you last applied — customizations
  persist, so you don't have to repeat the flags every run.
- Changes are picked up on the next prompt (Starship) and by an automatic
  `tmux source-file` at the end of the install (tmux).

### Prompt — Starship (grayscale powerline)
Segments with a gray background and powerline separators (``): directory →
git branch/status → duration of long-running commands. Requires a **Nerd Font**
(`install` installs the JetBrains Mono Nerd Font).

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
- "Noir" theme (gray) from the shared palette (see [Colors](#colors-shared-palette)), truecolor enabled
- Status bar: powerline pills for the session, windows and clock; the current
  window uses the `primary` highlight
- Auto-attach to the `main` session (via `.zshrc`)
- Clipboard yank (`y`) uses `pbcopy` on macOS, `wl-copy`/`xclip` on Linux

### Ghostty
JetBrains Mono, dark background (`#181818`) with slight transparency.
