hs.loadSpoon('ElgatoKeys'):start()

IsDocked = function()
    return hs.fnutils.some(hs.usb.attachedDevices(), function(device)
        return device.productName == "CalDigit Thunderbolt 3 Audio"
    end)
end

CameraIsOn = function()
    return hs.fnutils.some(hs.camera.allCameras(), function(camera)
        return camera:isInUse()
    end)
end

local CameraWasOn = false
local CameraLastOnTime = 0

KeyLightAutomation = function()
    if IsDocked() then
        if CameraIsOn() then
            if not CameraWasOn then
                CameraWasOn = true
                spoon.ElgatoKeys:on()
            end
            CameraLastOnTime = hs.timer.secondsSinceEpoch()
        elseif CameraWasOn and (hs.timer.secondsSinceEpoch() - CameraLastOnTime) > 2 then
            CameraWasOn = false
            spoon.ElgatoKeys:off()
        end
    end
end

keyLightTimer = hs.timer.doEvery(1, KeyLightAutomation)
