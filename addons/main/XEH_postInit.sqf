#include "script_component.hpp"

["Enhanced Movement Rework","EMR_climb","Climb/Drop",{
	if (GVAR(climbingEnabled)) then {
		(call CBA_fnc_currentUnit) call FUNC(climb)
	} else {false}
},{false},[0x2F,[false,false,false]]] call CBA_fnc_addKeybind;

["Enhanced Movement Rework","EMR_jump","Jump",{
	if (GVAR(jumpingEnabled)) then {
		(call CBA_fnc_currentUnit) call FUNC(jump)
	} else {false}
},{false},[0x2F,[true,false,false]]] call CBA_fnc_addKeybind;

if (hasInterface) then {
	GVAR(walkableSurface) = "babe_helper" createVehicleLocal [0,0,0];
	GVAR(walkableSurfacePFHID) = [FUNC(updateWalkableSurface),0] call CBA_fnc_addPerFrameHandler;
};
