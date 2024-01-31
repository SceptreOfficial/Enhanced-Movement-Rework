#include "..\script_component.hpp"
/*
	Author: Sceptre

	Description:
	Adds an exit condition to evauluate before updating the walkable surface.

	Parameters:
	0: Exit condition <CODE>
*/

params [["_code",{},[{}]]];

[QGVAR(addWSExitCondition),_code] call CBA_fnc_serverEvent;
