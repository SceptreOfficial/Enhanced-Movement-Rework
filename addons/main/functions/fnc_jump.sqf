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

params ["_unit"];

if (_unit getVariable [QGVAR(isClimbing),false]) exitWith {true};

if (!GVAR(jumpingEnabled) || UNIVERSAL_EXIT_CONDITION || {!isTouchingGround _unit}) exitWith {false};

if (GVAR(enableWeightCheck) && _unit call FUNC(getWeight) > GVAR(maxWeightJump)) exitWith {
	LLSTRING(CantJumpOverweight) call FUNC(hint);
	false
};

if (_unit call FUNC(getStamina) < (GVAR(jumpDuty) * GVAR(staminaCoefficient))) exitWith {
	LLSTRING(CantJumpStamina) call FUNC(hint);
	false
};

private _velocity = velocityModelSpace _unit;
private _jumpVelocity = GVAR(jumpVelocity);
private _actionAnim = "babe_em_jump" + (switch (currentWeapon _unit) do {
	case (primaryWeapon _unit) : {"_rfl"};
	case (handgunWeapon _unit) : {"_pst"};
	default {"_ua"};
});

if (stance _unit == "KNEEL") then {
	_jumpVelocity = _jumpVelocity - 0.8;
};

_unit playActionNow _actionAnim;

_unit setVelocityModelSpace [_velocity # 0,_velocity # 1 + 0.1,_jumpVelocity - load _unit * GVAR(jumpingLoadCoefficient)];

[_unit,-(GVAR(jumpDuty) * GVAR(staminaCoefficient))] call FUNC(setStamina);

true
