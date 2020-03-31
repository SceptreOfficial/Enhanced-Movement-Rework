#include "script_component.hpp"
/*
	Author: Diwako

	Description:
	Gets a unit's stamina (ACE compatible)
*/

params ["_unit"];

private _stamina = 100;

if (isPlayer _unit && missionNamespace getVariable ["ace_advanced_fatigue_enabled",false]) then {
	_stamina = (ace_advanced_fatigue_anReserve / 2300) * 100;
} else {
	_stamina = getStamina _unit;
};

_stamina
