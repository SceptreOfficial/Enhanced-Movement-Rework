class CfgUserActions {
	class GVAR(action) {
		displayName = CSTRING(Keybind_AIOAction);
		tooltip = CSTRING(keybindWarning);
		onActivate = QUOTE(call KEY_CODE(action));
		onDeactivate = "";
		onAnalog = "";
	};
	class GVAR(climb) {
		displayName = CSTRING(Keybind_ClimbDropOnly);
		tooltip = CSTRING(keybindWarning);
		onActivate = QUOTE(call KEY_CODE(climb));
		onDeactivate = "";
		onAnalog = "";
	};
	class GVAR(jump) {
		displayName = CSTRING(Keybind_JumpOnly);
		tooltip = CSTRING(keybindWarning);
		onActivate = QUOTE(call KEY_CODE(jump));
		onDeactivate = "";
		onAnalog = "";
	};
	class GVAR(assist) {
		displayName = CSTRING(Keybind_Assist);
		tooltip = CSTRING(keybindWarning);
		onActivate = QUOTE(call KEY_CODE(assist));
		onDeactivate = "";
		onAnalog = "";
	};
	class GVAR(holster) {
		displayName = CSTRING(Keybind_HolsterWeapon);
		tooltip = CSTRING(keybindWarning);
		onActivate = QUOTE(call KEY_CODE(holster));
		onDeactivate = "";
		onAnalog = "";
	};
	class GVAR(interact) {
		displayName = CSTRING(Keybind_Interact);
		tooltip = CSTRING(keybindWarning);
		onActivate = QUOTE(call KEY_CODE(interact));
		onDeactivate = "";
		onAnalog = "";
	};
};

class CfgDefaultKeysPresets {
	class Arma2 {
		class Mappings {
			GVAR(action)[] = {};
			GVAR(climb)[] = {};
			GVAR(jump)[] = {};
			GVAR(assist)[] = {};
			GVAR(holster)[] = {};
			GVAR(interact)[] = {};
		};
	};
};

class UserActionGroups {
	class GVAR(category) {
		name = CSTRING(EnhancedMovementRework);
		isAddon = 1;
		group[] = {
			GVAR(action),
			GVAR(climb),
			GVAR(jump),
			GVAR(assist),
			GVAR(holster),
			GVAR(interact)
		};
	};
};
