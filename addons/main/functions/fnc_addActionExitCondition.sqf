#include "script_component.hpp"

params [["_code",{},[{}]]];

[QGVAR(addActionExitCondition),_code] call CBA_fnc_serverEvent;
