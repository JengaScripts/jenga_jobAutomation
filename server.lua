local Config = nil
local CheckedIds = {}
local QBCore, ESX = nil, nil

local function FindPlayerByDiscordId(discordId)
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

local function FindPlayerById(id)
    for _, v in pairs(GetPlayerIdentifiers(id)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            return v
        end
    end
    return nil
end

exports('SetConfig', function (config)
    Config = config
    if Config.useQB then
        QBCore = exports['qb-core']:GetCoreObject()
    else
        -- Can Add New ESX Import
        -- ESX = exports['es_extended']:getSharedObject()
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

exports('SetJob', function(discordId, job, grade)
    local PlayerId = FindPlayerByDiscordId(discordId)
    if PlayerId then
        if QBCore then
            local xPlayer = QBCore.Functions.GetPlayer(tonumber(PlayerId))
            if xPlayer then
                xPlayer.Functions.SetJob(job, grade)
                if Config.log then
                    print("Player ID: " ..PlayerId.. ", Job: " ..job.. " Grade: " ..grade)
                end
            else
                if Config.log then
                    print("Player ID: " ..PlayerId.. ", not found.")
                end
            end
        elseif ESX then
            if ESX.DoesJobExist(job, grade) then
                local xPlayer = ESX.GetPlayerFromId(PlayerId)
                if xPlayer then
                    xPlayer.setJob(job, grade)
                    if Config.log then
                        print("Player ID: " ..PlayerId.. ", Job: " ..job.. " Grade: " ..grade)
                    end
                else
                    if Config.log then
                        print("Player ID: " ..PlayerId.. ", not found.")
                    end
                end
            else
                print("[ESX] The job, grade or both are invalid")
            end
        else
            print("Framework not found.")
        end
    else
        exports.oxmysql:execute('INSERT INTO jenga_jobautomation (discordId, job, grade) VALUES (@discordId, @job, @grade)', {
            ['@discordId'] = discordId,
            ['@job'] = job,
            ['@grade'] = grade,
        })
        print("DiscordID: "..discordId.." is not found but saved to sql.")
    end
end)

RegisterNetEvent("jenga_jobAutomation:server:Load", function()
    local src = source
    if not CheckedIds[src] or CheckedIds[src] ~= 1 then
        CheckedIds[src] = 1
        local discordId = FindPlayerById(src)
        if discordId then
            local data = exports.oxmysql:executeSync('SELECT * FROM jenga_jobautomation WHERE discordId = @discordId ORDER BY id DESC LIMIT 1', {['@discordId'] = discordId})
            if data[1] then
                if QBCore then
                    local xPlayer = QBCore.Functions.GetPlayer(tonumber(PlayerId))
                    if xPlayer then
                        xPlayer.Functions.SetJob(data[1].job, data[1].grade)
                        if Config.log then
                            print("Player ID: " ..PlayerId.. ", Job: " ..data[1].job.. " Grade: " ..data[1].grade)
                        end
                    else
                        if Config.log then
                            print("Player ID: " ..PlayerId.. ", not found.")
                        end
                    end
                elseif ESX then
                    if ESX.DoesJobExist(data[1].job, data[1].grade) then
                        local xPlayer = ESX.GetPlayerFromId(PlayerId)
                        if xPlayer then
                            xPlayer.setJob(data[1].job, data[1].grade)
                            if Config.log then
                                print("Player ID: " ..PlayerId.. ", Job: " ..data[1].job.. " Grade: " ..data[1].grade)
                            end
                        else
                            if Config.log then
                                print("Player ID: " ..PlayerId.. ", not found.")
                            end
                        end
                    else
                        print("[ESX] The job, grade or both are invalid")
                    end
                else
                    print("Framework not found.")
                end
            end
        end
    end
end)