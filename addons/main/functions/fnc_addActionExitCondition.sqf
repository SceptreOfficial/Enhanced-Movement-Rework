#include "script_component.hpp"
/*
	Author: Sceptre

	Description:
	Adds an exit condition to evauluate before jumping, climbing, and dropping.

	Parameters:
	0: Exit condition <CODE>
*/

params [["_code",{},[{}]]];

[QGVAR(addActionExitCondition),_code] call CBA_fnc_serverEvent;
