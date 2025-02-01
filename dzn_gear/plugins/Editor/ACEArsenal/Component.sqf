#include "defines.h"
//dzn_gear_ArsenalComponent = createHashMapObject [[

private _declaration = [
    [Q(OpenedEH), -1],
	[Q(ClosedEH), -1],

	[Q(SkipSelChangeEvent), true],

    [Q(Display), displayNull],
    [Q(CurrentItemPoolId), -1],
	[Q(CurrentItemSelected), ""],
	[Q(ItemPools), createHashMap],
	[Q(Categories), createHashMapFromArray [
		[2002, ["Primary weapon", { CFG_WEAPON_PATH }]],
        [2004, ["Handgun",        { CFG_WEAPON_PATH }]],
        [2006, ["Launcher",       { CFG_WEAPON_PATH }]],
        [2008, ["Headgear",       { CFG_WEAPON_PATH }]],
        [2010, ["Uniform",        { CFG_WEAPON_PATH }]],
        [2012, ["Vest",           { CFG_WEAPON_PATH }]],
        [2014, ["Backpack",       { CFG_VEHICLES_PATH }]],
        [2016, ["Facewear",       { CFG_GLASSES_PATH }]],
        [2018, ["NVG",            { CFG_WEAPON_PATH }]],
        [2020, ["Binoculars",     { CFG_WEAPON_PATH }]],
        [2022, ["Maps",           { CFG_WEAPON_PATH }]],
        [2024, ["Terminal",       { CFG_WEAPON_PATH }]],
        [2026, ["Radio",          { CFG_WEAPON_PATH }]],
        [2029, ["Navigation",     { CFG_WEAPON_PATH }]],
        [2031, ["Watch",          { CFG_WEAPON_PATH }]],
        [2033, ["Face",           { configFile >>"CfgFaces" >> _this }]],  // ??? what config ???
        [2035, ["Voice",          { configFile >>"CfgVoices" >> _this }]], // ??? what config ???

		[22,   ["Attach: Scope",  { CFG_WEAPON_PATH }]],
		[24,   ["Attach: Pointer",{ CFG_WEAPON_PATH }]],
		[26,   ["Attach: Muzzle", { CFG_WEAPON_PATH }]],
		[28,   ["Attach: Bipod",  { CFG_WEAPON_PATH }]],

		[3002, ["Magazine",       { CFG_MAGAZINE_PATH }]],
		[3004, ["Alt.Magazine",   { CFG_MAGAZINE_PATH }]]
	]],

    PREP_COMPONENT_FUNCTION(Open),

    PREP_COMPONENT_FUNCTION(initEvents),
    PREP_COMPONENT_FUNCTION(onArsenalOpened),

    PREP_COMPONENT_FUNCTION(onShowButtonClick),
    PREP_COMPONENT_FUNCTION(onAddButtonClick),
    PREP_COMPONENT_FUNCTION(onResetButtonClick),
    PREP_COMPONENT_FUNCTION(onExportButtonClick),

    PREP_COMPONENT_FUNCTION(addItemToPool),
    PREP_COMPONENT_FUNCTION(removeItemFromPool)
];

private _cob = createHashMapObject [_declaration];

_cob
