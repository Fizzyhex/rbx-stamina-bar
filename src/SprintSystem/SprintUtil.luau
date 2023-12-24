--!strict

local MAX_STAMINA = 100 -- The maximum amount of stamina
local STAMINA_RECOVERY_RATE = 30 -- The rate at which stamina recovers per second
local STAMINA_DRAIN_RATE = 40 -- The rate at which stamina is consumed while sprinting per second

--------------------
-- State machine
--------------------

export type State = {
	stamina: number,
	recoveryStart: number,
}

export type Sprint = {
	phase: "sprint",
}

export type Exhausted = {
	phase: "exhausted",
}

export type Idle = {
	phase: "idle",
}

export type AnyState = (Sprint | Exhausted | Idle) & State

--------------------
-- Input commands
--------------------

export type SprintCommand = {
	action: "sprint",
	isDown: boolean,
}

export type AnyCommand = SprintCommand


local function clampStamina(stamina: number): number
	return math.clamp(stamina, 0, MAX_STAMINA)
end

local SprintUtil = {}

function SprintUtil.makeIdleState()
	return {
		phase = "idle" :: "idle",
		stamina = MAX_STAMINA,
		recoveryStart = os.clock(),
	} :: Idle & State
end

function SprintUtil.processCommand(state: AnyState, command: AnyCommand): AnyState
	if command.action ~= "sprint" then
		return state
	end

	if command.isDown then
		if state.phase == "idle" then
			if state.stamina > 0 then
				return {
					phase = "sprint" :: "sprint",
					stamina = state.stamina,
					recoveryStart = os.clock(),
				}
			else
				return {
					phase = "exhausted" :: "exhausted",
					stamina = state.stamina,
					recoveryStart = os.clock(),
				}
			end
		end
	elseif state.phase == "sprint" then
		return {
			phase = "idle" :: "idle",
			stamina = state.stamina,
			recoveryStart = state.recoveryStart,
		}
	end

	return state
end

function SprintUtil.calculate(state: AnyState, dt: number): AnyState
	state = table.clone(state) :: AnyState

	if state.phase ~= "sprint" and os.clock() - state.recoveryStart > 1 then
		state.stamina = clampStamina(state.stamina + STAMINA_RECOVERY_RATE * dt)
	end

	if state.phase == "exhausted" then
		if state.stamina >= MAX_STAMINA then
			return {
				phase = "idle" :: "idle",
				stamina = state.stamina,
				recoveryStart = state.recoveryStart,
			}
		end
	elseif state.phase == "sprint" then
		if state.stamina > 0 then
			return {
				phase = "sprint" :: "sprint",
				stamina = clampStamina(state.stamina - STAMINA_DRAIN_RATE * dt),
				recoveryStart = os.clock(),
			}
		else
			return {
				phase = "exhausted" :: "exhausted",
				stamina = state.stamina,
				recoveryStart = os.clock(),
			}
		end
	end

	return state
end

SprintUtil.MAX_STAMINA = MAX_STAMINA

return SprintUtil