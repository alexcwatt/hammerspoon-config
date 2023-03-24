hs.loadSpoon('ElgatoKeys'):start()

IsDocked = function()
    return hs.fnutils.some(hs.usb.attachedDevices(), function(device)
        return device.productName == "CalDigit USB-C Pro Audio"
    end)
end

CameraIsOn = function()
    return hs.fnutils.some(hs.camera.allCameras(), function(camera)
        return camera:isInUse()
    end)
end

local CameraWasOn = false

KeyLightAutomation = function()
    if IsDocked() then
        if CameraIsOn() then
            CameraWasOn = true
            spoon.ElgatoKeys:on()
        elseif CameraWasOn then
            CameraWasOn = false
            spoon.ElgatoKeys:off()
        end
    end
end

keyLightTimer = hs.timer.doEvery(1, KeyLightAutomation)
