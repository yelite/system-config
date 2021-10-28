# -*- coding: utf-8 -*-
# Taken from https://github.com/rbreaves/kinto/blob/master/linux/kinto.py

import re
from xkeysnail.transform import *

terminals = [
    "alacritty",
    "kitty",
    "konsole",
    "neovide",
]
terminals = [term.casefold() for term in terminals]
termStr = "|".join(str('^'+x+'$') for x in terminals)

mscodes = ["code","vscodium"]
codeStr = "|".join(str('^'+x+'$') for x in mscodes)

# Add remote desktop clients & VM software here
# Ideally we'd only exclude the client window,
# but that may not be easily done.
remotes = [
    "Gnome-boxes",
    "org.remmina.Remmina",
    "remmina",
    "qemu-system-.*",
    "Virt-manager",
    "VirtualBox",
    "VirtualBox Machine",
    "xfreerdp",
]
remotes = [client.casefold() for client in remotes]

# Add remote desktop clients & VMs for no remapping
terminals.extend(remotes)
mscodes.extend(remotes)

# Use for browser specific hotkeys
browsers = [
    "Chromium",
    "Chromium-browser",
    "Discord",
    "Epiphany",
    "Firefox",
    "Firefox Developer Edition",
    "Google-chrome",
    "microsoft-edge",
    "microsoft-edge-dev",
    "Vivaldi-stable"
]
browsers = [browser.casefold() for browser in browsers]
browserStr = "|".join(str('^'+x+'$') for x in browsers)

chromes = [
    "Chromium",
    "Chromium-browser",
    "Google-chrome",
    "microsoft-edge",
    "microsoft-edge-dev",
    "Vivaldi-stable"
]
chromes = [chrome.casefold() for chrome in chromes]
chromeStr = "|".join(str('^'+x+'$') for x in chromes)

# [Global modemap] Change modifier keys as in xmodmap
define_conditional_modmap(lambda wm_class: wm_class.casefold() not in terminals,{
    Key.LEFT_META: Key.RIGHT_CTRL,  # Mac
    Key.LEFT_CTRL: Key.LEFT_META,   # Mac
    Key.RIGHT_META: Key.RIGHT_CTRL, # Mac - Multi-language (Remove)
})

# [Conditional modmap] Change modifier keys in certain applications
define_conditional_modmap(re.compile(termStr, re.IGNORECASE), {
    Key.LEFT_META: Key.RIGHT_CTRL,  # Mac
    # # Left Ctrl Stays Left Ctrl
    Key.RIGHT_META: Key.RIGHT_CTRL, # Mac - Multi-language (Remove)
})

# Keybindings for General Web Browsers
define_keymap(re.compile(browserStr, re.IGNORECASE),{
    K("RC-Q"): K("RC-Q"),           # Close all browsers Instances
    K("M-RC-I"): K("RC-Shift-I"),   # Dev tools
    K("M-RC-J"): K("RC-Shift-J"),   # Dev tools
}, "General Web Browsers")

# Open preferences in browsers
define_keymap(re.compile("Firefox", re.IGNORECASE),{
    K("C-comma"): [
        K("C-T"),K("a"),K("b"),K("o"),K("u"),K("t"),
        K("Shift-SEMICOLON"),K("p"),K("r"),K("e"),K("f"),
        K("e"),K("r"),K("e"),K("n"),K("c"),K("e"),K("s"),K("Enter")
    ],
    K("RC-Shift-N"):    K("RC-Shift-P"),        # Open private window with Ctrl+Shift+N like other browsers
})
define_keymap(re.compile(chromeStr, re.IGNORECASE),{
    K("C-comma"): [K("M-e"), K("s"),K("Enter")],
}, "Browsers")
# Opera C-F12

# Note: terminals extends to remotes as well
define_keymap(lambda wm_class: wm_class.casefold() not in terminals,{
    K("RC-Dot"): K("Esc"),                        # Mimic macOS Cmd+dot = Escape key (not in terminals)
})

