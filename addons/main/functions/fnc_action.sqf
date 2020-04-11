#include "script_component.hpp"

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
	case (_viewElevation < -0.5 && _canDrop) : {
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
	if (_viewElevation < -0.5 && _tooHigh) then {
		hint "CAN'T DROP: TOO HIGH";
	};

	_unit call FUNC(jump)
};

// Stop if can't climb, drop, or jump
if (_actionAnim == "") exitWith {false};

// Stop if out of stamina
if (_unit call FUNC(getStamina) < (_duty * GVAR(staminaCoefficient))) exitWith {
	hint "CAN'T CLIMB: NOT ENOUGH STAMINA";
	false
};

[_unit,_animPosASL,_targetPosASL,_actionAnim,_canClimb,_duty] call FUNC(startClimbing);

true
