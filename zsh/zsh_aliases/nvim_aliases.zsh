NVIM_PLUGINS_DIR="$HOME/dotfiles/nvim/.config/nvim/lua/plugins"

use_old_nvim_lint_conform() {
  local dir="$NVIM_PLUGINS_DIR"

  if [[ "$dir/nvim-lint.lua" ]]; then
    mv "$dir/nvim-lint.lua" "$dir/nvim-lint.lua.bak"
  else
    echo "Missing nvim-lint files in $dir" >&2
  fi

  if [[ "$dir/nvim-lint_old.lua.bak" ]]; then
    mv "$dir/nvim-lint_old.lua.bak" "$dir/nvim-lint_old.lua"
  else
    echo "Missing nvim-lint_old files in $dir" >&2
  fi

  if [[ "$dir/conform.lua" ]]; then
    mv "$dir/conform.lua" "$dir/conform.lua.bak"
  else
    echo "Missing conform files in $dir" >&2
  fi

  if [[ "$dir/conform_old.lua.bak" ]]; then
    mv "$dir/conform_old.lua.bak" "$dir/conform_old.lua"
  else
    echo "Missing conform_old files in $dir" >&2
  fi

  echo "Switched to OLD nvim-lint & conform configs"
}

use_new_nvim_lint_conform() {
  local dir="$NVIM_PLUGINS_DIR"

  if [[ -f "$dir/nvim-lint.lua.bak" && -f "$dir/nvim-lint_old.lua" ]]; then
    mv "$dir/nvim-lint.lua.bak" "$dir/nvim-lint.lua"
    mv "$dir/nvim-lint_old.lua" "$dir/nvim-lint_old.lua.bak"
  else
    echo "Missing nvim-lint files in $dir" >&2
  fi

  if [[ -f "$dir/conform.lua.bak" && -f "$dir/conform_old.lua" ]]; then
    mv "$dir/conform.lua.bak" "$dir/conform.lua"
    mv "$dir/conform_old.lua" "$dir/conform_old.lua.bak"
  else
    echo "Missing conform files in $dir" >&2
  fi

  echo "Switched to NEW nvim-lint & conform configs"
}

alias anv='use_old_nvim_lint_conform'
alias ann='use_new_nvim_lint_conform'
