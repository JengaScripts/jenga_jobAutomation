AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Wait(100)
    TriggerServerEvent("jenga_jobAutomation:server:Load")
end)

AddEventHandler('esx:playerLoaded', function()
    Wait(100)
    TriggerServerEvent("jenga_jobAutomation:server:Load")
end)