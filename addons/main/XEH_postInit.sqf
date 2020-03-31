#include "script_component.hpp"

["Enhanced Movement Rework","EMR_climb","Climb/Drop",{player call FUNC(climb)},{false},[0x2F,[false,false,false]]] call CBA_fnc_addKeybind;
["Enhanced Movement Rework","EMR_jump","Jump",{player call FUNC(jump)},{false},[0x2F,[true,false,false]]] call CBA_fnc_addKeybind;
if (hasInterface) then {
	GVAR(walkableSurface) = "babe_helper" createVehicleLocal [0,0,0];
	GVAR(walkableSurfacePFHID) = [FUNC(updateWalkableSurface),0] call CBA_fnc_addPerFrameHandler;
};
