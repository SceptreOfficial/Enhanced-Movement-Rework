#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
#include "cba_settings.sqf"

GVAR(WSExitConditions) = [
	{!isNil {_this getVariable "ace_sitting_sittingStatus"}},
	{animationState _this isEqualTo "ace_fastroping"}
];

GVAR(actionExitConditions) = [
	{!isNil {_this getVariable "ace_sitting_sittingStatus"}},
	{animationState _this isEqualTo "ace_fastroping"},
	{!isNil {_this getVariable "ace_medical_treatment_endInAnim"}}
];

GVAR(staminaDuration) = getNumber (configFile >> "CfgMovesFatigue" >> "staminaDuration");
GVAR(rotVect90) = [[-4.37114e-008,-1,0],[1,-4.37114e-008,0],[0,0,1]];

["CAManBase","Killed",{
	(_this # 0) setVariable [QGVAR(isClimbing),nil];
}] call CBA_fnc_addClassEventHandler;

[QGVAR(setAnimSpeedCoef),{
	params ["_unit","_coef"];
	if (_unit getVariable [QPVAR(animSpeedExclude),false]) exitWith {};
	_unit setAnimSpeedCoef _coef;
}] call CBA_fnc_addEventHandler;

[QGVAR(setStamina),FUNC(setStamina)] call CBA_fnc_addEventHandler;

[QGVAR(assist),{
	params ["_unit","_assistedUnit","_assistedLoad"];

	_unit setVariable [QGVAR(isAssisting),nil,true];

	private _duty = GVAR(assistDuty) * ((load _unit * 0.2) + _assistedLoad);
	private _stamina = _unit call FUNC(getStamina);

	[QGVAR(setStamina),[_unit,-(_duty * GVAR(staminaCoefficient))]] call CBA_fnc_localEvent;
}] call CBA_fnc_addEventHandler;

[QGVAR(disableCollision),{
	params ["_climber","_assistant"];

	_climber disableCollisionWith _assistant;

	[{
		[{
			params ["_climber","_assistant"];
			!(_climber getVariable [QGVAR(isClimbing),false]) && _climber distance2D _assistant > 2
		},{
			params ["_climber","_assistant"];
			_climber enableCollisionWith _assistant;
		},_this,10,{
			params ["_climber","_assistant"];
			_climber enableCollisionWith _assistant;
		}] call CBA_fnc_waitUntilAndExecute;
	},[_climber,_assistant],2] call CBA_fnc_waitAndExecute;
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
