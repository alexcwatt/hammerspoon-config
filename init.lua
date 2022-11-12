hs.loadSpoon('ElgatoKey'):start()

IsDocked = function()
    return hs.fnutils.some(hs.usb.attachedDevices(), function(device)
        return device.productName == "CalDigit USB-C Pro Audio"
    end)
end

MeetIsOpen = function()
    sourceFile = os.getenv("HOME") .. "/.hammerspoon/jxa/meetIsOpen.js"
    ran, urlsByWindowAndTab, _ = hs.osascript.applescript(
        'tell application "Google Chrome" to get URL of every tab of every window')
    if ran == false then
        return false
    end

    for _, window in pairs(urlsByWindowAndTab) do
        for _, url in pairs(window) do
            if string.find(url, "meet.google.com") then
                return true
            end
        end
    end

    return false
end

local MeetWasOpen = false

KeyLightAutomation = function()
    if IsDocked() then
        if MeetIsOpen() then
            MeetWasOpen = true
            spoon.ElgatoKey:on()
        elseif MeetWasOpen then
            MeetWasOpen = false
            spoon.ElgatoKey:off()
        end
    end
end

keyLightTimer = hs.timer.doEvery(1, KeyLightAutomation)