# None referenced here originally
# - but remote clients and VM software ought to be set here
# These are the typical remaps for ALL GUI based apps
define_keymap(lambda wm_class: wm_class.casefold() not in remotes,{
    K("RC-Space"): K("Alt-F1"),                   # Default SL - Launch Application Menu (gnome/kde)
    K("RC-F3"):K("Super-d"),                      # Default SL - Show Desktop (gnome/kde,eos)
    K("RC-Super-f"):K("M-F10"),                   # Default SL - Maximize app (gnome/kde)
    K("RC-Q"): K("M-F4"),                         # Default SL - not-popos
    K("RC-H"):K("Super-h"),                       # Default SL - Minimize app (gnome/budgie/popos/fedora)
    K("M-Tab"): pass_through_key,                 # Default - Cmd Tab - App Switching Default
    K("RC-Tab"): K("M-Tab"),                      # Default - Cmd Tab - App Switching Default
    K("RC-Shift-Tab"): K("M-Shift-Tab"),          # Default - Cmd Tab - App Switching Default
    K("RC-Grave"): K("M-Grave"),                  # Default not-xfce4 - Cmd ` - Same App Switching
    K("RC-Shift-Grave"): K("M-Shift-Grave"),      # Default not-xfce4 - Cmd ` - Same App Switching
    K("Super-Tab"): K("LC-Tab"),                  # Default not-chromebook
    K("Super-Shift-Tab"): K("LC-Shift-Tab"),      # Default not-chromebook

    # Fn to Alt style remaps
    K("RM-Enter"): K("insert"),                   # Insert

    # emacs style
    K("Super-a"): K("Home"),                      # Beginning of Line
    K("Super-e"): K("End"),                       # End of Line
    K("Super-b"): K("Left"),
    K("Super-f"): K("Right"),
    K("Super-n"): K("Down"),
    K("Super-p"): K("Up"),
    K("Super-k"): [K("Shift-End"), K("Backspace")],
    K("Super-d"): K("Delete"),

    # Delete
    K("Super-Backspace"): K("C-Backspace"),       # Delete Left Word of Cursor
    K("Super-Delete"): K("C-Delete"),             # Delete Right Word of Cursor
    K("M-Backspace"): K("C-Backspace"),           # Default not-chromebook
    K("RC-Backspace"): K("C-Shift-Backspace"),    # Delete Entire Line Left of Cursor
    K("Alt-Delete"): K("C-Delete"),               # Delete Right Word of Cursor
}, "General GUI")


define_keymap(re.compile("konsole", re.IGNORECASE),{
    # Ctrl Tab - In App Tab Switching
    K("LC-Tab") : K("Shift-Right"),
    K("LC-Shift-Tab") : K("Shift-Left"),
    K("LC-Grave") : K("Shift-Left"),

}, "Konsole tab switching")

define_keymap(re.compile("Io.elementary.terminal|kitty", re.IGNORECASE),{
    # Ctrl Tab - In App Tab Switching
    K("LC-Tab") : K("LC-Shift-Right"),
    K("LC-Shift-Tab") : K("LC-Shift-Left"),
    K("LC-Grave") : K("LC-Shift-Left"),

}, "Elementary Terminal tab switching")

define_keymap(re.compile(termStr, re.IGNORECASE),{
    K("LC-RC-f"): K("M-F10"),                       # Toggle window maximized state
    K("LC-Tab") : K("LC-PAGE_DOWN"),
    K("LC-Shift-Tab") : K("LC-PAGE_UP"),
    K("LC-Grave") : K("LC-PAGE_UP"),
    K("M-Tab"): pass_through_key,                 # Default - Cmd Tab - App Switching Default
    K("RC-Tab"): K("M-Tab"),                      # Default - Cmd Tab - App Switching Default
    K("RC-Shift-Tab"): K("M-Shift-Tab"),          # Default - Cmd Tab - App Switching Default
    # Converts Cmd to use Ctrl-Shift
    K("RC-MINUS"): K("C-MINUS"),
    K("RC-EQUAL"): K("C-Shift-EQUAL"),
    K("RC-BACKSPACE"): K("C-Shift-BACKSPACE"),
    K("RC-W"): K("C-Shift-W"),
    K("RC-E"): K("C-Shift-E"),
    K("RC-R"): K("C-Shift-R"),
    K("RC-T"): K("C-Shift-t"),
    K("RC-Y"): K("C-Shift-Y"),
    K("RC-U"): K("C-Shift-U"),
    K("RC-I"): K("C-Shift-I"),
    K("RC-O"): K("C-Shift-O"),
    K("RC-P"): K("C-Shift-P"),
    K("RC-LEFT_BRACE"): K("C-Shift-LEFT_BRACE"),
    K("RC-RIGHT_BRACE"): K("C-Shift-RIGHT_BRACE"),
    K("RC-A"): K("C-Shift-A"),
    K("RC-S"): K("C-Shift-S"),
    K("RC-D"): K("C-Shift-D"),
    K("RC-F"): K("C-Shift-F"),
    K("RC-G"): K("C-Shift-G"),
    K("RC-H"): K("C-Shift-H"),
    K("RC-J"): K("C-Shift-J"),
    K("RC-K"): K("C-Shift-K"),
    K("RC-L"): K("C-Shift-L"),
    K("RC-SEMICOLON"): K("C-Shift-SEMICOLON"),
    K("RC-APOSTROPHE"): K("C-Shift-APOSTROPHE"),
    K("RC-GRAVE"): K("C-Shift-GRAVE"),
    K("RC-Z"): K("C-Shift-Z"),
    K("RC-X"): K("C-Shift-X"),
    K("RC-C"): K("C-Shift-C"),
    K("RC-V"): K("C-Shift-V"),
    K("RC-B"): K("C-Shift-B"),
    K("RC-N"): K("C-Shift-N"),
    K("RC-M"): K("C-Shift-M"),
    K("RC-COMMA"): K("C-Shift-COMMA"),
    K("RC-Dot"): K("LC-c"),
    K("RC-SLASH"): K("C-Shift-SLASH"),
    K("RC-KPASTERISK"): K("C-Shift-KPASTERISK"),
}, "terminals")
