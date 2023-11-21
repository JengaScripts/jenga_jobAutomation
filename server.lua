local Config = nil

local function FindPlayer(discordId)
    for _, playerId in ipairs(GetPlayers()) do
        for _, v in pairs(GetPlayerIdentifiers(playerId)) do
            if string.sub(v, 1, string.len("discord:")) == "discord:" then
                if v == "discord:"..discordId then
                    return playerId
                end
            end
        end
    end
    return nil
end

exports('SetConfig', function (config)
    Config = config
end)

exports('SetJob', function(discordId, job, grade)
    local PlayerId = FindPlayer(discordId)
    if PlayerId then
        if Config.useQB then
            local QBCore = exports['qb-core']:GetCoreObject()
            local xPlayer = QBCore.Functions.GetPlayer(PlayerId)
            if xPlayer then
                xPlayer.Functions.SetJob(job, grade)
                print("Player ID: " ..PlayerId.. ", Job: " ..job.. " Grade: " ..grade)
            else
                print("Player ID: " ..PlayerId.. ", not found.")
            end
        else
            -- Can Add New ESX Import
            -- local ESX = exports['es_extended']:getSharedObject()

            TriggerEvent('esx:getSharedObject', function(ESX)
                if ESX.DoesJobExist(job, grade) then
                    local xPlayer = ESX.GetPlayerFromId(PlayerId)
                    if xPlayer then
                        xPlayer.setJob(job, grade)
                        print("Player ID: " ..PlayerId.. ", Job: " ..job.. " Grade: " ..grade)
                    else   
                        print("Player ID: " ..PlayerId.. ", not found.")
                    end
                else
                    print("[ESX] The job, grade or both are invalid")
                end
            end)
        end
    end
end)