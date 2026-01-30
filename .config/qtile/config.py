import os
import re
import socket
import subprocess
from libqtile import bar, layout, hook, extension, qtile
from libqtile.config import (
    Click,
    Drag,
    Group,
    Key,
    Match,
    Screen,
    ScratchPad,
    DropDown,
    KeyChord,
)
from libqtile.lazy import LazyCall, lazy
from typing import List

from libqtile.widget.base import _TextBox  # noqa: F401

# from themes.tokyonight import colors
from themes.monochrome import colors
from qtile_extras import widget

from qtile_extras.widget.decorations import RectDecoration

from libqtile.log_utils import logger

mod = "mod4"
terminal = "kitty"
browser = "firefox"

keys = [
    Key(key[0], key[1], *key[2:])
    for key in [
        # ------------ Window Configs ------------
        # Switch between windows in current stack pane
        ([mod], "j", lazy.layout.down()),
        ([mod], "k", lazy.layout.up()),
        ([mod], "h", lazy.layout.left()),
        ([mod], "l", lazy.layout.right()),
        # Change window sizes (MonadTall)
        ([mod, "shift"], "l", lazy.layout.grow()),
        ([mod, "shift"], "h", lazy.layout.shrink()),
        # Toggle floating
        ([mod, "shift"], "f", lazy.window.toggle_floating()),
        # Move windows up or down in current stack
        ([mod, "shift"], "j", lazy.layout.shuffle_down()),
        ([mod, "shift"], "k", lazy.layout.shuffle_up()),
        # Toggle between different layouts as defined below
        ([mod], "Tab", lazy.next_layout()),
        ([mod, "shift"], "Tab", lazy.prev_layout()),
        # Kill window
        ([mod], "w", lazy.window.kill()),
        # Switch focus of monitors
        ([mod], "period", lazy.screen.next_group()),
        ([mod], "comma", lazy.screen.prev_group()),
        # Restart Qtile
        ([mod, "control"], "r", lazy.restart()),
        ([mod, "control"], "q", lazy.shutdown()),
        # ------------ App Configs ------------
        # Menu
        ([mod], "m", lazy.spawn("rofi -show drun")),
        # Window Nav
        ([mod, "shift"], "m", lazy.spawn("rofi -show")),
        # Browser
        ([mod], "b", lazy.spawn("librewolf")),
        # File Explorer
        ([mod], "e", lazy.spawn("thunar")),
        # Terminal
        ([mod], "Return", lazy.spawn("kitty")),
        # Redshift
        ([mod], "r", lazy.spawn("redshift -O 2400")),
        ([mod, "shift"], "r", lazy.spawn("redshift -x")),
        # Screenshot
        ([mod], "s", lazy.spawn("flameshot full -p /home/esz/Imágenes/Capturas")),
        (
            [mod, "shift"],
            "s",
            lazy.spawn("flameshot gui -p /home/esz/Imágenes/Capturas"),
        ),
        # ------------ Hardware Configs ------------
        # Volume
        (
            [],
            "XF86AudioLowerVolume",
            lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
        ),
        (
            [],
            "XF86AudioRaiseVolume",
            lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
        ),
        ([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
        # Brightness
        ([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%")),
        ([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-")),
    ]
]

groups = [
    Group("1", label="あ", layout="max"),
    Group(
        "2",
        label="き",
        layout="max",
        matches=[Match(wm_class=re.compile(r"^(firefox|librewolf)$"))],
    ),
    Group("3", label="い", layout="max"),
    Group("4", label="う", layout="max"),
    Group("5", label="え", layout="max"),
    # Group('6', label="七", layout="max"),
    # Group('7', label="八", layout="max"),
    # Group('8', label="九", layout="max"),
]


for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )


colors = colors["hack"]

layout_theme = {
    "border_width": 2,
    "margin": 5,
    "border_focus": colors["white"],
    "border_normal": colors["gray5"],
}

layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.Max(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="FiraCode Nerd Font ",
    fontsize=16,
    foreground=colors["white"],
    background=colors["black"],
)
extension_defaults = widget_defaults.copy()

decor = {
    "decorations": [
        RectDecoration(
            colour=colors["gray2"],
            radius=6.5,
            filled=True,
            padding_y=5,
            padding_x=5,
            group=False,
        )
    ],
    "padding": 17,
}


def init_widgets():
    return [
        widget.CurrentLayout(
            foreground=colors["white"], mode="both", icon_first=True, scale=0.6, **decor
        ),
        widget.Clock(
            format=" %a %b %d, %Y -  %H:%M",
            foreground=colors["white"],
            mouse_callbacks={
                "Button1": lazy.spawn("gsimplecal"),
                "Button3": lazy.spawn("killall -q gsimplecal"),
            },
            **decor,
        ),
        widget.Spacer(length=bar.STRETCH),
        widget.GroupBox(
            padding=5,
            highlight_method="block",
            active=colors["gray6"],
            inactive=colors["white"],
            rounded=True,
            disable_drag=True,
            highlight_color=colors["red"],
            this_current_screen_border=colors["gray2"],
            this_screen_border=colors["gray1"],
            other_current_screen_border=colors["black"],
            other_screen_border=colors["black"],
            urgent_border=colors["red"],
            urgent_text=colors["red"],
            # hide_unused=True,
        ),
        widget.Spacer(length=bar.STRETCH),
        widget.StatusNotifier(**decor),
        widget.CheckUpdates(
            distro="Arch_checkupdates",
            update_interval=5,
            display_format=" {updates}",
            foreground=colors["white"],
            background=colors["black"],
            colour_have_updates=colors["white"],
            colour_no_updates=colors["white"],
            no_update_string="  no updates",
            **decor,
        ),
        widget.Volume(
            unmute_format=" {volume}%",
            mute_format="  muted",
            mouse_callbacks={
                "Button3": lazy.spawn("pavucontrol"),
                "Button2": lazy.spawn("pkill -f 'pavucontrol'"),
            },
            **decor,
        ),
        widget.Net(
            format="󰈀 {total:.0f} {total_suffix}",
            interface="enp5s0",
            mouse_callbacks={
                "Button1": lazy.spawn("kitty -e nmtui"),
                "Button3": lazy.spawn("pkill -f 'kitty -e nmtui'"),
            },
            **decor,
        ),
        widget.Memory(
            format=" {MemUsed: .2f}{mm} /{MemTotal: .2f}{mm}",
            measure_mem="G",
            mouse_callbacks={
                "Button1": lazy.spawn(
                    "kitty --class floating -o remember_window_size=no -o initial_window_width=1000 -o initial_window_height=600 -e btop"
                ),
                "Button3": lazy.spawn(
                    "pkill -f 'kitty --class floating -o remember_window_size=no -o initial_window_width=1000 -o initial_window_height=600 -e btop'"
                ),
            },
            update_interval=1,
            **decor,
        ),
        # widget.TextBox(
        #    text="",
        #       fontsize=16,
        #       mouse_callbacks={
        #           "Button1": lazy.spawn("/home/esz/.config/rofi/powermenu.sh"),
        #           "Button3": lazy.spawn("betterlockscreen -l"),
        #       },
        #       **decor,
        #   ),
        widget.Image(
            filename="~/.config/qtile/assets/power.png",
            **decor,
            margin_y=9,
            mouse_callbacks={
                "Button1": lazy.spawn("/home/esz/.config/rofi/powermenu.sh"),
                "Button3": lazy.spawn("betterlockscreen -l"),
            },
        ),
        # widget.TextBox(
        #     text="",
        #     foreground = colors["red"],
        #     ),
        # #widget.Sep(),
        # widget.ThermalSensor(
        #     format=' {temp:.0f}{unit}',
        #     tag_sensor='Tctl',
        #     threshold=60,
        #     foreground_alert=colors["red"],
        #     foreground = colors["fg"],
        #     ),
        # widget.Backlight(
        #     backlight_name = 'intel_backlight',
        #     format = '  {percent:2.0%}',
        #     ),
        # widget.TextBox(
        #     #text='',
        #     text="",
        #     foreground = colors["red"],
        #     ),
        # widget.Sep(),
        # widget.TextBox(
        #     # text='',
        #     text="",
        #     foreground=colors["hint"],
        # ),
        # widget.UPowerWidget(
        #    battery_name="BAT0",
        #    border_charge_colour="#00FF00",
        #    border_colour=colors["gray6"],
        #    border_critical_colour="#FF0000",
        #    percentage_low=0.15,
        #    percentage_critical=0.05,
        #    margin=3,
        #    update_interval=10,
        #    battery_width=25,
        #    battery_height=13,
        #    background="#000000",
        #    text_discharging="({percentage:.0f}%) {tte} until empty",
        #    text_displaytime=5,
        # ),
    ]


def status_bar(widgets):
    return bar.Bar(widgets, 36, margin=[5, 5, 1, 5])


screens = [Screen(top=status_bar(init_widgets()))]

xrandr = "xrandr | grep -w 'connected'"

command = subprocess.run(
    xrandr,
    shell=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
)

if command.returncode != 0:
    error = command.stderr.decode("UTF-8")
    logger.error(f"Failed counting monitors using {xrandr}:\n{error}")
    connected_monitors = 1
else:
    # Check the output of the xrandr command, if a monitor is connected
    # but turned off, then it will not show any resolution for that montior.
    xrandr_output = command.stdout.decode("UTF-8").split("\n")[:-1]
    resolutions = map(lambda output: output.split(" ")[2], xrandr_output)
    connected_monitors = len([r for r in resolutions if not r.startswith("(")])

# if connected_monitors == 3:
#     screens = [Screen(top=status_bar(secondary_widgets()))]
#     screens.append(Screen(top=status_bar(secondary_widgets())))
#     screens.append(Screen(top=bar.Bar(primary_widgets(), 39, opacity=1))) # 4K Monitor
# elif connected_monitors == 2:
#     screens = [Screen(top=status_bar(secondary_widgets()))]
#     screens.append(Screen(top=bar.Bar(primary_widgets(), 39, opacity=1))) # 4K Monitor

for _ in range(1, connected_monitors):
    screens.append(Screen(top=status_bar(init_widgets())))


dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="floating"),
    ],
    border_focus=colors["white"],
    border_width=2,
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = False

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.run([home])
