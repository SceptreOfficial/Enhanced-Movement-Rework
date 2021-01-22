class CfgFunctions {
	delete BABE_CORE;
	delete BABE_EM;
	delete BABE_INT;
};

class CfgModSettings {
	delete babe_EM;
};

class EventHandlers;
class CfgVehicles {
	class AllVehicles;
	class Air: AllVehicles {
		class EventHandlers : EventHandlers {
			delete babe_int_initEH;
		};
	};
	class LandVehicle;
	class Car: LandVehicle {
		class EventHandlers : EventHandlers {
			delete babe_int_initEH;
		};
	};
	class Tank: LandVehicle {
		class EventHandlers : EventHandlers {
			delete babe_int_initEH;
		};
	};
};

delete BABE_core_List;
