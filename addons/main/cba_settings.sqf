//---------------------------------------------//
// Core

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
	{
		GVAR(blacklist) = uiNamespace getVariable [QGVAR(preStartBlacklist),[]];
		private _cfgVehicles = configFile >> "CfgVehicles";

		{
			if (isClass (_cfgVehicles >> _x)) then {
				private _model = getText (_cfgVehicles >> _x >> "model");

				if (_model isEqualTo "") exitWith {};

				private _index = (reverse _model) find "\";
			
				if (_index > -1) then {
					_model = _model select [count _model - _index,_index];
				};
			
				GVAR(blacklist) pushBackUnique toLower _model;
			} else {
				GVAR(blacklist) pushBackUnique toLower _x;
			};
		} forEach (_this splitString ",");
	},
	false
] call CBA_fnc_addSetting;

[QGVAR(whitelistStr),"EDITBOX",
	[LSTRING(SettingDisplayName_whitelistStr),LSTRING(SettingDescription_whitelistStr)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Core)],
	"",
	true,
	{
		GVAR(whitelist) = [];
		private _cfgVehicles = configFile >> "CfgVehicles";

		{
			if (isClass (_cfgVehicles >> _x)) then {
				private _model = getText (_cfgVehicles >> _x >> "model");

				if (_model isEqualTo "") exitWith {};

				private _index = (reverse _model) find "\";
			
				if (_index > -1) then {
					_model = _model select [count _model - _index,_index];
				};
			
				GVAR(whitelist) pushBackUnique toLower _model;
			} else {
				GVAR(whitelist) pushBackUnique toLower _x;
			};
		} forEach (_this splitString ",");
	},
	false
] call CBA_fnc_addSetting;

[QGVAR(animSpeedCoef),"SLIDER",
	[LSTRING(SettingDisplayName_animSpeedCoef),LSTRING(SettingDescription_animSpeedCoef)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Core)],
	[0.3,2,1,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

//---------------------------------------------//
// Preferences

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

[QGVAR(hintType),"LIST",
	[LSTRING(SettingDisplayName_hintType),LSTRING(SettingDescription_hintType)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Preferences)],
	[[0,1,2,3,4],[
		LSTRING(HintType_Hint),
		LSTRING(HintType_HintSilent),
		LSTRING(HintType_TitleEffect),
		LSTRING(HintType_SystemChat),
		LSTRING(HintType_Disabled)
	],2],
	false,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(dropViewElevation),"SLIDER",
	[LSTRING(SettingDisplayName_DropViewElevation),LSTRING(SettingDescription_DropViewElevation)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Preferences)],
	[-0.9,-0.1,-0.7,2],
	false,
	{},
	false
] call CBA_fnc_addSetting;

//---------------------------------------------//
// Stamina

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

[QGVAR(animSpeedStaminaCoef),"SLIDER",
	[LSTRING(SettingDisplayName_animSpeedStaminaCoef),LSTRING(SettingDescription_animSpeedStaminaCoef)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Stamina)],
	[0,2,0.4,0,true],
	true,
	{},
	false
] call CBA_fnc_addSetting;

//---------------------------------------------//
// Weight

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
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightJump),"SLIDER",
	[LSTRING(SettingDisplayName_maxWeightJump),LSTRING(SettingDescription_maxWeightJump)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Weight)],
	[0,250,100,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightClimb1),"SLIDER",
	[LSTRING(SettingDisplayName_maxWeightClimb1),LSTRING(SettingDescription_maxWeightClimb1)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Weight)],
	[0,250,100,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightClimb2),"SLIDER",
	[LSTRING(SettingDisplayName_maxWeightClimb2),LSTRING(SettingDescription_maxWeightClimb2)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Weight)],
	[0,250,85,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(maxWeightClimb3),"SLIDER",
	[LSTRING(SettingDisplayName_maxWeightClimb3),LSTRING(SettingDescription_maxWeightClimb3)],
	[LSTRING(EnhancedMovementRework),LSTRING(SettingCategory_Weight)],
	[0,250,60,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

//---------------------------------------------//
