require("hs.ipc")

local hyper = { "ctrl", "shift", "option" }

hs.hotkey.bind(hyper, "1", hs.caffeinate.systemSleep)
