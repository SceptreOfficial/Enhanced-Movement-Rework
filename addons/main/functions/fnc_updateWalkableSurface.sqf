#include "script_component.hpp"
/*
	Author: Sceptre

	Description:
	Updates invisible walkable surface under player when on top of objects.
*/

private _unit = call CBA_fnc_currentUnit;
private _helper = GVAR(walkableSurface);

if (!GVAR(enableWalkableSurface) || alive objectParent _unit || {GVAR(WSExitConditions) findIf {_unit call _x} != -1}) exitWith {
	_helper setPosASL [0,0,0];
};

private _ix = lineIntersectsSurfaces [AGLToASL (_unit modelToWorld [0,0,0.5]),AGLToASL (_unit modelToWorld [0,0,-0.2]),_unit,_helper,true,1,"GEOM","NONE"];

if (_ix isEqualTo []) exitWith {
	_helper setPosASL [0,0,0];
};

(_ix # 0) params ["_posASL","_normal","_obj"];

if (isNull _obj) exitWith {
	_helper setPosASL [0,0,0];
};

private _class = toLower typeOf _obj;

if (!(_class in GVAR(whitelist)) && _class in GVAR(blacklist)) exitWith {
	_helper setPosASL [0,0,0];
};

_helper setMass 0;
_helper setPosASL _posASL;
_helper setVectorUp _normal;
_obj disableCollisionWith _helper;
