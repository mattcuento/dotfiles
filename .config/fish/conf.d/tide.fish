# Tide prompt configuration, tracked as code instead of relying on fish_variables.
# Regenerate after tweaking via `tide configure`:
#   for v in (set --names --universal | sort)
#       string match -qr '^tide_' -- $v; and echo "set -U $v "(string escape -- $$v)
#   end > ~/.config/fish/conf.d/tide.fish
# fish auto-sources conf.d/*.fish on startup, so these apply on a fresh machine.

set -U tide_aws_bg_color black
set -U tide_aws_color yellow
set -U tide_aws_icon 
set -U tide_bun_bg_color black
set -U tide_bun_color white
set -U tide_bun_icon 󰳓
set -U tide_character_color brgreen
set -U tide_character_color_failure brred
set -U tide_character_icon ❯
set -U tide_character_vi_icon_default ❮
set -U tide_character_vi_icon_replace ▶
set -U tide_character_vi_icon_visual V
set -U tide_cmd_duration_bg_color black
set -U tide_cmd_duration_color brblack
set -U tide_cmd_duration_decimals 0

set -U tide_cmd_duration_threshold 3000
set -U tide_context_always_display false
set -U tide_context_bg_color black
set -U tide_context_color_default yellow
set -U tide_context_color_root bryellow
set -U tide_context_color_ssh yellow
set -U tide_context_hostname_parts 1
set -U tide_crystal_bg_color black
set -U tide_crystal_color brwhite
set -U tide_crystal_icon 
set -U tide_direnv_bg_color black
set -U tide_direnv_bg_color_denied black
set -U tide_direnv_color bryellow
set -U tide_direnv_color_denied brred
set -U tide_direnv_icon ▼
set -U tide_distrobox_bg_color black
set -U tide_distrobox_color brmagenta
set -U tide_distrobox_icon 󰆧
set -U tide_docker_bg_color black
set -U tide_docker_color blue
set -U tide_docker_default_contexts default set -U tide_docker_default_contexts colima
set -U tide_docker_icon 
set -U tide_elixir_bg_color black
set -U tide_elixir_color magenta
set -U tide_elixir_icon 
set -U tide_gcloud_bg_color black
set -U tide_gcloud_color blue
set -U tide_gcloud_icon 󰊭
set -U tide_git_bg_color black
set -U tide_git_bg_color_unstable black
set -U tide_git_bg_color_urgent black
set -U tide_git_color_branch brgreen
set -U tide_git_color_conflicted brred
set -U tide_git_color_dirty bryellow
set -U tide_git_color_operation brred
set -U tide_git_color_staged bryellow
set -U tide_git_color_stash brgreen
set -U tide_git_color_untracked brblue
set -U tide_git_color_upstream brgreen

set -U tide_git_truncation_length 24

set -U tide_go_bg_color black
set -U tide_go_color brcyan
set -U tide_go_icon 
set -U tide_java_bg_color black
set -U tide_java_color yellow
set -U tide_java_icon 
set -U tide_jobs_bg_color black
set -U tide_jobs_color green
set -U tide_jobs_icon 
set -U tide_jobs_number_threshold 1000
set -U tide_kubectl_bg_color black
set -U tide_kubectl_color blue
set -U tide_kubectl_icon 󱃾
set -U tide_left_prompt_frame_enabled false
set -U tide_left_prompt_items vi_mode set -U tide_left_prompt_items pwd set -U tide_left_prompt_items git
set -U tide_left_prompt_prefix 
set -U tide_left_prompt_separator_diff_color 
set -U tide_left_prompt_separator_same_color ╱
set -U tide_left_prompt_suffix 
set -U tide_nix_shell_bg_color black
set -U tide_nix_shell_color brblue
set -U tide_nix_shell_icon 
set -U tide_node_bg_color black
set -U tide_node_color green
set -U tide_node_icon 
set -U tide_os_bg_color black
set -U tide_os_color brwhite
set -U tide_os_icon 
set -U tide_php_bg_color black
set -U tide_php_color blue
set -U tide_php_icon 
set -U tide_private_mode_bg_color black
set -U tide_private_mode_color brwhite
set -U tide_private_mode_icon 󰗹
set -U tide_prompt_add_newline_before true
set -U tide_prompt_color_frame_and_connection brblack
set -U tide_prompt_color_separator_same_color brblack
set -U tide_prompt_icon_connection ' '
set -U tide_prompt_min_cols 34
set -U tide_prompt_pad_items true
set -U tide_prompt_transient_enabled true
set -U tide_pulumi_bg_color black
set -U tide_pulumi_color yellow
set -U tide_pulumi_icon 
set -U tide_pwd_bg_color black
set -U tide_pwd_color_anchors brcyan
set -U tide_pwd_color_dirs cyan
set -U tide_pwd_color_truncated_dirs magenta


