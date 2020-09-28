#include "script_component.hpp"

params ["_unit"];

if (_unit getVariable [QGVAR(isClimbing),false]) exitWith {true};

if (UNIVERSAL_EXIT_CONDITION) exitWith {false};

private _animPosASL = getPosASLVisual _unit;
private _targetPosASL = +_animPosASL;
private _dir = vectorDirVisual _unit;
private _duty = 0;
private _actionAnim = "";

// Climb/drop detection
_unit call FUNC(canClimb) params ["_canClimb","_climbOn","_height"];
_unit call FUNC(canDrop) params ["_canDrop","_depth","_tooHigh"];

if (_canClimb) then {
	if (_climbOn) then {
		CLIMB_ON_PROCEDURE;
	} else {	
		CLIMB_OVER_PROCEDURE;
	};
};

if (!_canClimb && _canDrop) then {
	DROP_PROCEDURE;
};

// Stop if can't climb or drop (+ Prevent high edge vault)
if (_actionAnim == "") exitWith {
	if (_tooHigh) then {
		hint LLSTRING(CantDropTooHigh);
		GVAR(preventHighVaulting)
	} else {
		false
	}
};

// Stop if out of stamina
if (_unit call FUNC(getStamina) < (_duty * GVAR(staminaCoefficient))) exitWith {
	hint LLSTRING(CantClimbStamina);
	false
};

[_unit,_animPosASL,_targetPosASL,_actionAnim,_canClimb,_duty] call FUNC(startClimbing);

true
