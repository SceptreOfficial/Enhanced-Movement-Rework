#include "script_component.hpp"
/*
	Author: Diwako

	Description:
	Sets a unit's stamina (ACE compatible)
*/

params ["_unit","_amount"];

if (isPlayer _unit && missionNamespace getVariable ["ace_advanced_fatigue_enabled",false]) then {
	// advanced fatigue does not have any setter function, all that can be done is to increase the work factor for a second or two
	private _id = format ["EMR_stamina_%1",diag_tickTime];

	[_id,(0.8 * -_amount) max 1] call ace_advanced_fatigue_fnc_addDutyFactor;

	[{[_this] call ace_advanced_fatigue_fnc_removeDutyFactor},_id,2] call CBA_fnc_waitAndExecute;
} else {
	_unit setStamina ((getStamina _unit) + _amount);
};
