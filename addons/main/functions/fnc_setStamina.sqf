#include "script_component.hpp"
/*
	Authors: Diwako, Sceptre

	Description:
	Sets a unit's stamina (ACE compatible)

	Parameters:
	0: Unit <OBJECT>
	1: Amount <SCALAR>
*/

params ["_unit","_amount"];

if (isPlayer _unit && missionNamespace getVariable ["ace_advanced_fatigue_enabled",false]) then {
	ace_advanced_fatigue_anReserve = ace_advanced_fatigue_anReserve + (
		2300 * ((_amount / ace_advanced_fatigue_performanceFactor) / 100)
	);
} else {
	_unit setStamina ((getStamina _unit) + _amount);
};
