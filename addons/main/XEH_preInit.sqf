#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
#include "cba_settings.sqf"

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

GVAR(staminaDuration) = getNumber (configFile >> "CfgMovesFatigue" >> "staminaDuration");

["CAManBase","Killed",{
	(_this # 0) setVariable [QGVAR(isClimbing),nil];
}] call CBA_fnc_addClassEventHandler;

[QGVAR(setAnimSpeedCoef),{
	params ["_unit","_coef"];
	if (_unit getVariable ["EMR_animSpeedExclude",false]) exitWith {};
	_unit setAnimSpeedCoef _coef;
}] call CBA_fnc_addEventHandler;

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
