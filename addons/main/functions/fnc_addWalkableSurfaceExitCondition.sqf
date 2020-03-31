#include "script_component.hpp"

params ["_code",{},[{}]];

[QGVAR(addWSExitCondition),_code] call CBA_fnc_serverEvent;
