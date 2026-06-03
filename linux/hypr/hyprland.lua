-- Hyprland Lua config (Hyprland 0.55+)
-- https://wiki.hypr.land/Configuring/Start/

------------------
---- MONITORS ----
------------------

hl.monitor({ output = "DP-2", mode = "2560x1440@144",   position = "0x0",    scale = 1 })
hl.monitor({ output = "DP-1", mode = "2560x1440@144",  position = "2560x0", scale = 1 })


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("LIBVA_DRIVER_NAME",        "nvidia")
hl.env("XDG_SESSION_TYPE",         "wayland")
hl.env("GBM_BACKEND",              "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME","nvidia")
hl.env("QT_QPA_PLATFORMTHEME",     "qt6ct")


-------------------
---- AUTOSTART ----
-------------------

-- exec-once equivalents (fire once at startup)
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user import-environment")
    hl.exec_cmd("hash dbus-update-activation-environment 2>/dev/null")
    hl.exec_cmd("dbus-update-activation-environment --systemd")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd("swayidle -w timeout 3600 'hyprlock' before-sleep 'hyprlock'")
    hl.exec_cmd("waybar -c .config/waybar/config")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("mako")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("bash -c 'mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob'")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("/usr/bin/nohup /usr/bin/easyeffects --gapplication-service")
    hl.exec_cmd("hyprpaper")
end)

-- exec equivalents (also run on config reload)
hl.exec_cmd("hyprshade auto")
hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 5,

        border_size = 3,

        col = {
            active_border   = "rgba(ff69b4ff)",
            inactive_border = "rgba(595959aa)",
        },

        layout = "dwindle",
    },

    decoration = {
        active_opacity     = 1.0,
        inactive_opacity   = 1.0,
        fullscreen_opacity = 1.0,

        rounding = 4,

        blur = {
            enabled          = false,
            size             = 15,
            passes           = 1,
            new_optimizations = true,
            xray             = true,
            ignore_opacity   = false,
        },

        dim_inactive = false,
    },

    animations = {
        enabled = true,
    },

    cursor = {
        no_hardware_cursors = true,
    },
})

-- Bezier curves (kept for when animations are re-enabled)
hl.curve("linear",        { type = "bezier", points = { {0, 0},      {1, 1}      } })
hl.curve("md3_standard",  { type = "bezier", points = { {0.2, 0},    {0, 1}      } })
hl.curve("md3_decel",     { type = "bezier", points = { {0.05, 0.7}, {0.1, 1}    } })
hl.curve("md3_accel",     { type = "bezier", points = { {0.3, 0},    {0.8, 0.15} } })
hl.curve("overshot",      { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.1}  } })
hl.curve("crazyshot",     { type = "bezier", points = { {0.1, 1.5},  {0.76, 0.92}} })
hl.curve("hyprnostretch", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0}  } })
hl.curve("fluent_decel",  { type = "bezier", points = { {0.1, 1},    {0, 1}      } })
hl.curve("easeInOutCirc", { type = "bezier", points = { {0.85, 0},   {0.15, 1}   } })
hl.curve("easeOutCirc",   { type = "bezier", points = { {0, 0.55},   {0.45, 1}   } })
hl.curve("easeOutExpo",   { type = "bezier", points = { {0.16, 1},   {0.3, 1}    } })

hl.animation({ leaf = "windows",          enabled = true, speed = 2,   bezier = "easeOutCirc",  style = "slide" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 2,   bezier = "md3_accel",    style = "popin 85%" })
hl.animation({ leaf = "windowsMove",      enabled = true, speed = 2,   bezier = "easeOutCirc" })
hl.animation({ leaf = "border",           enabled = true, speed = 3,   bezier = "default" })
hl.animation({ leaf = "fade",             enabled = true, speed = 2.5, bezier = "md3_decel" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 3,   bezier = "easeOutExpo",  style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2.5, bezier = "easeOutCirc",  style = "slidevert" })


--------------
---- MISC ----
--------------

