#include "script_component.hpp"
/*
	Author: Diwako

	Description:
	Sets a unit's stamina (ACE compatible)
*/

params ["_unit","_amount"];

if (isPlayer _unit && missionNamespace getVariable ["ace_advanced_fatigue_enabled",false]) then {
	ace_advanced_fatigue_anReserve = ace_advanced_fatigue_anReserve + (
		ace_advanced_fatigue_anReserve * ((_amount / ace_advanced_fatigue_performanceFactor) / 100)
	);
} else {
	_unit setStamina ((getStamina _unit) + _amount);
};
