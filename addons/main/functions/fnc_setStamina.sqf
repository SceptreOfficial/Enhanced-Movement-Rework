#include "script_component.hpp"
/*
	Authors: Diwako, Sceptre, Freddo

	Description:
	Sets a unit's stamina (ACE compatible)

	Parameters:
	0: Unit <OBJECT>
	1: Amount <SCALAR>
*/

params [["_unit",objNull,[objNull]],["_amount",0,[0]]];

if (isPlayer _unit && missionNamespace getVariable ["ace_advanced_fatigue_enabled",false]) then {
	_amount = (_amount / ace_advanced_fatigue_performanceFactor) / 100;
	ace_advanced_fatigue_anReserve = ace_advanced_fatigue_anReserve + (2300 * _amount);
	ace_advanced_fatigue_anFatigue = ((ace_advanced_fatigue_anFatigue - (_amount * 0.8)) min 0.8) max ace_advanced_fatigue_anFatigue; // ~0.8 is seemingly the max fatigue one can get
} else {
	_unit setStamina ((getStamina _unit) + _amount);
};
