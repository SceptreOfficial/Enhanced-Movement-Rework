#include "..\script_component.hpp"

params [["_unit",objNull,[objNull]]];

if !(_unit in _unit) exitWith {	
	private _vehicle = vehicle _unit;
	
	if (unitIsUAV _vehicle && _unit in [driver _vehicle,gunner _vehicle]) exitWith {false};

	switch GVAR(interactBehaviorInVehicle) do {
		case "DISMOUNT" : {
			if (_unit == driver _vehicle) then {
				_vehicle engineOn false;
			};

			if (_vehicle isKindOf "Air" || _vehicle isKindOf "StaticWeapon") then {	
				_unit action ["GetOut",_vehicle];
			} else {
				_unit action ["Eject",_vehicle];
			};

			true
		};
		case "ENGINE" : {
			if (_unit == driver _vehicle) then {
				_vehicle engineOn !isEngineOn _vehicle;
			};
			
			true
		};
	};	
};

private _reach = ((AGLToASL positionCameraToWorld [0,0,0]) vectorDistance (_unit modelToWorldVisualWorld (_unit selectionPosition "Head"))) + 2;
private _camPosATL = positionCameraToWorld [0,0,0];
private _targetPosATL = positionCameraToWorld [0,0,_reach];
private _camPosASL = ATLToASL _camPosATL;
private _targetPosASL = ATLToASL _targetPosATL;
private _ix = lineIntersectsSurfaces [_camPosASL,_targetPosASL,_unit,cameraOn,true,1,"GEOM","FIRE"];
DEBUG_G(_camPosASL,_targetPosASL);

if (_ix isEqualTo []) then {
	_ix = lineIntersectsSurfaces [_unit modelToWorldVisualWorld [0,0,0.5],_unit modelToWorldVisualWorld [0,0,-1],_unit,cameraOn,true,1,"GEOM","FIRE"];
};

if (_ix isEqualTo []) exitWith {false};

private _target = _ix # 0 # 2;

if (isNull _target) exitWith {false};

// Adapted from ACE3 - "ace_quickmount_fnc_getInNearest"
// https://github.com/acemod/ACE3/blob/master/addons/quickmount/functions/fnc_getInNearest.sqf
if (alive _target && 
	{["LandVehicle","Air","Ship","StaticMortar"] findIf {_target isKindOf _x} > -1} &&
	{speed _target < 15} &&
	{locked _target <= 1}
) exitWith {
	private _sortedSeats = ["Driver","Gunner","Commander","Cargo"];
	private _hasAction = false;
	scopeName "SearchForSeat";
	{
		private _desiredRole = _x;
		{
			_x params ["_activeUnit","_role","_cargoIndex","_turretPath"];
			
			if (alive _activeUnit) then {continue};

			private _effectiveRole = toLower _role;

			if (_effectiveRole in ["driver","gunner"] && unitIsUAV _target) exitWith {}; // Ignoring UAV Driver/Gunner
			if (_effectiveRole == "driver" && {getNumber (configOf _target >> "hasDriver") == 0}) exitWith {}; // Ignoring Non Driver (static weapons)

			// Seats can be locked independently of the main vehicle
			if (_role == "driver" && lockedDriver _target ||
				{cargoIndex >= 0 && _target lockedCargo _cargoIndex} ||
				{_turretPath isNotEqualTo [] && _target lockedTurret _turretPath}
			) exitWith {};

			if (_effectiveRole == "turret") then {
				private _turretConfig = [_target,_turretPath] call CBA_fnc_getTurret;

				if (getNumber (_turretConfig >> "isCopilot") == 1) exitWith {
					_effectiveRole = "driver";
				};

				if (
					_cargoIndex >= 0 // FFV
					|| {"" isEqualTo getText (_turretConfig >> "gun")} // turret without weapon
				) exitWith {
					_effectiveRole = "cargo";
				};

				_effectiveRole = "gunner"; // door gunners / 2nd turret
			};

			if (_effectiveRole != _desiredRole) exitWith {};

			if (_turretPath isNotEqualTo []) then {
				// Using GetInTurret seems to solve problems with incorrect GetInEH params when gunner/commander
				_unit action ["GetInTurret",_target,_turretPath];
			} else {
				if (_cargoIndex > -1) then {
					// GetInCargo expects the index of the seat in the "cargo" array from fullCrew
					// See description: https://community.bistudio.com/wiki/fullCrew
					private _cargoActionIndex = -1;
					{
						if ((_x select 2) == _cargoIndex) exitWith {_cargoActionIndex = _forEachIndex};
					} forEach (fullCrew [_target,"cargo",true]);

					_unit action ["GetInCargo",_target,_cargoActionIndex];
				} else {
					_unit action ["GetIn" + _role,_target];
				};
			};

			_hasAction = true;
			breakTo "SearchForSeat";
		} forEach (fullCrew [_target, "", true]);
	} forEach _sortedSeats;

	if (!_hasAction) exitWith {
		if (IS_PLAYER(_unit)) then {LLSTRING(VehicleFull) call FUNC(hint)};
		false
	};

	true
};

if (getNumber (configOf _target >> "transportMaxBackpacks") > 0 ||
	getNumber (configOf _target >> "transportMaxMagazines") > 0 ||
	getNumber (configOf _target >> "transportMaxWeapons") > 0 ||
	{_target isKindOf "CAManBase" && {!alive _target || (_target in units group player && !isPlayer _target)}}
) exitWith {
	_unit action ["Gear",_target];
	true
};

private _ladders = getArray (configOf _target >> "ladders"); 
private _onLadder = false;

if (_ladders isNotEqualTo []) then {
	{
		private _ladderIndex = _forEachIndex;

		{
			private _ladderPos = _target modelToWorld (_target selectionPosition _x);
			private _pelvis = _unit selectionPosition "pelvis";

			if ((_unit modelToWorld (_pelvis vectorAdd [0,1,-1])) distance _ladderPos < 1 ||
				(_unit modelToWorld (_pelvis vectorAdd [0,1,0])) distance _ladderPos < 1
			) then {
				_unit action [["ladderUp","ladderDown"] select (_forEachIndex == 0),_target,_ladderIndex,_forEachIndex];
				_onLadder = true;
			};
		} foreach ([[_x # 0,_x # 1],[],{(_target selectionPosition _x) # 2}] call BIS_fnc_sortBy);
	} foreach _ladders;
};

if (_onLadder) exitWith {true};

_ix = [_target,"GEOM"] intersect [_camPosATL,_targetPosATL];

if (_ix isEqualTo []) then {
	_ix = [_target,"FIRE"] intersect [_camPosATL,_targetPosATL];
};

if (_ix isEqualTo []) exitWith {false};

private _selection = toLower (_ix # 0 # 0);

if (_target getVariable ["bis_disabled_" + _selection,0] == 1) then {
	_target animateSource [_selection + "_locked_source",1 - (_target animationSourcePhase (_selection + "_locked_source"))];
} else {
	{
		if (toLower _x find _selection > -1) then {
			if (_target animationPhase _x > 0.5) then {
				_target animate [_x,0];
			} else {
				_target animate [_x,1];
			};
		};
	} forEach animationNames _target;	
};

true
