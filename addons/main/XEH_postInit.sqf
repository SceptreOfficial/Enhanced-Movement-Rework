#include "script_component.hpp"

[LSTRING(EnhancedMovementRework),"EMR_action",LSTRING(Keybind_AIOAction),{
	if (!isNull findDisplay IDD_RSCDISPLAYCURATOR) exitWith {false};
	(call CBA_fnc_currentUnit) call FUNC(action)
},{false},[DIK_V,[true,false,false]]] call CBA_fnc_addKeybind;

[LSTRING(EnhancedMovementRework),"EMR_climb",LSTRING(Keybind_ClimbDropOnly),{
	if (!isNull findDisplay IDD_RSCDISPLAYCURATOR) exitWith {false};
	(call CBA_fnc_currentUnit) call FUNC(climb)
},{false},[0,[false,false,false]]] call CBA_fnc_addKeybind;

[LSTRING(EnhancedMovementRework),"EMR_jump",LSTRING(Keybind_JumpOnly),{
	if (!isNull findDisplay IDD_RSCDISPLAYCURATOR) exitWith {false};
	(call CBA_fnc_currentUnit) call FUNC(jump)
},{false},[0,[false,false,false]]] call CBA_fnc_addKeybind;

[LSTRING(EnhancedMovementRework),"EMR_holster",LSTRING(Keybind_HolsterWeapon),{// From ACE3
	if (!isNull findDisplay IDD_RSCDISPLAYCURATOR) exitWith {false};

	private _unit = call CBA_fnc_currentUnit;

	if !(_unit call CBA_fnc_canUseWeapon) exitWith {false};

	if (currentWeapon _unit != "") then {
		_unit action ["SwitchWeapon",_unit,_unit,299];
	} else {
		private _weapon = switch true do {
			case (primaryWeapon _unit != ""): {primaryWeapon _unit};
			case (handgunWeapon _unit != ""): {handgunWeapon _unit};
			case (secondaryWeapon _unit != ""): {secondaryWeapon _unit};
			default {""};
		};

		if (_weapon != "") then {_unit selectWeapon _weapon};
	};

	true
},{false},[0,[false,false,false]],false] call CBA_fnc_addKeybind;

if (hasInterface) then {
	GVAR(walkableSurface) = "babe_helper" createVehicleLocal [0,0,0];
	GVAR(walkableSurfaceEFID) = addMissionEventHandler ["EachFrame",{call FUNC(updateWalkableSurface)}];
};
