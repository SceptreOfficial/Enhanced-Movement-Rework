#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

["CAManBase","Killed",{
	(_this # 0) setVariable [QGVAR(isClimbing),nil];
}] call CBA_fnc_addClassEventHandler;

GVAR(WSExitConditions) = [
	{!isNil {_this getVariable "acex_sitting_sittingStatus"}},
	{animationState _this == "ACE_FastRoping"}
];

if (isServer) then {
	[QGVAR(addWSExitCondition),{
		params ["_code",{},[{}]];

		GVAR(WSExitConditions) pushBack _code;
		publicVariable QGVAR(WSExitConditions);
	}] call CBA_fnc_addEventHandler;
};

ADDON = true;
