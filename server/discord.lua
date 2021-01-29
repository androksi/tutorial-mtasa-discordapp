local discordInfo = {}
local discordCommands = {
    -- Funções/Comandos que serão executados pelo BOT
    ["settime"] = function(admin, args)
        local hour, minute = args[1], args[2]
        local success = setTime(hour, minute)
        
        if success then
            outputMessage(admin .. " #ffffffalterou o horário do servidor para " .. hour .. ":" .. minute .. "!")
            return "você alterou o horário no servidor."
        else
            return "algo deu errado. Use o comando novamente usando-o corretamente. "
        end
    end,
    ["text"] = function(admin, args)
        outputMessage(admin .. " #ffffffdisse: " .. args[1])
        return "sua mensagem ``" .. args[1] .. "`` foi enviada."
    end,
    ["status"] = function(admin, args)
        local online = getPlayerCount()
        local maxPlayers = getMaxPlayers()
        local serverName = getServerName()
        local serverIp = getServerConfigSetting("serverip")
        local serverPort = getServerPort()

        return {
            online = online,
            maxPlayers = maxPlayers,
            serverName = serverName,
            serverIp = serverIp,
            serverPort = serverPort
        }
    end,
    ["mute"] = function(admin, args)
        local player = getPlayerFromName(args[1])
        
        if isElement(player) then
            local playerName = getPlayerName(player)

            setPlayerMuted(player, true)
            outputMessage(admin .. " #ffffffmutou " .. playerName .. "!")
            return "**" .. playerName .. "** foi mutado(a)!"
        else
            return "**" .. args[1] .. "** está inválido."
        end
    end,
    ["givemoney"] = function(admin, args)
        local player = getPlayerFromName(args[1])
        local amount = tonumber(args[2])

        if not isElement(player) then
            return "**" .. args[1] .. "** está inválido."
        end
        if not amount or amount <= 0 then
            return "insira um valor válido e maior que 0."
        end

        local playerName = getPlayerName(player)

        givePlayerMoney(player, amount)
        outputMessage(admin .. " #ffffffdeu #008500R$" .. amount .. " #ffffffpara " .. playerName .. "!")
        return "**" .. playerName .. "** recebeu ``R$" .. amount .. "``."
    end,
    ["cgroup"] = function(admin, args)
        local groupName = args[1]

        if groupName then
            local checkGroup = aclGetGroup(groupName)
            if checkGroup then
                return "um grupo com esse nome já existe."
            end

            local newGroup = aclCreateGroup(groupName)
            if not newGroup then
                return "ocorreu um erro ao tentar criar o novo grupo."
            end

            return "grupo com o nome ``" .. groupName .. "`` foi adicionado à ACL."
        end
    end,
    ["uuu"] = function(admin, args)
        if admin == "Console" then
            discordInfo.members = args[1]
            discordInfo.inviteCode = args[2]
            discordInfo.guildName = args[3]

            updateInfo()
        end
    end
}

function discordRequest(command, admin, ...)
    if not discordCommands[command] then
        return "o comando não existe no servidor MTA."
    end

    local args = {...}
    return discordCommands[command](admin, args)
end

function updateInfo()
    triggerClientEvent("discordapp.update", resourceRoot, discordInfo)
end

function outputMessage(message)
    return outputChatBox("#cccccc[DISCORD] #ffffff" .. message, root, 255, 255, 255, true)
end