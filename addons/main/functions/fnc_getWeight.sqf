#include "script_component.hpp"
/*
	Author: Sceptre

	Description:
	Gets a unit's weight

	Parameters:
	0: Unit <OBJECT>

	Returns:
	Weight <SCALAR>
*/

params ["_unit"];

if (isNull _unit) exitWith {0};

private _virtualLoad = 0;

{_virtualLoad = _virtualLoad + (_x getVariable ["ace_movement_vLoad",0])} forEach [
	_unit,
	uniformContainer _unit,
	vestContainer _unit,
	backpackContainer _unit
];

(loadAbs _unit + _virtualLoad) / 10
