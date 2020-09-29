#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

["CAManBase","Killed",{
	(_this # 0) setVariable [QGVAR(isClimbing),nil];
}] call CBA_fnc_addClassEventHandler;

[QGVAR(climbingEnabled),"CHECKBOX",
	[LSTRING(SettingDisplayName_climbingEnabled),LSTRING(SettingDescription_climbingEnabled)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Core)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(jumpingEnabled),"CHECKBOX",
	[LSTRING(SettingDisplayName_jumpingEnabled),LSTRING(SettingDescription_jumpingEnabled)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Core)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxClimbHeight),"SLIDER",
	[LSTRING(SettingDisplayName_maxClimbHeight),LSTRING(SettingDescription_maxClimbHeight)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Core)],
	[1,3,2.6,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxDropHeight),"SLIDER",
	[LSTRING(SettingDisplayName_maxDropHeight),LSTRING(SettingDescription_maxDropHeight)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Core)],
	[2,20,5,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(jumpVelocity),"SLIDER",
	[LSTRING(SettingDisplayName_jumpVelocity),LSTRING(SettingDescription_jumpVelocity)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Core)],
	[1,50,3.4,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(allowMidairClimbing),"CHECKBOX",
	[LSTRING(SettingDisplayName_allowMidairClimbing),LSTRING(SettingDescription_allowMidairClimbing)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Core)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(blacklistStr),"EDITBOX",
	[LSTRING(SettingDisplayName_blacklistStr),LSTRING(SettingDescription_blacklistStr)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Core)],
	"",
	true,
	{GVAR(blacklist) = ((_this splitString ",") apply {toLower _x}) + (uiNamespace getVariable [QGVAR(classBlacklist),[]])},
	false
] call CBA_fnc_addSetting;

[QGVAR(whitelistStr),"EDITBOX",
	[LSTRING(SettingDisplayName_whitelistStr),LSTRING(SettingDescription_whitelistStr)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Core)],
	"",
	true,
	{GVAR(whitelist) = (_this splitString ",") apply {toLower _x}},
	false
] call CBA_fnc_addSetting;

[QGVAR(preventHighVaulting),"CHECKBOX",
	[LSTRING(SettingDisplayName_preventHighVaulting),LSTRING(SettingDescription_preventHighVaulting)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Preferences)],
	false,
	false,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(enableWalkableSurface),"CHECKBOX",
	[LSTRING(SettingDisplayName_enableWalkableSurface),LSTRING(SettingDescription_enableWalkableSurface)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Preferences)],
	true,
	false,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(staminaCoefficient),"SLIDER",
	[LSTRING(SettingDisplayName_staminaCoefficient),LSTRING(SettingDescription_staminaCoefficient)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Stamina)],
	[0,10,1,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(jumpDuty),"SLIDER",
	[LSTRING(SettingDisplayName_jumpDuty),LSTRING(SettingDescription_jumpDuty)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Stamina)],
	[0,10,1,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(climbOnDuty),"SLIDER",
	[LSTRING(SettingDisplayName_climbOnDuty),LSTRING(SettingDescription_climbOnDuty)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Stamina)],
	[0,10,3.4,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(climbOverDuty),"SLIDER",
	[LSTRING(SettingDisplayName_climbOverDuty),LSTRING(SettingDescription_climbOverDuty)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Stamina)],
	[0,10,3,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(dropDuty),"SLIDER",
	[LSTRING(SettingDisplayName_dropDuty),LSTRING(SettingDescription_dropDuty)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Stamina)],
	[0,10,0.7,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(jumpingLoadCoefficient),"SLIDER",
	[LSTRING(SettingDisplayName_jumpingLoadCoefficient),LSTRING(SettingDescription_jumpingLoadCoefficient)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Weight)],
	[0,10,1,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(enableWeightCheck),"CHECKBOX",
	[LSTRING(SettingDisplayName_enableWeightCheck),LSTRING(SettingDescription_enableWeightCheck)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Weight)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightJump),"SLIDER",
	[LSTRING(SettingDisplayName_maxWeightJump),LSTRING(SettingDescription_maxWeightJump)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Weight)],
	[0,200,100,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightClimb1),"SLIDER",
	[LSTRING(SettingDisplayName_maxWeightClimb1),LSTRING(SettingDescription_maxWeightClimb1)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Weight)],
	[0,200,100,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightClimb2),"SLIDER",
	[LSTRING(SettingDisplayName_maxWeightClimb2),LSTRING(SettingDescription_maxWeightClimb2)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Weight)],
	[0,200,85,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightClimb3),"SLIDER",
	[LSTRING(SettingDisplayName_maxWeightClimb3),LSTRING(SettingDescription_maxWeightClimb3)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Weight)],
	[0,200,60,1],
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
		params [["_code",{},[{}]]];

		GVAR(WSExitConditions) pushBack _code;
		publicVariable QGVAR(WSExitConditions);
	}] call CBA_fnc_addEventHandler;

	[QGVAR(addActionExitCondition),{
		params [["_code",{},[{}]]];

		GVAR(actionExitConditions) pushBack _code;
		publicVariable QGVAR(actionExitConditions);
	}] call CBA_fnc_addEventHandler;
};

ADDON = true;
