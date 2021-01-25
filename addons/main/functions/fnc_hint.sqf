#include "script_component.hpp"
/*
	Author: Sceptre

	Description:
	Displays a hint

	Parameters:
	0: Text <STRING>
*/

params ["_text"];

switch GVAR(hintType) do {
	case 0 : {hint _text};
	case 1 : {hintSilent _text};
	case 2 : {
		QGVAR(hint) cutText [_text,"PLAIN",0.1];
		[{QGVAR(hint) cutFadeOut 1},[],1] call CBA_fnc_waitAndExecute;
	};
	case 3 : {systemChat _text};
};
