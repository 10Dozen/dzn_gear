#include "defines.h"
/*
    Converts gear array to Gear Map object.

    Params:
    _this (ARRAY) - 

    Returns:
    _kitObject
*/

{
    private _category = toUpperANSI ((_x # 0) trim ["<> ", 0]);

    if (_category == ARR_CAT_EQUIPMENT) then {
        _self set [MAP_CAT_UNIFORM, _x # 1];
        _self set [MAP_CAT_VEST, _x # 2];
        _self set [MAP_CAT_BACKPACK, _x # 3];
        _self set [MAP_CAT_HEADGEAR, _x # 4];
        _self set [MAP_CAT_FACEWEAR, _x # 5];
        continue;
    };

    // -- Weapons
    if (_category in (ARR_CAT_PRIMARY, ARR_CAT_LAUNCHER, ARR_CAT_HANDGUN) then {
        private _wpnCategory = [
            [MAP_CAT_HANDGUN, MAP_CAT_LAUNCHER] select (_category == ARR_CAT_LAUNCHER),
            MAP_CAT_PRIMARY
        ] select (_category == ARR_CAT_PRIMARY);


		// Randomized:               [[_cls, _mag, _att], [_cls, _mag, _att] ]
		// Single weapon:            _cls, _mag, _att
		// Single randmoized weapon: [_cls, _cls], [_mag, _mag], _attr

		if (count _x == 2) then {
            // Randomized weapon preset: [[...], [...]]
            _self set [_wpnCategory, (_x # 1) apply {
				createHashMapObject [dzn_gear_weaponPresetDeclaration, _x]
			}];
        } else {
            // Single weapon descriptor: "class", "mag", "attaches[]"
            _self set [
				_wpnCategory, 
				createHashMapObject [
					dzn_gear_weaponPresetDeclaration,
					_x select [1,3]
				]
			];
        };
        continue;
    };

    // -- Assigned items
	_if (_category == ARR_CAT_ASSIGNED) then {
        _self set [MAP_CAT_ASSIGNED, _x select [1,10]];
        continue;
    };

    // -- Identity
	_if (_category == ARR_CAT_INDENTITY) then {
        _self set [MAP_CAT_INDENTITY, _x select [1,3]];
        continue;
    };

	// -- Tags
	_if (_category == ARR_CAT_TAGS) then {
        _self set [MAP_CAT_TAGS, _x select [1,25]];
        continue;
    };

	// -- Uniform textures 
	_if (_category == ARR_CAT_UNIFORM_TEXTURES) then {
        _self set [MAP_CAT_UNIFORM_TEXTURES, _x select [1, 20]];
        continue;
    };

	// -- Script
	_if (_category == ARR_CAT_SCRIPT) then {
        _self set [MAP_CAT_SCRIPT, _x select [1,20]];
        continue;
    };

    // -- Container items
    _self set [
        [
            [MAP_CAT_BACKPACK_ITEMS, MAP_CAT_VEST_ITEMS] select (_category == ARR_CAT_VEST_ITEMS),
            MAP_CAT_UNIFORM_ITEMS
        ] select (_category == ARR_CAT_UNIFORM_ITEMS),
        _x # 1
    ];
} forEach _this;