hl.config({
    dwindle = {
        force_split            = 0,
        special_scale_factor   = 0.8,
        split_width_multiplier = 1.0,
        use_active_for_splits  = true,
        preserve_split         = true,
    },

    master = {
        new_status           = "master",
        special_scale_factor = 0.8,
    },

    misc = {
        disable_hyprland_logo     = true,
        always_follow_on_dnd      = true,
        layers_hog_keyboard_focus = true,
        animate_manual_resizes    = false,
        enable_swallow            = true,
        swallow_regex             = "",
        focus_on_activate         = true,
    },

    gestures = {
        workspace_swipe_distance          = 250,
        workspace_swipe_invert            = true,
        workspace_swipe_min_speed_to_force = 15,
        workspace_swipe_cancel_ratio      = 0.5,
        workspace_swipe_create_new        = false,
    },

    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles   = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse              = 1,
        float_switch_override_focus = 2,

        touchpad = {
            natural_scroll = false,
        },

        accel_profile  = "flat",
        force_no_accel = true,
        sensitivity    = 0,
    },
})

hl.device({
    name        = "logitech-g502-x",
    sensitivity = 0,
})


---------------------
---- LAYER RULES ----
---------------------

hl.layer_rule({
    name         = "vicinae-blur",
    match        = { namespace = "vicinae" },
    blur         = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    name    = "vicinae-no-animation",
    match   = { namespace = "vicinae" },
    no_anim = true,
})


--------------------------
---- WORKSPACE RULES -----
--------------------------

hl.workspace_rule({ workspace = "name:Web",      monitor = "DP-1" })
hl.workspace_rule({ workspace = "name:Editor",   monitor = "DP-1" })
hl.workspace_rule({ workspace = "name:Slack",    monitor = "DP-2" })
hl.workspace_rule({ workspace = "name:Music",    monitor = "DP-2" })
hl.workspace_rule({ workspace = "name:Notes",    monitor = "DP-2" })
hl.workspace_rule({ workspace = "name:Planning", monitor = "DP-2" })


------------------------
---- WINDOW RULES ------
------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name  = "floaters-by-class",
    match = { class = "^()$" },
    float  = true,
    center = true,
})

hl.window_rule({
    name  = "floaters-by-title",
    match = { title = "^(Picture in picture|Steam - Self Updater)$" },
    float  = true,
    center = true,
})

hl.window_rule({
    name  = "browsers",
    match = { class = "^(brave-browser|brave-browser-beta|firefox)$" },
    workspace = "name:Web",
})

hl.window_rule({
    name  = "code-editors",
    match = { class = "^(Code|code|codium)$" },
    workspace = "name:Editor",
})

hl.window_rule({
    name  = "slack",
    match = { class = "^(Slack|slack)$" },
    workspace = "name:Slack",
})

hl.window_rule({
    name  = "music",
    match = { class = "^(Spotify|spotify)$" },
    workspace = "name:Music",
})

hl.window_rule({
    name  = "notes",
    match = { class = "^(obsidian)$" },
    workspace = "special",
})

hl.window_rule({
    name  = "planning",
    match = { class = "^(ClickUp)$" },
    workspace = "name:Planning",
})


---------------------
---- KEYBINDINGS ----
---------------------

exit = hl.dsp.exit()

local mainMod = "SUPER"

