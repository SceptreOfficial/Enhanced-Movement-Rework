#include "script_component.hpp"

params ["_unit"];

if (_unit getVariable [QGVAR(isClimbing),false]) exitWith {true};

if (
	!alive _unit || 
	{!(_unit in _unit)} || 
	{((animationState _unit) select [1,3]) in ["bdv","bsw","dve","sdv","ssw","swm"]} || 
	{stance _unit != "STAND"} || 
	{!isTouchingGround _unit}
) exitWith {false};

if (GVAR(enableWeightCheck) && (_unit call FUNC(getWeight)) > GVAR(maxWeightJump)) exitWith {
	hint "CAN'T JUMP: OVERWEIGHT";
	false
};

private _velocity = velocityModelSpace _unit;
private _actionAnim = "babe_em_jump" + (switch (currentWeapon _unit) do {
	case (primaryWeapon _unit) : {"_rfl"};
	case (handgunWeapon _unit) : {"_pst"};
	default {"_ua"};
});

_unit playActionNow _actionAnim;

if (GVAR(scaleJumpVelocity)) then {
	_unit setVelocityModelSpace [_velocity # 0,_velocity # 1 + 0.1,GVAR(jumpVelocity) - load _unit];
} else {
	_unit setVelocityModelSpace [_velocity # 0,_velocity # 1 + 0.1,GVAR(jumpVelocity)];
};

[_unit,-(1 * GVAR(staminaCoefficient))] call FUNC(setStamina);

true
