#include "script_component.hpp"

private _player = call CBA_fnc_currentUnit;
private _helper = GVAR(walkableSurface);

if (!GVAR(enableWalkableSurface) || !(_player in _player)) exitWith {
	_helper setPos [0,0,0];
};

if ({_player call _x} count GVAR(WSExitConditions) != 0) exitWith {
	_helper setPos [0,0,0];
};

private _ins = lineIntersectsSurfaces [
	AGLToASL (_player modelToWorld [0,0,0.5]), 
	AGLToASL (_player modelToWorld [0,0,-0.2]),
	_player,
	_helper,
	true,
	1,
	"GEOM",
	"NONE"
];

if (_ins isEqualTo []) exitWith {
	_helper setPosASL [0,0,0];
};

(_ins # 0) params ["_pos","_normal","_obj"];

if (isNull _obj || typeOf _obj in GVAR(objectClassBlacklist)) exitWith {
	_helper setPosASL [0,0,0];
};

_helper setMass 0;
_helper setPosASL _pos;
_helper setVectorUp _normal;
_obj disableCollisionWith _helper;
