#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

["CAManBase","Killed",{
	(_this # 0) setVariable [QGVAR(isClimbing),nil];
}] call CBA_fnc_addClassEventHandler;

[QGVAR(climbingEnabled),"CHECKBOX",
	["Enable climbing/dropping",""],
	["Enhanced Movement Rework","Core"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(jumpingEnabled),"CHECKBOX",
	["Enable jumping",""],
	["Enhanced Movement Rework","Core"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxClimbHeight),"SLIDER",
	["Maximum climb height","Maximum height that a player can reach to climb on/over objects"],
	["Enhanced Movement Rework","Core"],
	[1,3,2.6,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxDropHeight),"SLIDER",
	["Maximum drop height","Maximum height that a player can drop from"],
	["Enhanced Movement Rework","Core"],
	[2,7,5,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(jumpVelocity),"SLIDER",
	["Jump velocity","Super saiyan simulator"],
	["Enhanced Movement Rework","Core"],
	[1,50,3.4,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(preventHighVaulting),"CHECKBOX",
	["Prevent high edge vaulting","When the player is above the max drop height, the vanilla vault action will be ignored. \n(Only works if vault keybind is the same as climb/drop)"],
	["Enhanced Movement Rework","Core"],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(allowMidairClimbing),"CHECKBOX",
	["Allow mid-air climbing",""],
	["Enhanced Movement Rework","Core"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(staminaCoefficient),"SLIDER",
	["Stamina coefficient",""],
	["Enhanced Movement Rework","Core"],
	[0,10,1,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(enableWalkableSurface),"CHECKBOX",
	["Enable walkable surface",""],
	["Enhanced Movement Rework","Core"],
	true,
	false,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(enableWeightCheck),"CHECKBOX",
	["Enable weight checking",""],
	["Enhanced Movement Rework","Maximum Weights"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(scaleJumpVelocity),"CHECKBOX",
	["Scale jump velocity with load","Changes jump height depending on player load"],
	["Enhanced Movement Rework","Maximum Weights"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightJump),"SLIDER",
	["Jumping","Maximum jumping weight"],
	["Enhanced Movement Rework","Maximum Weights"],
	[0,150,100,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightClimb1),"SLIDER",
	["1 Meter","Interpolated max player weight allowed to climb 1 meter"],
	["Enhanced Movement Rework","Maximum Weights"],
	[0,150,100,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightClimb2),"SLIDER",
	["2 Meters","Interpolated max player weight allowed to climb 2 meters"],
	["Enhanced Movement Rework","Maximum Weights"],
	[0,150,85,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightClimb3),"SLIDER",
	["3 Meters","Interpolated max player weight allowed to climb 3 meters"],
	["Enhanced Movement Rework","Maximum Weights"],
	[0,150,60,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

GVAR(debug) = false;

GVAR(WSExitConditions) = [
	{!isNil {_this getVariable "acex_sitting_sittingStatus"}},
	{animationState _this == "ACE_FastRoping"}
];

if (isServer) then {
	[QGVAR(addWSExitCondition),{
		params ["_code",{},[{}]];

		GVAR(WSExitConditions) pushBack _code;
		publicVariable QGVAR(WSExitConditions);
	}] call CBA_fnc_addEventHandler;
};

ADDON = true;
