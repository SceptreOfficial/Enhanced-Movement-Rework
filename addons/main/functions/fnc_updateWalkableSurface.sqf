#include "script_component.hpp"

private _unit = call CBA_fnc_currentUnit;
private _helper = GVAR(walkableSurface);

if (!GVAR(enableWalkableSurface) || !(_unit in _unit) || {{_unit call _x} count GVAR(WSExitConditions) != 0}) exitWith {
	_helper setPosASL [0,0,0];
};

private _ix = lineIntersectsSurfaces [AGLToASL (_unit modelToWorld [0,0,0.5]),AGLToASL (_unit modelToWorld [0,0,-0.2]),_unit,_helper,true,1,"GEOM","NONE"];

if (_ix isEqualTo []) exitWith {
	_helper setPosASL [0,0,0];
};

(_ix # 0) params ["_pos","_normal","_obj"];

if (isNull _obj) exitWith {
	_helper setPosASL [0,0,0];
};

private _class = toLower typeOf _obj;

if (!(_class in GVAR(whitelist)) && _class in GVAR(blacklist)) exitWith {
	_helper setPosASL [0,0,0];
};

_helper setMass 0;
_helper setPosASL _pos;
_helper setVectorUp _normal;
_obj disableCollisionWith _helper;
