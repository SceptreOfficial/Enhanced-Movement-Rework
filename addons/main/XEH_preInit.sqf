#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

["CAManBase","Killed",{
	(_this # 0) setVariable [QGVAR(isClimbing),nil];
}] call CBA_fnc_addClassEventHandler;

ADDON = true;
