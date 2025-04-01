#include "defines.h"
/*
    Converts cargo array to Cargo Map object.

    Params:
    _this (ARRAY) - cargo array

    Returns:
    _cargoKitObject
*/

DBG_ "Self: %1", _self EOL;
DBG_ "Type Self: %1", typename _self EOL;

// -- New format: ["< CATEGORY NAME  >> ", [...content...]]
if ((_this # 0) isEqualTypeParams ["", []]) then {
    {
        private _category = toUpperANSI ((_x # 0) trim ["<> ", 0]);
        DBG_ "Category: %1", _category EOL;

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
        DBG_ "Item pool: %1", _x select 1 EOL;
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

    DBG_ "From new format Created: %1", _self EOL;
} else {
    // -- Old format [ [...content...], ... ]
    _this params ["_weapons", "_mags", "_items", "_backpacks", ["_weaponsExtended", []]];
    _self set [MAP_CARGO_WEAPONS, _weapons];
    _self set [MAP_CARGO_MAGAZINES, _mags];
    _self set [MAP_CARGO_ITEMS, _items];
    _self set [MAP_CARGO_BACKPACKS, _backpacks];
    (_self get MAP_CARGO_WEAPONS) append _weaponsExtended;

    DBG_ "From old format Created: %1", _self EOL;
};
