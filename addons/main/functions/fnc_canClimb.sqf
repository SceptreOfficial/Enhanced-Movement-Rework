#include "script_component.hpp"

params ["_unit"];

//private _debug = [];

private _pos = getPosASLVisual _unit;
private _dir = vectorDirVisual _unit;
private _dirVect = _dir vectorMultiply 1.2;
private _height = 0;

if !(lineIntersectsSurfaces [_pos,_pos vectorAdd [0,0,2.9],_unit,objNull,true,-1,"GEOM","GEOM"] isEqualTo []) exitWith {[false,false,_height]};

{
	private _beg = _pos vectorAdd [0,0,_x];
	private _end = _beg vectorAdd _dirVect;
	private _intersects = !(lineIntersectsSurfaces [_beg,_end,_unit,objNull,true,-1,"GEOM","GEOM"] isEqualTo []);
	//_debug pushBack [ASLToATL _beg,ASLToATL _end,[0,0,1,1]];

	if (!_intersects && _height != 0) exitWith {}; // found lowest intersect
	if (_intersects) then {_height = _x;};
} forEach [0.4,0.7,1,1.3,1.6,1.9,2.2,2.5,2.9];

if (_height isEqualTo 0 || _height > 2.5) exitWith {[false,false,_height]}; // no obstacle or too tall

private _hiPos = +_pos;
private _loPos = +_pos;
_hiPos set [2,_hiPos # 2 + _height + 0.6];
_loPos set [2,_loPos # 2 + 0.5];

private _climbOn = {
	private _beg = _hiPos vectorAdd (_dir vectorMultiply _x);
	private _end = _loPos vectorAdd (_dir vectorMultiply _x);
	//_debug pushBack [ASLToATL _beg,ASLToATL _end,[0,0,1,1]];

	!(lineIntersectsSurfaces [_beg,_end,_unit,objNull,true,-1,"GEOM","GEOM"] isEqualTo [])
} count [1.9,1.55,1.2] isEqualTo 3;

private _canClimb = if (_climbOn) then {
	private _sizeCheckBeg = (_pos vectorAdd [-0.3 * (_dir # 1),-0.3 * -(_dir # 0),_height + 0.3]) vectorAdd (_dir vectorMultiply 1);
	private _sizeCheckEnd = (_pos vectorAdd [0.35 * (_dir # 1),0.35 * -(_dir # 0),_height + 1.7]) vectorAdd (_dir vectorMultiply 1.5);
	//_debug pushBack [ASLToATL _sizeCheckBeg,ASLToATL _sizeCheckEnd,[0,1,0,1]];

	lineIntersectsSurfaces [_sizeCheckBeg,_sizeCheckEnd,_unit,objNull,true,-1,"GEOM","GEOM"] isEqualTo []
} else {
	private _holeCheckBeg = (_pos vectorAdd [-0.3 * (_dir # 1),-0.3 * -(_dir # 0),_height + 0.3]) vectorAdd (_dir vectorMultiply 1);
	private _holeCheckEnd = (_pos vectorAdd [0.35 * (_dir # 1),0.35 * -(_dir # 0),_height + 0.7]) vectorAdd (_dir vectorMultiply 1.4);
	//_debug pushBack [ASLToATL _holeCheckBeg,ASLToATL _holeCheckEnd,[0,1,0,1]];

	lineIntersectsSurfaces [_holeCheckBeg,_holeCheckEnd,_unit,objNull,true,-1,"GEOM","GEOM"] isEqualTo []
};

//[{{drawLine3D _x} forEach _this},{},_debug,10] call CBA_fnc_waitUntilAndExecute;

[_canClimb,_climbOn,_height]