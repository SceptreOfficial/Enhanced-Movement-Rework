#include "script_component.hpp"
#include "XEH_PREP.hpp"

private _classBlacklist = [];

{
	if (isNumber (_x >> "EMR_blacklist") && {getNumber (_x >> "EMR_blacklist") > 0}) then {
		_classBlacklist pushBack toLower configName _x;
	};
} forEach configProperties [configFile >> "CfgVehicles","isClass _x",false];

uiNamespace setVariable [QGVAR(classBlacklist),_classBlacklist];
