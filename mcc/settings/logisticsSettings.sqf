//Limited logistics: ammo and fuel run out and supply trucks/bases matter. Off = no change from older MCC versions.
[
    "MCC_logisticsMode",
    "LIST",
    ["Limited Logistics","Off: unlimited supply trucks/crates as before.\nFuel only: fuel trucks, fuel crates and vehicle service fuel are finite.\nFull: fuel, ammo and repair are finite. Supply trucks refill at their side's base from the side resources."],
    ["MCC Logistics","Limited Logistics"],
    [[0,1,2],["Off","Fuel only","Full (fuel, ammo, repair)"],0],
    true
] call CBA_fnc_addSetting;

//Stock of a supply vehicle (resource units, same units as the side resources)
[
    "MCC_logisticsTruckCapacity",
    "SLIDER",
    ["Supply Truck Capacity","Resource units an ammo/repair/fuel vehicle carries of each supply type (MCC crates: 200, big crates: 800)"],
    ["MCC Logistics","Limited Logistics"],
    [100, 5000, 1000, 0],
    true
] call CBA_fnc_addSetting;

//How fast a supply vehicle refills at base
[
    "MCC_logisticsRefillRate",
    "SLIDER",
    ["Base Refill Rate","Resource units a supply vehicle takes from the side resources every 5 seconds while parked at its base"],
    ["MCC Logistics","Limited Logistics"],
    [10, 1000, 100, 0],
    true
] call CBA_fnc_addSetting;

//Base radius
[
    "MCC_logisticsBaseRadius",
    "SLIDER",
    ["Base Radius","Distance in meters from the side start location (or an RTS base building) where supply vehicles refill"],
    ["MCC Logistics","Limited Logistics"],
    [25, 500, 75, 0],
    true
] call CBA_fnc_addSetting;

//Price of supplies
[
    "MCC_logisticsCostFactor",
    "SLIDER",
    ["Supply Cost Factor","Multiplies the resource cost of rearming, repairing and refuelling a vehicle (from supply points and from vehicle service)"],
    ["MCC Logistics","Limited Logistics"],
    [0.1, 5, 1, 1],
    true
] call CBA_fnc_addSetting;

//Fuel consumption
[
    "MCC_logisticsFuelConsumption",
    "SLIDER",
    ["Fuel Consumption","Vehicle fuel consumption multiplier while Limited Logistics is on (1 = normal)"],
    ["MCC Logistics","Limited Logistics"],
    [1, 10, 1, 1],
    true
] call CBA_fnc_addSetting;
