#include "script_component.hpp"

params ["_unit"];
	
//private _debug = [];

private _pos = getPosASLVisual _unit;
private _dir = vectorDirVisual _unit;
private _dirVect = _dir vectorMultiply 1.2;
private _heightAboveTerrain = getPosATL _unit # 2;

if (_heightAboveTerrain < 0.8) exitWith {[false,0]};

private _beg = (_pos vectorAdd [0,0,1.4]) vectorAdd (_dir vectorMultiply 1);

// Min empty space
private _minEnd = (_pos vectorAdd [0,0,-1.4]) vectorAdd (_dir vectorMultiply 2);
private _minSurfaces = lineIntersectsSurfaces [_beg,_minEnd,_unit,objNull,true,-1,"GEOM","GEOM"];
//_debug pushBack [ASLToATL _beg,ASLToATL _minEnd,[1,0,0,1]];

if !(_minSurfaces isEqualTo []) exitWith {[false,0]};

private _end = (_pos vectorAdd [0,0,-4]) vectorAdd (_dir vectorMultiply 2.7);
private _surfaces = lineIntersectsSurfaces [_beg,_end,_unit,objNull,true,-1,"GEOM","GEOM"];
//_debug pushBack [ASLToATL _beg,ASLToATL _end,[0,1,0,1]];

if (_surfaces isEqualTo []) exitWith {[false,0]};

//[{{drawLine3D _x} forEach _this},{},_debug,10] call CBA_fnc_waitUntilAndExecute;

[true,((_surfaces # 0 # 0 # 2) - (_pos # 2)) max -2.8]
