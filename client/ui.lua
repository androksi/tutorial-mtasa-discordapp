local screenX, screenY = guiGetScreenSize()

local discordLogoVisible = true
local discordLogoSize = Vector2(48, 48)
local discordLogoPosition = Vector2(screenX - discordLogoSize.x, screenY / 2 - discordLogoSize.y / 2)

local discordStatusVisible = false
local discordStatusSize = Vector2(200, discordLogoSize.y)
local discordStatusPosition = Vector2(0, screenY / 2 - discordLogoSize.y / 2)

local discordInfo = {guildName = 0, members = 0, inviteCode = 0}

addEvent("discordapp.update", true)
addEventHandler("discordapp.update", resourceRoot, function(info)
    discordInfo = info
end)

addEventHandler("onClientRender", root, function()
    dxDrawRectangle(discordLogoPosition.x, discordLogoPosition.y, discordLogoSize.x, discordLogoSize.y, tocolor(14, 15, 16, 150), false)
    dxDrawImage(discordLogoPosition.x, discordLogoPosition.y, discordLogoSize.x, discordLogoSize.y, "assets/images/discord.png")

    if discordStatusVisible then
        dxDrawRectangle(discordStatusPosition.x, discordStatusPosition.y, discordStatusSize.x, discordStatusSize.y, tocolor(14, 15, 16, 150), false)
        dxDrawText(discordInfo.guildName .. "\nMembros: " .. discordInfo.members .. "\nConvite: " .. discordInfo.inviteCode .. " (click)", discordStatusPosition.x, discordStatusPosition.y, discordStatusPosition.x + discordStatusSize.x, discordStatusPosition.y + discordStatusSize.y, tocolor(255, 255, 255, 255), 0.85, "default-bold", "center", "center")
    end
end)

addEventHandler("onClientClick", root, function(button, state)
    if discordLogoVisible then
        if button == "left" and state == "up" then
            if isHover(discordLogoPosition.x, discordLogoPosition.y, discordLogoSize.x, discordLogoSize.y) then
                toggleStatus()
            elseif isHover(discordStatusPosition.x, discordStatusPosition.y, discordStatusSize.x, discordStatusSize.y) then
                setClipboard("https://discord.gg/" .. discordInfo.inviteCode)
                outputChatBox("#cccccc[DISCORD] #ffffffO link de convite para o servidor do #66a1ffDiscord #fffffffoi copiado.", 255, 255, 255, true)
                toggleStatus()
            end
        end
    end
end)

function toggleStatus()
    discordStatusVisible = not discordStatusVisible

    if discordStatusVisible then
        discordLogoPosition.x = discordLogoPosition.x - discordStatusSize.x
        discordStatusPosition.x = discordLogoPosition.x + discordLogoSize.x
    else
        discordLogoPosition.x = screenX - discordLogoSize.x
    end
end

function isHover(...)
    local args = {...}

    if #args > 0 then
        local x = args[1]
        local y = args[2]
        local width = args[3]
        local height = args[4]
        local cursor = Vector2(getCursorPosition())
        local cursorX = cursor.x * screenX
        local cursorY = cursor.y * screenY

        if cursorX >= x and cursorX <= x + width and cursorY >= y and cursorY <= y + height then
            return true
        end

        return false
    end
end