#include "script_component.hpp"
/*
	Author: Sceptre

	Description:
	Makes a unit jump.

	Parameters:
	0: Unit to perform action <OBJECT>

	Returns:
	Control override <BOOL>
*/

params [["_unit",objNull,[objNull]]];

if (_unit getVariable [QGVAR(isClimbing),false]) exitWith {true};

if (!GVAR(jumpingEnabled) || UNIVERSAL_EXIT_CONDITION || {!isTouchingGround _unit}) exitWith {false};

if (GVAR(enableWeightCheck) && _unit call FUNC(getWeight) > GVAR(maxWeightJump)) exitWith {
	if (IS_PLAYER(_unit)) then {LLSTRING(CantJumpOverweight) call FUNC(hint)};
	false
};

if (_unit call FUNC(getStamina) < (GVAR(jumpDuty) * GVAR(staminaCoefficient))) exitWith {
	if (IS_PLAYER(_unit)) then {LLSTRING(CantJumpStamina) call FUNC(hint)};
	false
};

private _velocity = velocityModelSpace _unit;
private _jumpVelocity = GVAR(jumpVelocity);
private _forwardVelocity = linearConversion [0,5,_velocity # 1,0.1,GVAR(jumpForwardVelocity),true];
private _actionAnim = "babe_em_jump" + (switch (currentWeapon _unit) do {
	case (primaryWeapon _unit) : {"_rfl"};
	case (handgunWeapon _unit) : {"_pst"};
	default {"_ua"};
});

private _ix = lineIntersectsSurfaces [_unit modelToWorldVisualWorld [0,0,0.5],_unit modelToWorldVisualWorld [0,0,-0.2],_unit,GVAR(walkableSurface),true,1,"GEOM","NONE"];

if (_ix isNotEqualTo [] && {_ix # 0 # 2 isKindOf "CAManBase"}) then {
	_jumpVelocity = _jumpVelocity * GVAR(yeetCoefficient);
	_forwardVelocity = _forwardVelocity * GVAR(yeetCoefficient);
};

if (stance _unit == "KNEEL") then {
	_jumpVelocity = _jumpVelocity * 0.75;
	_forwardVelocity = _forwardVelocity * 0.75
};

_unit playActionNow _actionAnim;

_unit setVelocityModelSpace [
	_velocity # 0,
	_velocity # 1 + (_forwardVelocity - load _unit * GVAR(jumpingLoadCoefficient)) max 0.1,
	(_jumpVelocity - load _unit * GVAR(jumpingLoadCoefficient)) max 1
];

[QGVAR(setStamina),[_unit,-(GVAR(jumpDuty) * GVAR(staminaCoefficient))]] call CBA_fnc_localEvent;

true
