#include "defines.h"

DBG_1("Params: %1", _this);
params [["_kitname", ""]];

_self set [Q(MenuFilters), [true, true, true]];

private _preselectedKitIdx = -1;
private _kits = [];
{
    _kits pushBack [_x, _x, [
        ["tooltip", str(missionNamespace getVariable _x)],
        ["color", [COLOR_WHITE, COLOR_LIME] select (_x select [0,4] == 'kit_')]
    ]];
    if (_x == _kitname) then { _preselectedKitIdx = _forEachIndex; };
} forEach (dzn_gear_personalKits + dzn_gear_cargoKits);

private _items = _self get Q(FastItems);

// -- Menu
[
    ["DIALOG", [["y", 0.5], ["dialog", _self get Q(ZeusDisplay)]]],
    ["OnCBAEvent", "dzn_gear_zeusSelectionChanged", { ThisCOB call [F(menu_onSelectionUpdate), _thisArgs]; }],
    ["OnDraw", {
        params ["_ad", "_args"];
        private _cob = ThisCOB;

        // -- Pre-select not empty filters
        ((_cob call [F(getSelected), []]) apply { _x isNotEqualTo [] }) params [
            "_hasUnits", "_hasCrew", "_hasVics"
        ];
        DBG_3("OnDraw: HasUnits=%1, HasCrew=%2, HasVics=%3", _hasUnits, _hasCrew, _hasVics);
        _cob call [F(menu_updateFiltersState), [_ad, [_hasUnits, _hasCrew, _hasVics]]];
        _cob call [F(menu_onSelectionUpdate), [_ad]];
        _cob call [F(menu_updateMenu), [_ad]];
    }],

    ["HEADER", "dzn Gear - Zeus Tool"],

    ["BUTTON", "UNITS", {
        ThisCOB call [F(menu_onFilterSelect), _this];
    }, 0, [["tag", BTN_UNITS], ["h", 0.07]]],

    ["BUTTON", "CREW", {
        ThisCOB call [F(menu_onFilterSelect), _this];
    }, 1, [["tag", BTN_CREW], ["h", 0.07]]],

    ["BUTTON", "VEHICLES", {
        ThisCOB call [F(menu_onFilterSelect), _this];
    }, 2, [["tag", BTN_VICS], ["h", 0.07]]],
    ["BR"],

    ["LABEL", "<t align='center'>Apply preset kits or create new</t>"],
    ["BR"],
    ["DROPDOWN", _kits, _preselectedKitIdx, [["tag", DP_KITNAME]]],
    ["INPUT", "", [
        ["tag", INP_KITNAME],
        ["tooltip", "Enter name of the kit if can't find one"]
    ]],
    ["BUTTON", "Apply", {
        ThisCOB call [F(menu_onApplyKit), _this];
    }, [], [
        ["tag", BTN_APPLY_KIT],
        ["bg", COLOR_PALE_GREEN],
        ["tooltip", "Apply selected kit to units/vehicles"],
        ["w", 0.25]
    ]],
    ["BR"],
    ["LABEL", "", [["h", 0.0075], ["size",0.0075]]],
    ["BR"],

    ["BUTTON", "Copy gear", {
        ThisCOB call [F(menu_onCopy), _this];
    }, [], [
        ["tag", BTN_COPY],
        ["tooltip", "Copy gear of the first unit or vehicle"]
    ]],
    ["BUTTON", "Apply copied gear", {
        ThisCOB call [F(menu_onApply), _this];
    }, [], [
        ["tag", BTN_APPLY],
        ["tooltip", "Apply last copied gear to selected units/vehicles"]
    ]],
    ["BUTTON", "Save to kit", {
        ThisCOB call [F(menu_onCreate), _this];
    }, [], [
        ["tag", BTN_CREATE],
        ["tooltip", "Create kit from the gear of the first unit/vehicle (unit first)"]
    ]],
    ["BR"],

    ["LABEL", "<t align='center'>Modify inventory</t>", [["bg", COLOR_UI]]],
    ["BR"],

    ["DROPDOWN", _items, nil, [["tag", DP_ITEM], ["enabled", _hasUnits || _hasCrew], ["w", 0.75]]],
    ["BUTTON", format ["<t align='center' color='%1'>+</t>", COLOR_HEX_LIME], {
        ThisCOB call [F(menu_onAddItem), _this];
    }, [], [
        ["tag", BTN_ADD_ITEM],
        ["tooltip", "Add selected item"]
    ]],
    ["BUTTON", format ["<t align='center' color='%1'>-</t>", COLOR_HEX_BRICK_RED], {
        ThisCOB call [F(menu_onRemoveItem), _this];
    }, [], [
        ["tag", BTN_REMOVE_ITEM],
        ["tooltip", "Remove selected item"]
    ]],
    ["BR"],

    ["LABEL"],
    ["BR"],

    ["BUTTON", "Arsenal", {
        ThisCOB call [F(menu_onArsenal), _this];
    }, [], [["tag", BTN_ARSENAL]]],

    ["LABEL", "", [["w", 0.17]]],

    ["BUTTON", "<t align='right'>Clear All Items</t>", {
        ThisCOB call [F(menu_onClear), [_this # 0]];
    }, [], [
        ["tag", BTN_CLEAR],
        ["tooltip", "Clears unit/vehicle containers (uniform, vest, cargo)"],
        ["w", 0.25]
    ]],

    ["BUTTON", ".. and Weapons", {
        ThisCOB call [F(menu_onClear), [_this # 0, true]];
    }, [], [
        ["tag", BTN_CLEAR],
        ["tooltip", "Clears unit/vehicle containers (uniform, vest, cargo) including unit's weapons!"],
        ["w", 0.25]
    ]]
] call dzn_fnc_ShowAdvDialog2;
