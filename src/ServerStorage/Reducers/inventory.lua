local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Rodux = require(ReplicatedStorage.Rodux)
local RoduxUtils = require(ReplicatedStorage.RoduxUtils)

local updateInventory = require(ServerStorage.Actions.updateInventory)

local initialState = {
}

local reducer = Rodux.createReducer(initialState, {
    [updateInventory.name] = function(state, action)
        
        local userId = action.player.UserId
        local newValue = 1
        if state[userId] and state[userId].wood then
            newValue = state[userId].wood + 1
        end

        local tableUpdates = {
            [userId] = {
                wood = newValue
            }
        }
        local newState = RoduxUtils.deepmerge(RoduxUtils.deepcopy(state), tableUpdates)

        -- update client that inventory changed
        -- using a remoteEvent
        -- inventoryUpdatedRemote:FireClients(action)
        ReplicatedStorage.InventoryChanged:FireClient(action.player, newState[userId])

        return newState
    end
})

return reducer