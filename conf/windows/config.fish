# my.fish runs `abbr pacdep $pacdep` unconditionally but only sets it on macOS;
# give it a value first so it doesn't warn on Windows
set pacdep winget show

source ~/arch/my.fish
fish_add_path ~/.local/bin   # claude lives here

# --- Windows fixes (keep ~/arch untouched) ---
# lolcrab isn't packaged for Windows. center/centerf pipe through `$rainbow | head -n -1`,
# which relies on lolcrab's trailing newline, so plain `cat` would eat the last line
if not type -q lolcrab
    function _plain_rainbow
        cat
        echo
    end
    set rainbow _plain_rainbow
end
