#include "script_component.hpp"

if (!hasInterface) exitWith {
	GVAR(walkableSurface) = objNull;
};

[LSTRING(EnhancedMovementRework),QPVAR(action),LSTRING(Keybind_AIOAction),KEY_CODE(action),{false},[DIK_V,[true,false,false]]] call CBA_fnc_addKeybind;
[LSTRING(EnhancedMovementRework),QPVAR(climb),LSTRING(Keybind_ClimbDropOnly),KEY_CODE(climb),{false},[0,[false,false,false]]] call CBA_fnc_addKeybind;
[LSTRING(EnhancedMovementRework),QPVAR(jump),LSTRING(Keybind_JumpOnly),KEY_CODE(jump),{false},[0,[false,false,false]]] call CBA_fnc_addKeybind;
[LSTRING(EnhancedMovementRework),QPVAR(assist),LSTRING(Keybind_Assist),KEY_CODE(assist),{false},[DIK_V,[false,false,true]]] call CBA_fnc_addKeybind;
[LSTRING(EnhancedMovementRework),QPVAR(holster),LSTRING(Keybind_HolsterWeapon),KEY_CODE(holster),{false},[0,[false,false,false]],false] call CBA_fnc_addKeybind;
[LSTRING(EnhancedMovementRework),QPVAR(interact),LSTRING(Keybind_Interact),KEY_CODE(interact),{false},[0,[false,false,false]],false] call CBA_fnc_addKeybind;

GVAR(walkableSurface) = "babe_helper" createVehicleLocal [0,0,0];
GVAR(walkableSurfaceEFID) = addMissionEventHandler ["EachFrame",{call FUNC(updateWalkableSurface)}];
