#include "script_component.hpp"

params ["_unit"];
	
if (!isTouchingGround _unit) exitWith {[false,0,false]};

private _debug = [];
private _pos = getPosASLVisual _unit;
private _dir = vectorDirVisual _unit;
private _heightAboveTerrain = getPosATL _unit # 2;

if (_heightAboveTerrain < 1) exitWith {[false,0,false]};

// Minimum required empty space
private _minBeg1 = _pos vectorAdd [0,0,0.4];
private _minEnd1 = (_pos vectorAdd [0,0,0.4]) vectorAdd (_dir vectorMultiply 1.2);
private _minBeg2 = (_pos vectorAdd [0,0,1.2]) vectorAdd (_dir vectorMultiply 1);
private _minEnd2 = (_pos vectorAdd [0,0,-1.2]) vectorAdd (_dir vectorMultiply 2);
private _minSurfaces = lineIntersectsSurfaces [_minBeg1,_minEnd1,_unit,objNull,true,-1,"GEOM","NONE"];
_minSurfaces append (lineIntersectsSurfaces [_minBeg2,_minEnd2,_unit,objNull,true,-1,"GEOM","NONE"]);

if (GVAR(debug)) then {
	[{drawLine3D _this},{},[ASLToATL _minBeg1,ASLToATL _minEnd1,[1,0,0,1]],10] call CBA_fnc_waitUntilAndExecute;
	[{drawLine3D _this},{},[ASLToATL _minBeg2,ASLToATL _minEnd2,[1,0,0,1]],10] call CBA_fnc_waitUntilAndExecute;
};

if !(_minSurfaces isEqualTo []) exitWith {[false,0,false]};

// Depth detection
private _beg = (_pos vectorAdd [0,0,0.4]) vectorAdd (_dir vectorMultiply 1.3);
private _end = (_pos vectorAdd [0,0,-GVAR(maxDropHeight)]) vectorAdd (_dir vectorMultiply 1.3);
private _surfaces = lineIntersectsSurfaces [_beg,_end,_unit,objNull,true,-1,"GEOM","NONE"];

if (GVAR(debug)) then {
	[{drawLine3D _this},{},[ASLToATL _beg,ASLToATL _end,[0,1,0,1]],10] call CBA_fnc_waitUntilAndExecute;
};

if (_surfaces isEqualTo []) exitWith {[false,0,true]};

[true,((_surfaces # 0 # 0 # 2) - (_pos # 2)) max -2.8,false]
