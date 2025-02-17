# Auto-pairing of characters

# Configuration ────────────────────────────────────────────────────────────────

# List of surrounding pairs
declare-option -docstring 'list of surrounding pairs' str-list auto_pairs ( ) { } [ ] '"' '"' "'" "'" ` ` “ ” ‘ ’ « » ‹ ›

# Auto-pairing of characters activates only when this expression does not fail.
# By default, it avoids non-nestable pairs (such as quotes), escaped pairs and word characters.
declare-option -docstring 'auto-pairing of characters activates only when this expression does not fail' str auto_close_trigger %{
  execute-keys '<a-h>'
  execute-keys '<a-K>(\w["''`]|""|''''|``).\z<ret>'
  set-register / "[^\\]?\Q%opt{opening_pair}\E\W\z"
  execute-keys '<a-k><ret>'
}

# Internal variables ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

declare-option -hidden str opening_pair
declare-option -hidden int inserted_pairs

# Retain inserted pairs
remove-hooks global clean-auto-pairs-state
hook -group clean-auto-pairs-state global WinSetOption 'inserted_pairs=0' %{
  unmap window insert
  remove-hooks window auto-pairs
}

# Commands ─────────────────────────────────────────────────────────────────────

define-command -override enable-auto-pairs -docstring 'enable auto-pairs' %{
  remove-hooks global auto-pairs
  evaluate-commands %sh{
    set -- ${kak_opt_auto_pairs}
    while [ "$2" ]
    do
      printf 'auto-close-pair %%<%s> %%<%s>\n' "$1" "$2"
      shift 2
    done
  }
}

define-command -override disable-auto-pairs -docstring 'disable auto-pairs' %{
  remove-hooks global auto-pairs
}

# Internal commands ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

define-command -override -hidden auto-close-pair -params 2 %{
  hook -group auto-pairs global InsertChar "\Q%arg{1}" "handle-inserted-opening-pair %%<%arg{1}> %%<%arg{2}>"
  hook -group auto-pairs global InsertDelete "\Q%arg{1}" "handle-deleted-opening-pair %%<%arg{1}> %%<%arg{2}>"
}

# Internal hooks ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

define-command -override -hidden handle-inserted-opening-pair -params 2 %{
  try %{
    # Test whether the commands contained in the option pass.
    # If not, it will throw an exception and execution will jump to
    # the “catch” block below.
    set-option window opening_pair %arg{1}
    evaluate-commands -draft -save-regs '/' %opt{auto_close_trigger}

    # Action: Close pair
    execute-keys %arg{2}

    # Move back in pair (preserve selected text):
    try %{
      execute-keys -draft '<a-k>..<ret>'
      execute-keys '<a-;>H'
    } catch %{
      execute-keys '<a-;>h'
    }

    # Add insert mappings
    map -docstring 'insert character or move right in pair' window insert %arg{2} "<a-;>: auto-pairs-insert-character %%🐈%arg{2}🐈<ret>"
    map -docstring 'insert a new indented line in pair' window insert <ret> '<a-;>: auto-pairs-insert-new-line<ret>'
    map -docstring 'prompt a count for new indented lines in pair' window insert <c-ret> '<a-;>: auto-pairs-insert-new-line-count-prompt<ret>'

    # Keep the track of inserted pairs
    increment-inserted-pairs-count

    # Clean state when moving or leaving insert mode
    # Enter is only available on next key.
    hook -group auto-pairs -once window InsertMove '.*' %{
      reset-inserted-pairs-count
    }
    hook -group auto-pairs -once window InsertChar '.*' %{
      unmap window insert <ret>
      unmap window insert <c-ret>
    }
    hook -always -once window ModeChange 'pop:insert:normal' %{
      reset-inserted-pairs-count
    }
  }
}

# Backspace ⇒ Erases the whole bracket
define-command -override -hidden handle-deleted-opening-pair -params 2 %{
  try %{
    execute-keys -draft "<space>;<a-k>\Q%arg{2}<ret>"
    execute-keys '<del>'
    decrement-inserted-pairs-count
  }
}

# Internal mappings ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# {closing-pair} ⇒ Insert character or move right in pair
define-command -override -hidden auto-pairs-insert-character -params 1 %{
  try %{
    execute-keys -draft "<space>;<a-k>\Q%arg{1}<ret>"
    # Move right in pair
    execute-keys '<a-;>l'
    decrement-inserted-pairs-count
  } catch %{
    # Insert character with hooks
    execute-keys -with-hooks %arg{1}
  }
}

# Enter ⇒ Insert a new indented line in pair (only for the next key)
define-command -override -hidden auto-pairs-insert-new-line %{
  execute-keys '<a-;>;<ret><ret><esc>KK<a-&>j<a-gt>'
  execute-keys -with-hooks A
  reset-inserted-pairs-count
}

# Control+Enter ⇒ Prompt a count for new indented lines in pair (only for the next key)
define-command -override -hidden auto-pairs-insert-new-line-count-prompt %{
  prompt count: %{
    execute-keys '<a-;>;<ret><ret><esc>KK<a-&>j<a-gt>'
    execute-keys "<a-x>Hy<a-x><a-d>%val{text}O<c-r>""<esc>"
    execute-keys -with-hooks A
    reset-inserted-pairs-count
  }
}

# ┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈

# Increment and decrement inserted pairs count
define-command -override -hidden increment-inserted-pairs-count %{
  set-option -add window inserted_pairs 1
}

define-command -override -hidden decrement-inserted-pairs-count %{
  set-option -remove window inserted_pairs 1
}

define-command -override -hidden reset-inserted-pairs-count %{
  set-option window inserted_pairs 0
}