set -U tide_pwd_icon_unwritable 
set -U tide_pwd_markers .bzr set -U tide_pwd_markers .citc set -U tide_pwd_markers .git set -U tide_pwd_markers .hg set -U tide_pwd_markers .node-version set -U tide_pwd_markers .python-version set -U tide_pwd_markers .ruby-version set -U tide_pwd_markers .shorten_folder_marker set -U tide_pwd_markers .svn set -U tide_pwd_markers .terraform set -U tide_pwd_markers bun.lockb set -U tide_pwd_markers Cargo.toml set -U tide_pwd_markers composer.json set -U tide_pwd_markers CVS set -U tide_pwd_markers go.mod set -U tide_pwd_markers package.json set -U tide_pwd_markers build.zig
set -U tide_python_bg_color black
set -U tide_python_color cyan
set -U tide_python_icon 󰌠
set -U tide_right_prompt_frame_enabled false
set -U tide_right_prompt_items status set -U tide_right_prompt_items cmd_duration set -U tide_right_prompt_items context set -U tide_right_prompt_items jobs set -U tide_right_prompt_items direnv set -U tide_right_prompt_items bun set -U tide_right_prompt_items node set -U tide_right_prompt_items python set -U tide_right_prompt_items rustc set -U tide_right_prompt_items java set -U tide_right_prompt_items php set -U tide_right_prompt_items pulumi set -U tide_right_prompt_items ruby set -U tide_right_prompt_items go set -U tide_right_prompt_items gcloud set -U tide_right_prompt_items kubectl set -U tide_right_prompt_items distrobox set -U tide_right_prompt_items toolbox set -U tide_right_prompt_items terraform set -U tide_right_prompt_items aws set -U tide_right_prompt_items nix_shell set -U tide_right_prompt_items crystal set -U tide_right_prompt_items elixir set -U tide_right_prompt_items zig set -U tide_right_prompt_items time
set -U tide_right_prompt_prefix 
set -U tide_right_prompt_separator_diff_color 
set -U tide_right_prompt_separator_same_color ╱
set -U tide_right_prompt_suffix 
set -U tide_ruby_bg_color black
set -U tide_ruby_color red
set -U tide_ruby_icon 
set -U tide_rustc_bg_color black
set -U tide_rustc_color red
set -U tide_rustc_icon 
set -U tide_shlvl_bg_color black
set -U tide_shlvl_color yellow
set -U tide_shlvl_icon 
set -U tide_shlvl_threshold 1
set -U tide_status_bg_color black
set -U tide_status_bg_color_failure black
set -U tide_status_color green
set -U tide_status_color_failure red
set -U tide_status_icon ✔
set -U tide_status_icon_failure ✘
set -U tide_terraform_bg_color black
set -U tide_terraform_color magenta
set -U tide_terraform_icon 󱁢
set -U tide_time_bg_color black
set -U tide_time_color brblack
set -U tide_time_format '%T'
set -U tide_toolbox_bg_color black
set -U tide_toolbox_color magenta
set -U tide_toolbox_icon 
set -U tide_vi_mode_bg_color_default black
set -U tide_vi_mode_bg_color_insert black
set -U tide_vi_mode_bg_color_replace black
set -U tide_vi_mode_bg_color_visual black
set -U tide_vi_mode_color_default white
set -U tide_vi_mode_color_insert cyan
set -U tide_vi_mode_color_replace green
set -U tide_vi_mode_color_visual yellow
set -U tide_vi_mode_icon_default D
set -U tide_vi_mode_icon_insert I
set -U tide_vi_mode_icon_replace R
set -U tide_vi_mode_icon_visual V
set -U tide_zig_bg_color black
set -U tide_zig_color yellow
set -U tide_zig_icon 
