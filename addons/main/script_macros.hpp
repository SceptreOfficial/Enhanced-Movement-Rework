#include "\x\cba\addons\main\script_macros_common.hpp"
#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
#ifdef DISABLE_COMPILE_CACHE
	#undef PREP
	#define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
	#undef PREP
	#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#define UNIVERSAL_EXIT_CONDITION \
	!alive _unit || \
	{!(_unit in _unit)} || \
	{stance _unit == "PRONE"} || \
	{animationState _unit select [1,3] in ["bdv","bsw","dve","sdv","ssw","swm","inv"]} || \
	{GVAR(actionExitConditions) findIf {_unit call _x} != -1} || \
	{_unit getVariable [QGVAR(isAssisting),false]}

#define CLIMB_ON_PROCEDURE \
	_animPosASL = _climbAnimPosASL vectorAdd (_dir vectorMultiply 0.1); \
	_targetPosASL = (_targetPosASL vectorAdd [0,0,_height]) vectorAdd (_dir vectorMultiply 1.2); \
	_duty = _height * GVAR(climbOnDuty) * load _unit; \
	_actionAnim = switch true do { \
		case (_height >= 1.8) : {"BABE_climbOnHer"}; \
		case (_height >= 1.6) : {"BABE_climbOnH"}; \
		case (_height >= 0.8) : {"BABE_climbOn"}; \
		case (_height >= 0) : {"BABE_stepOn"}; \
		default {""}; \
	}

#define CLIMB_OVER_PROCEDURE \
	_animPosASL = _climbAnimPosASL vectorAdd (_dir vectorMultiply 0.05); \
	_targetPosASL = (_targetPosASL vectorAdd [0,0,_targetHeight]) vectorAdd (_dir vectorMultiply 1.9); \
	_duty = _height * GVAR(climbOverDuty) * load _unit; \
	_actionAnim = switch true do { \
		case (_height >= 2.2) : {"BABE_climbOverHer"}; \
		case (_height >= 1.4) : {"BABE_climbOverH"}; \
		case (_height >= 1.2) : {"BABE_climbOver"}; \
		case (_height >= 0.4) : {"BABE_vaultover"}; \
		default {""}; \
	}

#define DROP_PROCEDURE \
	_animPosASL = (_animPosASL vectorAdd [0,0,-2.1]) vectorAdd (_dir vectorMultiply 0.8); \
	_targetPosASL = (_targetPosASL vectorAdd [0,0,_depth]) vectorAdd (_dir vectorMultiply 1.3); \
	_duty = -_depth * GVAR(dropDuty) * load _unit; \
	_actionAnim = "BABE_drop"

#define ANIM_SPEED_COEF_END(UNIT) \
	if (!isNil "ace_advanced_fatigue_setAnimExclusions") then { \
		ace_advanced_fatigue_setAnimExclusions deleteAt (ace_advanced_fatigue_setAnimExclusions find QUOTE(ADDON)); \
	}; \
	[QGVAR(setAnimSpeedCoef),[UNIT,UNIT getVariable [QGVAR(animSpeedCoef),1]]] call CBA_fnc_globalEvent

#define IS_PLAYER(UNIT) (UNIT == call CBA_fnc_currentUnit)
#define KEY_CODE(VAR) if (!isNull findDisplay IDD_RSCDISPLAYCURATOR) exitWith {false}; call CBA_fnc_currentUnit call FUNC(VAR)

#ifdef DEBUG_MODE_FULL
	#define DEBUG_R(P1,P2) [{drawLine3D _this},{},[ASLToATL P1,ASLToATL P2,[1,0,0,1]],10] call CBA_fnc_waitUntilAndExecute;
	#define DEBUG_G(P1,P2) [{drawLine3D _this},{},[ASLToATL P1,ASLToATL P2,[0,1,0,1]],10] call CBA_fnc_waitUntilAndExecute;
	#define DEBUG_B(P1,P2) [{drawLine3D _this},{},[ASLToATL P1,ASLToATL P2,[0,0,1,1]],10] call CBA_fnc_waitUntilAndExecute;
#else
	#define DEBUG_R(P1,P2) 
	#define DEBUG_G(P1,P2) 
	#define DEBUG_B(P1,P2) 
#endif