#include "defines.h"

params [
    "_nameAndRoleDesc",
    "_target",
    ["_overrideAssignedItems", NO_OVERRIDE],
    ["_overrideUniformItems", NO_OVERRIDE]
];


private _color = [
    "#", COLOR_POOL, COLOR_POOL, COLOR_POOL
    , COLOR_POOL, COLOR_POOL, COLOR_POOL
] joinString "";

if (isNull _target) exitWith {
    _self call [
        F(composeUnitKit),
        [
            "Player's", _nameAndRoleDesc, _color,
            player call dzn_fnc_gear_getGear,
            _overrideAssignedItems, _overrideUniformItems
        ]
    ];
};

if (_target isKindOf "CAManBase") exitWith {
    _self call [
        F(composeUnitKit),
        [
            "Unit's", _nameAndRoleDesc, _color,
            cursorTarget call dzn_fnc_gear_getGear,
            _overrideAssignedItems, _overrideUniformItems
        ]
    ];
};

_self call [
    F(composeCargoKit),
    ["Vehicle's", _nameAndRoleDesc, _color, cursorTarget call dzn_fnc_gear_getCargoGear]
];