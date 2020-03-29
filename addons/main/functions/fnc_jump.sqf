#include "script_component.hpp"

params ["_unit"];

if (
	!alive _unit || 
	{!(_unit in _unit)} || 
	{((animationState _unit) select [1,3]) in ["bdv","bsw","dve","sdv","ssw","swm"]} || 
	{stance _unit != "STAND"} || 
	{!isTouchingGround _unit}
) exitWith {false};

if (_unit getVariable [QGVAR(isClimbing),false]) exitWith {true};

private _velocity = velocityModelSpace _unit;
//private _posASL = getPosASL _unit;
private _actionAnim = "babe_em_jump" + (switch (currentWeapon _unit) do {
	case (primaryWeapon _unit) : {"_rfl"};
	case (handgunWeapon _unit) : {"_pst"};
	default {"_ua"};
});

_unit playActionNow _actionAnim;
//_unit setPosASL [_posASL # 0,_posASL # 1,_posASL # 2 + 0.15];
_unit setVelocityModelSpace [_velocity # 0,_velocity # 1 + 0.1,3];

true
