hs.loadSpoon('ElgatoKey'):start()

IsDocked = function()
    return hs.fnutils.some(hs.usb.attachedDevices(), function(device)
        return device.productName == "CalDigit USB-C Pro Audio"
    end)
end

MeetIsOpen = function()
    sourceFile = os.getenv("HOME") .. "/.hammerspoon/jxa/meetIsOpen.js"
    ran, meetIsOpen, _ = hs.osascript.javascriptFromFile(sourceFile)
    if ran == false then
        return false
    end

    return meetIsOpen
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
