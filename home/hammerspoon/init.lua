require("hs.ipc")

local hyper = { "ctrl", "shift", "option" }

hs.hotkey.bind(hyper, "2", hs.caffeinate.systemSleep)
