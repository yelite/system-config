require("hs.ipc")

local hyper = { "ctrl", "shift", "option" }

hs.hotkey.bind(hyper, "1", hs.caffeinate.systemSleep)

hs.hotkey.bind({ "option" }, "p", function()
    local win = hs.window.focusedWindow()
    if not win then
        return
    end
    local nextScreen = win:screen():next()
    local wf = hs.window.filter.new():setCurrentSpace(true):setScreens(nextScreen:id())
    local windows = wf:getWindows(hs.window.filter.sortByFocusedLast)
    if #windows > 0 then
        windows[1]:focus()
    end
end)
