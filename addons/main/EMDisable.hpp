class CfgFunctions {
	delete BABE_CORE;
	delete BABE_EM;
	delete BABE_INT;
};

class CfgModSettings {
	delete babe_EM;
};

class CfgVehicles {
	class AllVehicles;
	class Air: AllVehicles {
		class EventHandlers {
			delete babe_int_initEH;
		};
	};
	class LandVehicle;
	class Car: LandVehicle {
		class EventHandlers {
			delete babe_int_initEH;
		};
	};
	class Tank: LandVehicle {
		class EventHandlers {
			delete babe_int_initEH;
		};
	};

	delete babe_helper;
};

delete BABE_core_List;
