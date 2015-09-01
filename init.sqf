enableSaving [false,false];

// Add to init.sqf
// 0: true or false - Edit mode activation,
// 1: NUMBER - script call delay (where 0 - is mission start). If not passed - runs without delay (before mission start);
[true] execVM "dzn_gear\dzn_gear_init.sqf";

player addAction ["Arsenal", { ["Open", true] call BIS_fnc_arsenal; }];