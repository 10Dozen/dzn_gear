#include "defines.h"
/*
    Converts cargo array to Cargo Map object.

    Params:
    _this (ARRAY) - cargo array

    Returns:
    _cargoKitObject
*/

DBG_1("Self: %1", _self);
DBG_1("Type Self: %1", typename _self);

// -- New format: ["< CATEGORY NAME  >> ", [...content...]]
if ((_this # 0) isEqualTypeParams ["", []]) then {
    {
        private _category = toUpperANSI ((_x # 0) trim ["<> ", 0]);
        DBG_1("Category: %1", _category);

        // -- Tags
        if (_category == ARR_CARGO_TAGS) then {
            _self set [MAP_CARGO_TAGS, _x select [1,25]];
            continue;
        };

        // -- Object textures
        if (_category == ARR_CARGO_TEXTURES) then {
            _self set [MAP_CARGO_TEXTURES, _x select [1, 20]];
            continue;
        };

        // -- Script
        if (_category == ARR_CARGO_SCRIPT) then {
            _self set [MAP_CARGO_SCRIPT, _x select [1,20]];
            continue;
        };

        // -- Description
        if (_category == ARR_CARGO_DESC) then {
            _self set [MAP_CARGO_DESC, _x select 1];
            continue;
        };

        // -- Items
        DBG_1("Item pool: %1", _x select 1);
        _self set [
            [
                [
                    [
                        MAP_CARGO_BACKPACKS,
                        MAP_CARGO_ITEMS
                    ] select (_category == ARR_CARGO_ITEMS),
                    MAP_CARGO_MAGAZINES
                ] select (_category == ARR_CARGO_MAGAZINES),
                MAP_CARGO_WEAPONS
            ] select (_category == ARR_CARGO_WEAPONS),
            _x # 1
        ];
    } forEach _this;

    DBG_1("From new format Created: %1", _self);
} else {
    // -- Old format [ [...content...], ... ]
    _this params ["_weapons", "_mags", "_items", "_backpacks", ["_weaponsExtended", []]];
    _self set [MAP_CARGO_WEAPONS, _weapons];
    _self set [MAP_CARGO_MAGAZINES, _mags];
    _self set [MAP_CARGO_ITEMS, _items];
    _self set [MAP_CARGO_BACKPACKS, _backpacks];
    (_self get MAP_CARGO_WEAPONS) append _weaponsExtended;

    DBG_1("From old format Created: %1", _self);
};
