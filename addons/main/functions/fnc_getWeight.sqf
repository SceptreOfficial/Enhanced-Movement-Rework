#include "script_component.hpp"

params ["_unit"];

if (isNull _unit) exitWith {0};

private _virtualLoad = 0;

{
	_virtualLoad = _virtualLoad + (_x getVariable ["ace_movement_vLoad", 0]);
} forEach [
	_unit,
	uniformContainer _unit,
	vestContainer _unit,
	backpackContainer _unit
];

private _weight = (loadAbs _unit + _virtualLoad) * 0.1;

(round (_weight * 100)) / 100
