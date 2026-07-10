#!/usr/bin/env bash
#
# Powerline "noir" status line for Claude Code — same pills-and-arrows style as
# the tmux bar (see tmux/tmux.conf), drawing from the shared grayscale palette
# (tmux/theme.conf + starship/starship.toml). Reads session JSON on stdin.
#
# Layout:  VIM ▶ model ▶ dir ▶ branch* ▶ ctx NN% · TOKk ▶ 5h NN% · 7d NN%
# (▶ = the powerline arrow; the last pill mirrors /usage's plan limits)
#
# Needs a Nerd Font for the arrow glyph, exactly like the tmux bar. Depends on
# jq (parse) and git (branch). No `set -e`: degrade to a partial line, never abort.

input=$(cat)

if command -v jq >/dev/null 2>&1; then
  model=$(printf '%s' "$input" | jq -r '.model.display_name // "?"')
  dir=$(printf '%s' "$input"   | jq -r '.workspace.current_dir // .cwd // ""')
  pct=$(printf '%s' "$input"   | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
  vim=$(printf '%s' "$input"   | jq -r '.vim.mode // ""')
  in_tok=$(printf '%s' "$input"  | jq -r '.context_window.total_input_tokens // 0')
  out_tok=$(printf '%s' "$input" | jq -r '.context_window.total_output_tokens // 0')
  h5=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' | cut -d. -f1)
  d7=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' | cut -d. -f1)
else
  model="?"; dir="$PWD"; pct=0; vim=""; in_tok=0; out_tok=0; h5=""; d7=""
fi

# 256-color grayscale palette — mirrors tmux/theme.conf.
PRIMARY=250;   ON_PRIMARY=239     # highlight pill (vim mode / high context)
SECONDARY=240; ON_SECONDARY=252   # model / context pills
SURFACE=237;   ON_SURFACE=250     # dir / branch pills
STRONG=255                        # dirty marker

ESC=$'\033'
# U+E0B0 powerline right arrow (same glyph as tmux.conf). Built from its UTF-8
# bytes rather than a literal glyph so editors/tools can't strip it. Needs a
# Nerd Font to render, exactly like the tmux bar.
ARROW=$(printf '\xee\x82\xb0')

name="${dir##*/}"
[ -z "$name" ] && name="~"

# Git branch (+ bright '*' when dirty), only inside a work tree.
branch=""
if [ -n "$dir" ] && git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  b=$(git -C "$dir" symbolic-ref --short -q HEAD 2>/dev/null \
      || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$b" ]; then
    branch="$b"
    [ -n "$(git -C "$dir" status --porcelain 2>/dev/null)" ] \
      && branch="${b}${ESC}[38;5;${STRONG}m*"
  fi
fi

# Session tokens currently in the context window (input + output), e.g. "85.2k".
fmt_k() {
  local t=${1:-0}
  case "$t" in '' | *[!0-9]*) t=0 ;; esac
  if [ "$t" -ge 1000 ]; then
    printf '%d.%dk' $((t / 1000)) $(((t % 1000) / 100))
  else
    printf '%d' "$t"
  fi
}
tok=$(fmt_k $((in_tok + out_tok)))

# Plan usage (like /usage): 5-hour and 7-day rate-limit windows, when present.
usage=""
if [ -n "$h5" ] || [ -n "$d7" ]; then
  usage="5h ${h5:-0}% · 7d ${d7:-0}%"
fi

# Assemble the segments (bg / fg / text), in order.
bgs=(); fgs=(); txts=()
add() { bgs+=("$1"); fgs+=("$2"); txts+=(" $3 "); }

# Alternate secondary/surface so consecutive pills always differ and every
# arrow stays visible (a same-color arrow would be invisible).
toggle=0
add_alt() {
  if [ $((toggle % 2)) -eq 0 ]; then
    add "$SECONDARY" "$ON_SECONDARY" "$1"
  else
    add "$SURFACE" "$ON_SURFACE" "$1"
  fi
  toggle=$((toggle + 1))
}

[ -n "$vim" ] && add "$PRIMARY" "$ON_PRIMARY" "$vim"   # highlight, outside the alternation
add_alt "$model"
add_alt "$name"
[ -n "$branch" ] && add_alt "$branch"
# Context (+ session tokens): highlight pill once it fills up, else stay in rotation.
if [ "$pct" -ge 85 ] 2>/dev/null; then
  add "$PRIMARY" "$ON_PRIMARY" "ctx ${pct}% · ${tok}"
else
  add_alt "ctx ${pct}% · ${tok}"
fi
# Plan usage (5h / 7d rate limits), like /usage — only when the data is present.
[ -n "$usage" ] && add_alt "$usage"

# Render pills joined by arrows (arrow fg = closing bg, bg = next pill's bg);
# the trailing arrow bleeds the last pill's color into the terminal background.
out=""
n=${#bgs[@]}
for ((i = 0; i < n; i++)); do
  out+="${ESC}[48;5;${bgs[i]}m${ESC}[38;5;${fgs[i]}m${txts[i]}"
  if ((i < n - 1)); then
    out+="${ESC}[38;5;${bgs[i]}m${ESC}[48;5;${bgs[i + 1]}m${ARROW}"
  else
    out+="${ESC}[0m${ESC}[38;5;${bgs[i]}m${ARROW}${ESC}[0m"
  fi
done

printf '%s\n' "$out"
