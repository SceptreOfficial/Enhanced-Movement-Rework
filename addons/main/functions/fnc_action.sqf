#include "script_component.hpp"
/*
	Author: Sceptre

	Description:
	All-in-one enhanced movement action. Will make a unit climb or drop if possible, or jump otherwise.
	
	Parameters:
	0: Unit to perform action <OBJECT>

	Returns:
	Control override <BOOL>
*/

params ["_unit"];

if (_unit getVariable [QGVAR(isClimbing),false]) exitWith {true};

if (UNIVERSAL_EXIT_CONDITION) exitWith {false};

private _animPosASL = getPosASLVisual _unit;
private _targetPosASL = +_animPosASL;
private _dir = vectorDirVisual _unit;
private _duty = 0;
private _actionAnim = "";
private _viewElevation = getCameraViewDirection _unit # 2;

// Detections
_unit call FUNC(canClimb) params ["_canClimb","_climbOn","_height"];
_unit call FUNC(canDrop) params ["_canDrop","_depth","_tooHigh"];

switch true do {
		case (_viewElevation < GVAR(dropViewElevation) && _canDrop) : {
		DROP_PROCEDURE;
	};
	case (_canClimb) : {
		if (_climbOn) then {
			CLIMB_ON_PROCEDURE;
		} else {
			CLIMB_OVER_PROCEDURE;
		};
	};
};

// Exit with jump if can't climb or drop
if (_actionAnim == "" && isTouchingGround _unit) exitWith {
	if (_viewElevation < GVAR(dropViewElevation) && _tooHigh) then {
		LLSTRING(CantDropTooHigh) call FUNC(hint);
	};

	_unit call FUNC(jump)
};

// Stop if can't climb, drop, or jump
if (_actionAnim == "") exitWith {false};

// Stop if out of stamina
private _stamina = _unit call FUNC(getStamina);

if (_stamina < (_duty * GVAR(staminaCoefficient))) exitWith {
	LLSTRING(CantClimbStamina) call FUNC(hint);
	false
};

[_unit,_animPosASL,_targetPosASL,_actionAnim,_canClimb,_duty,_stamina] call FUNC(startClimbing);

true
