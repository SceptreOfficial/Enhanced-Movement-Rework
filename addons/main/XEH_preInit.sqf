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
	[2,20,5,1],
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

[QGVAR(allowMidairClimbing),"CHECKBOX",
	["Allow mid-air climbing",""],
	["Enhanced Movement Rework","Core"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(blacklistStr),"EDITBOX",
	["Object type blacklist","List of object classes that cannot be climbed on."],
	["Enhanced Movement Rework","Core"],
	"",
	true,
	{GVAR(blacklist) = ((_this splitString ",") apply {toLower _x}) + (uiNamespace getVariable [QGVAR(classBlacklist),[]])},
	false
] call CBA_fnc_addSetting;

[QGVAR(whitelistStr),"EDITBOX",
	["Object type whitelist","Use to override config level blacklisting."],
	["Enhanced Movement Rework","Core"],
	"",
	true,
	{GVAR(whitelist) = (_this splitString ",") apply {toLower _x}},
	false
] call CBA_fnc_addSetting;

[QGVAR(preventHighVaulting),"CHECKBOX",
	["Prevent high edge vaulting","When the player is above the max drop height, the vanilla vault action will be ignored. \n(Only works if 'vault' keybind is the same as 'climb/drop only')"],
	["Enhanced Movement Rework","Preferences"],
	false,
	false,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(enableWalkableSurface),"CHECKBOX",
	["Enable walkable surface","Spawns an invisible walkable surface object underneath the player when on top of an object"],
	["Enhanced Movement Rework","Preferences"],
	true,
	false,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(staminaCoefficient),"SLIDER",
	["Stamina coefficient","Coefficient for all stamina drain"],
	["Enhanced Movement Rework","Stamina"],
	[0,10,1,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(jumpDuty),"SLIDER",
	["Jump duty","Base stamina cost for jumping"],
	["Enhanced Movement Rework","Stamina"],
	[0,10,1,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(climbOnDuty),"SLIDER",
	["Climb on duty","Base stamina cost for climbing ONTO objects, which is multiplied by the height of the climb"],
	["Enhanced Movement Rework","Stamina"],
	[0,10,3.4,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(climbOverDuty),"SLIDER",
	["Climb over duty","Base stamina cost for climbing OVER objects, which is multiplied by the height of the climb"],
	["Enhanced Movement Rework","Stamina"],
	[0,10,3,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(dropDuty),"SLIDER",
	["Drop duty","Base stamina cost for dropping down from an object, which is multiplied by the depth of the drop"],
	["Enhanced Movement Rework","Stamina"],
	[0,10,0.7,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(jumpingLoadCoefficient),"SLIDER",
	["Jumping velocity/load coefficient","Multiplier for how much player load reduces jump velocity"],
	["Enhanced Movement Rework","Weight"],
	[0,10,1,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(enableWeightCheck),"CHECKBOX",
	["Enable max weight checking",""],
	["Enhanced Movement Rework","Weight"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightJump),"SLIDER",
	["Max Weight - Jumping","Maximum jumping weight"],
	["Enhanced Movement Rework","Weight"],
	[0,150,100,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightClimb1),"SLIDER",
	["Max Weight - Climb 1m","Interpolated max player weight allowed to climb 1 meter"],
	["Enhanced Movement Rework","Weight"],
	[0,150,100,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightClimb2),"SLIDER",
	["Max Weight - Climb 2m","Interpolated max player weight allowed to climb 2 meters"],
	["Enhanced Movement Rework","Weight"],
	[0,150,85,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightClimb3),"SLIDER",
	["Max Weight - Climb 3m","Interpolated max player weight allowed to climb 3 meters"],
	["Enhanced Movement Rework","Weight"],
	[0,150,60,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

GVAR(debug) = false;

GVAR(WSExitConditions) = [
	{!isNil {_this getVariable "acex_sitting_sittingStatus"}},
	{animationState _this isEqualTo "ace_fastroping"}
];

GVAR(actionExitConditions) = [
	{!isNil {_this getVariable "acex_sitting_sittingStatus"}},
	{animationState _this isEqualTo "ace_fastroping"},
	{!isNil {_this getVariable "ace_medical_treatment_endInAnim"}}
];

if (isServer) then {
	[QGVAR(addWSExitCondition),{
		params ["_code",{},[{}]];

		GVAR(WSExitConditions) pushBack _code;
		publicVariable QGVAR(WSExitConditions);
	}] call CBA_fnc_addEventHandler;

	[QGVAR(addActionExitCondition),{
		params ["_code",{},[{}]];

		GVAR(actionExitConditions) pushBack _code;
		publicVariable QGVAR(actionExitConditions);
	}] call CBA_fnc_addEventHandler;
};

ADDON = true;
