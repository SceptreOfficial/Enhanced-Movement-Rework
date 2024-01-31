#include "..\script_component.hpp"

params [["_unit",objNull,[objNull]]];

if !(_unit call CBA_fnc_canUseWeapon) exitWith {false};

if (currentWeapon _unit != "") then {
	_unit action ["SwitchWeapon",_unit,_unit,299];
} else {
	private _weapon = switch true do {
		case (primaryWeapon _unit != ""): {primaryWeapon _unit};
		case (handgunWeapon _unit != ""): {handgunWeapon _unit};
		case (secondaryWeapon _unit != ""): {secondaryWeapon _unit};
		default {""};
	};

	if (_weapon != "") then {_unit selectWeapon _weapon};
};

true
