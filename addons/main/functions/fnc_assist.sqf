#include "script_component.hpp"
/*
	Author: Sceptre

	Description:
	Assist another unit to climb onto a higher ledge
	
	Parameters:
	0: Unit to perform action <OBJECT>

	Returns:
	Control override <BOOL>
*/

params ["_unit"];

if (_unit getVariable [QGVAR(isClimbing),false]) exitWith {true};

if (_unit getVariable [QGVAR(isAssisting),false]) exitWith {
	_unit setVariable [QGVAR(isAssisting),nil,true];
	true
};

if (!GVAR(climbingEnabled) ||
	!alive _unit ||
	{!(_unit in _unit)} ||
	{animationState _unit select [1,3] in ["bdv","bsw","dve","sdv","ssw","swm","inv"]} ||
	{!isTouchingGround _unit} || 
	{GVAR(assistHeight) isEqualTo 0}
) exitWith {false};

// Stop if height is short enough to climb without assistance
//_unit call FUNC(canDrop) params ["_canDrop","_depth","_tooHigh"];

//if (-_depth < GVAR(maxClimbHeight) - 0.1) exitWith {
//	//"ASSIST UNNECESSARY" call FUNC(hint);//LLSTRING(AssistUnnecessary)
//	false
//};

// Stop if out of stamina
private _duty = GVAR(assistDuty) * load _unit;
private _stamina = _unit call FUNC(getStamina);

if (_stamina < (_duty * GVAR(staminaCoefficient))) exitWith {
	LLSTRING(CantAssistStamina) call FUNC(hint);
	false
};

// Start 'assisting'
_unit setVariable [QGVAR(isAssisting),true,true];

// Prep
if (stance _unit != "CROUCH") then {
	_unit switchAction "PlayerCrouch";

	if (!isPlayer _unit) then {
		_unit setVariable [QGVAR(unitPos),unitPos _unit];
		_unit setUnitPos "MIDDLE";
	};
};

private _unholster = false;

if (currentWeapon _unit != "") then {
	_unit action ["SwitchWeapon",_unit,_unit,299];
	_unholster = true;
};

[{
	params ["_unit","_pos"];
	
	!alive _unit ||
	{!(_unit in _unit)} ||
	{stance _unit != "CROUCH"} ||
	{getPosASLVisual _unit distance _pos > 0.5 || (isPlayer _unit && currentWeapon _unit != "") || !(_unit getVariable [QGVAR(isAssisting),false])}
},{
	params ["_unit","","_unholster"];

	if (!isPlayer _unit) then {
		_unit setUnitPos (_unit getVariable [QGVAR(unitPos),"AUTO"]);
	};

	if (_unholster && currentWeapon _unit == "") then {
		private _weapon = switch true do {
			case (primaryWeapon _unit != ""): {primaryWeapon _unit};
			case (handgunWeapon _unit != ""): {handgunWeapon _unit};
			case (secondaryWeapon _unit != ""): {secondaryWeapon _unit};
			default {""};
		};

		if (_weapon != "") then {_unit selectWeapon _weapon};	
	};

	if (_unit getVariable [QGVAR(isAssisting),false]) then {
		_unit setVariable [QGVAR(isAssisting),nil,true];
	};
},[_unit,getPosASLVisual _unit,_unholster]] call CBA_fnc_waitUntilAndExecute;

true
