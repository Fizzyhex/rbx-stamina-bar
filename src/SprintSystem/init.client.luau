--!strict

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local SprintBar = require(script.SprintBar)
local SprintUtil = require(script.SprintUtil)

local STATE_SPEEDS = {
	sprint = 25,
	idle = 16,
	exhausted = 10
}

local function speedFromSprintState(sprintState: SprintUtil.AnyState)
	return assert(STATE_SPEEDS[sprintState.phase])
end

do
	local character = script.Parent
	local humanoid = character:WaitForChild("Humanoid") :: Humanoid

	local sprintState: SprintUtil.AnyState = SprintUtil.makeIdleState()
	local commandsToProcess: { SprintUtil.AnyCommand } = {}

	local sprintBar = SprintBar()
	sprintBar.instance.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	
	local function processInput(input)
		if input.KeyCode == Enum.KeyCode.LeftShift then
			table.insert(
				commandsToProcess,
				{
					action = "sprint",
					isDown = input.UserInputState == Enum.UserInputState.Begin,
				}
			)
		end
	end
	
	UserInputService.InputBegan:Connect(processInput)
	UserInputService.InputEnded:Connect(processInput)

	RunService.PostSimulation:Connect(function(deltaTime)
		while #commandsToProcess > 0 do
			local command = table.remove(commandsToProcess)
			assert(command)
			sprintState = SprintUtil.processCommand(sprintState, command)
		end

		sprintState = SprintUtil.calculate(sprintState, deltaTime)
		humanoid.WalkSpeed = speedFromSprintState(sprintState)
		
		sprintBar:setPercentage(sprintState.stamina / SprintUtil.MAX_STAMINA)
		sprintBar:update(sprintState.phase, deltaTime)

		-- Uncomment to spam state info into the console :>
		--print(sprintState)
	end)
end