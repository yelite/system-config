function _tide_item_nix_shell 
    if set -q my_nix_shell_name
        _tide_print_item nix_shell $tide_nix_shell_icon' ' $my_nix_shell_name
    end
end

set -g tide_nix_shell_color magenta
set -g tide_nix_shell_bg_color normal
set -g tide_nix_shell_icon ''

set -g tide_character_icon ❯
set -g tide_cmd_duration_decimals 0
set -g tide_cmd_duration_threshold 5000
set -g tide_prompt_icon_connection ─
set -g tide_left_prompt_frame_enabled true
set -g tide_left_prompt_items pwd git newline character
set -g tide_right_prompt_frame_enabled false
set -g tide_right_prompt_items status cmd_duration context jobs node virtual_env rustc java php chruby go kubectl toolbox terraform nix_shell
set -g tide_prompt_color_frame_and_connection 555 brblack

set -g sponge_delay 5
