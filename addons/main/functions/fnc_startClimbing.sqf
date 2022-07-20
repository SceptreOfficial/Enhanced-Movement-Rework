#include "script_component.hpp"
/*
	Author: Sceptre

	Description:
	Starts climbing animations and procedures

	Parameters:
	0: Unit <OBJECT>
	1: Animation position <ARRAY>
	2: Target position <ARRAY>
	3: Animation <STRING>
	4: Can climb (to handle direction change) <BOOL>
	5: Stamina duty <SCALAR>
	6: Unit current stamina (for animation speed scaling) <SCALAR>
*/

params ["_unit","_animPosASL","_targetPosASL","_actionAnim","_canClimb","_duty","_stamina"];

// Determine animation types
private _prepAnim = "";
_actionAnim = _actionAnim + (switch (currentWeapon _unit) do {
	case "" : {"_ua"};
	case (primaryWeapon _unit) : {
		if (weaponLowered _unit) then {_prepAnim = "AmovPercMstpSrasWrflDnon";};
		"_rfl"
	};
	case (secondaryWeapon _unit) : {
		_prepAnim = "AmovPercMstpSnonWnonDnon";
		"_ua"
	};
	case (handgunWeapon _unit) : {
		if (weaponLowered _unit) then {_prepAnim = "AmovPercMstpSrasWpstDnon";};
		"_pst"
	};
	default {"_ua"};
});

// Start 'climbing'
_unit setVariable [QGVAR(isClimbing),true];

// Handle vehicle entering glitch
private _getInManEHID = [_unit,"GetInMan",{
	params ["_unit"];

	_unit removeEventHandler [_thisType,_thisID];
	_unit removeEventHandler ["AnimDone",_unit getVariable [QGVAR(animDoneEHID),-1]];
	_unit removeEventHandler ["AnimChanged",_unit getVariable [QGVAR(animChangedEHID),-1]];
	_unit setVariable [QGVAR(isClimbing),nil];
	ANIM_SPEED_COEF_END(_unit);

	// CBA event
	[QGVAR(climbingEnd),[_unit,_thisArgs]] call CBA_fnc_localEvent;
},_actionAnim] call CBA_fnc_addBISEventHandler;

// Handle animation end
private _animDoneEHID = [_unit,"AnimDone",{
	params ["_unit","_animation"];
	_thisArgs params ["_actionAnim","_targetPosASL"];

	if !(_unit getVariable [QGVAR(isClimbing),false]) exitWith {
		_unit removeEventHandler ["GetInMan",_unit getVariable [QGVAR(getInManEHID),-1]];
		_unit removeEventHandler [_thisType,_thisID];
		_unit setVariable [QGVAR(isClimbing),nil];
		ANIM_SPEED_COEF_END(_unit);

		// CBA event
		[QGVAR(climbingEnd),[_unit,_animation]] call CBA_fnc_localEvent;
	};

	if (_animation == _actionAnim) then {
		_unit removeEventHandler ["GetInMan",_unit getVariable [QGVAR(getInManEHID),-1]];
		_unit removeEventHandler [_thisType,_thisID];
		_unit setVariable [QGVAR(isClimbing),nil];
		_unit setPosASL _targetPosASL;
		ANIM_SPEED_COEF_END(_unit);

		// CBA event
		[QGVAR(climbingEnd),[_unit,_actionAnim]] call CBA_fnc_localEvent;
	};
},[_actionAnim,_targetPosASL]] call CBA_fnc_addBISEventHandler;

// Handle animation start
private _animChangedEHID = [_unit,"AnimChanged",{
	params ["_unit","_animation"];
	_thisArgs params ["_actionAnim","_animPosASL","_canClimb"];

	if (_animation == _actionAnim) then {
		_unit removeEventHandler [_thisType,_thisID];

		// Check if unit can still climb/drop in case direction is changed.
		if (
			_canClimb && {!((_unit call FUNC(canClimb)) # 0)} ||
			!_canClimb && {!((_unit call FUNC(canDrop)) # 0)}
		) exitWith {
			_unit switchMove "";
			_unit setVariable [QGVAR(isClimbing),nil];
			ANIM_SPEED_COEF_END(_unit);
		};
		
		// Visual fix since animation may take a few frames to actually begin
		[{
			animationState (_this # 0) == (_this # 2) || !alive (_this # 0)
		},{
			(_this # 0) setPosASL (_this # 1);
		},[_unit,_animPosASL,_actionAnim],8] call CBA_fnc_waitUntilAndExecute;
		
		// Prevent any velocity changes while climbing
		[{
			_this setVelocity [0,0,0];
			!alive _this || !(_this getVariable [QGVAR(isClimbing),false])
		},{},_unit,8,{
			_this setVariable [QGVAR(isClimbing),nil];
		}] call CBA_fnc_waitUntilAndExecute;

		// CBA event
		[QGVAR(climbingStart),[_unit,_actionAnim]] call CBA_fnc_localEvent;
	};
},[_actionAnim,_animPosASL,_canClimb]] call CBA_fnc_addBISEventHandler;

_unit setVariable [QGVAR(getInManEHID),_getInManEHID];
_unit setVariable [QGVAR(animDoneEHID),_animDoneEHID];
_unit setVariable [QGVAR(animChangedEHID),_animChangedEHID];

// Prep for stances, launcher weapon, or mid-air usage
if (isTouchingGround _unit) then {
	if (stance _unit != "STAND") then {
		_unit switchAction "PlayerStand";
	};

	if (_prepAnim != "") then {
		_unit playMove _prepAnim;
	};
} else {
	if (_prepAnim != "") then {
		_unit switchMove _prepAnim;
	};
};

// Set animation speed
if (!isNil "ace_advanced_fatigue_setAnimExclusions") then {
	ace_advanced_fatigue_setAnimExclusions pushBack QUOTE(ADDON);
};

private _max = [GVAR(staminaDuration),100] select (isPlayer _unit && missionNamespace getVariable ["ace_advanced_fatigue_enabled",false]);
private _speed = GVAR(animSpeedCoef) * (linearConversion [1,0,GVAR(animSpeedStaminaCoef),_stamina,_max] / _max) max 0.3;
_unit setVariable [QGVAR(animSpeedCoef),getAnimSpeedCoef _unit,true];
[QGVAR(setAnimSpeedCoef),[_unit,_speed]] call CBA_fnc_globalEvent;

// Play animation
_unit playMove _actionAnim;

// Set stamina drain
[QGVAR(setStamina),[_unit,-(_duty * GVAR(staminaCoefficient))]] call CBA_fnc_localEvent;