-- General
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("ghostty"))
hl.bind("Print",               hl.dsp.exec_cmd("hyprshot --freeze --mode=region --raw --clipboard-only | swappy -f -"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("record"))
hl.bind(mainMod .. " + Q",     hl.dsp.window.close())
hl.bind(mainMod .. " + V",     hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind(mainMod .. " + F",     hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + Y",     hl.dsp.window.pin())
hl.bind(mainMod .. " + O",     hl.dsp.exec_cmd("killall -SIGUSR2 waybar"))
hl.bind(mainMod .. " + l",     hl.dsp.exec_cmd("hyprlock"))

-- Groups
hl.bind(mainMod .. " + K",   hl.dsp.group.toggle())
hl.bind(mainMod .. " + Tab", hl.dsp.group.next())

-- Cycle windows
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind("ALT + Tab", hl.dsp.window.bring_to_top())

-- Volume
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -ud 3 && pamixer --get-volume > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"), { locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -ui 3 && pamixer --get-volume > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"), { locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("amixer sset Master toggle | sed -En '/\\[on\\]/ s/.*\\[([0-9]+)%\\].*/\\1/ p; /\\[off\\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"), { locked = true })

-- Playback
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl --player=spotify,%any play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"),     { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s +5%"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { locked = true })

-- Focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Move windows in layout
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces (numbered)
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,              hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. i,       hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i,      hl.dsp.window.move({ workspace = i, silent = true }))
end
hl.bind(mainMod .. " + 0",              hl.dsp.focus({ workspace = 0 }))
hl.bind(mainMod .. " + CTRL + 0",       hl.dsp.window.move({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0",      hl.dsp.window.move({ workspace = 10, silent = true }))

-- Switch workspaces (named)
hl.bind(mainMod .. " + w", hl.dsp.focus({ workspace = "name:Web" }))
hl.bind(mainMod .. " + e", hl.dsp.focus({ workspace = "name:Editor" }))
hl.bind(mainMod .. " + s", hl.dsp.focus({ workspace = "name:Slack" }))
hl.bind(mainMod .. " + m", hl.dsp.focus({ workspace = "name:Music" }))
hl.bind(mainMod .. " + n", hl.dsp.workspace.toggle_special())
hl.bind(mainMod .. " + p", hl.dsp.focus({ workspace = "name:Planning" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + comma",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + slash",  hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move window to named workspace
hl.bind(mainMod .. " + CTRL + w", hl.dsp.window.move({ workspace = "name:Web" }))
hl.bind(mainMod .. " + CTRL + e", hl.dsp.window.move({ workspace = "name:Editor" }))
hl.bind(mainMod .. " + CTRL + s", hl.dsp.window.move({ workspace = "name:Slack" }))
hl.bind(mainMod .. " + CTRL + m", hl.dsp.window.move({ workspace = "name:Music" }))
hl.bind(mainMod .. " + CTRL + n", hl.dsp.window.move({ workspace = "special:Notes" }))
hl.bind(mainMod .. " + CTRL + p", hl.dsp.window.move({ workspace = "name:Planning" }))
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ workspace = "e+1" }))

-- Move to named workspace silently
hl.bind(mainMod .. " + SHIFT + w", hl.dsp.window.move({ workspace = "name:Web",      silent = true }))
hl.bind(mainMod .. " + SHIFT + e", hl.dsp.window.move({ workspace = "name:Editor",   silent = true }))
hl.bind(mainMod .. " + SHIFT + s", hl.dsp.window.move({ workspace = "name:Slack",    silent = true }))
hl.bind(mainMod .. " + SHIFT + m", hl.dsp.window.move({ workspace = "name:Music",    silent = true }))
hl.bind(mainMod .. " + SHIFT + n", hl.dsp.window.move({ workspace = "special:Notes", silent = true }))
hl.bind(mainMod .. " + SHIFT + p", hl.dsp.window.move({ workspace = "name:Planning", silent = true }))

-- Mouse move/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize submap
hl.define_submap("resize", function()
    hl.bind("right", hl.dsp.window.resize({ x =  200, y =    0, relative = true }), { repeating = true })
    hl.bind("left",  hl.dsp.window.resize({ x = -200, y =    0, relative = true }), { repeating = true })
    hl.bind("up",    hl.dsp.window.resize({ x =    0, y =  200, relative = true }), { repeating = true })
    hl.bind("down",  hl.dsp.window.resize({ x =    0, y = -200, relative = true }), { repeating = true })
    hl.bind("l",     hl.dsp.window.resize({ x =  200, y =    0, relative = true }), { repeating = true })
    hl.bind("h",     hl.dsp.window.resize({ x = -200, y =    0, relative = true }), { repeating = true })
    hl.bind("k",     hl.dsp.window.resize({ x =    0, y =  200, relative = true }), { repeating = true })
    hl.bind("j",     hl.dsp.window.resize({ x =    0, y = -200, relative = true }), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
