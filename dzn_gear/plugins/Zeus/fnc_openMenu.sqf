#include "defines.h"

DBG_ "Params: %1", _this EOL;
params [
    ["_units", []],
    ["_objects", []]
];

private _crew = [];
{ _crew append (crew _x); } forEach _objects;

private _hasUnits = _units isNotEqualTo [];
private _hasCrew = _crew isNotEqualTo [];
private _hasVehicles = _objects isNotEqualTo [];
if (!_hasUnits && !_hasVehicles) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

private _kits = (dzn_gear_personalKits + dzn_gear_cargoKits) apply {
    [_x, _x, [
        ["tooltip", str(missionNamespace getVariable _x)],
        ["color", [COLOR_WHITE, COLOR_LIME] select (_x select [0,4] == 'kit_')]
    ]]
};
private _items = _self get Q(FastItems);

private _menu = [
    ["OnDraw", {
        params ["_ad", "_args"];
        (_ad call ["GetByTag", "btn_units"]) setVariable [Q(Selected), _args # 0];
        (_ad call ["GetByTag", "btn_crew"])  setVariable [Q(Selected), _args # 1];
        (_ad call ["GetByTag", "btn_objects"])  setVariable [Q(Selected), _args # 2];

    }, [_hasUnits, _hasCrew, _hasVehicles]],
    ["HEADER", "dzn Gear - Zeus Tool"],

    ["BUTTON", format ["<t align='center' size='1.5'>%1 units</t>", count _units], {
        params ["_ad", "", "_ctrl"];
        private _state = !(_ctrl getVariable [Q(Selected), true]);
        _ctrl setVariable [Q(Selected), _state];
        _ctrl ctrlSetBackgroundColor ([COLOR_BLACK, COLOR_PALE_GREEN] select _state);

        // -- Toggle unit-only controls
        _state = _state || (_ad call ["GetByTag", "btn_crew"]) getVariable Q(Selected);
        { (_ad call ["GetByTag", _x]) ctrlEnable _state; } forEach ["d_item", "btn_addItem", "btn_removeItem", "btn_arsenal"];

    }, [], [["tag", "btn_units"], ["h", 0.07], ["bg", [COLOR_BLACK, COLOR_PALE_GREEN] select _hasUnits]]],

    ["BUTTON", format ["<t align='center' size='1.5'>%1 crew</t>", count _crew], {
        params ["_ad", "", "_ctrl"];
        private _state = !(_ctrl getVariable [Q(Selected), true]);
        _ctrl setVariable [Q(Selected), _state];
        _ctrl ctrlSetBackgroundColor ([COLOR_BLACK, COLOR_PALE_GREEN] select _state);

        // -- Toggle unit-only controls
        _state = _state || (_ad call ["GetByTag", "btn_units"]) getVariable Q(Selected);
        { (_ad call ["GetByTag", _x]) ctrlEnable _state; } forEach ["d_item", "btn_addItem", "btn_removeItem", "btn_arsenal"];

    }, [], [["tag", "btn_crew"], ["h", 0.07], ["bg", [COLOR_BLACK, COLOR_PALE_GREEN] select _hasCrew]]],

    ["BUTTON", format ["<t align='center' size='1.5'>%1 vehicles</t>", count _objects], {
        params ["", "", "_ctrl"];
        _ctrl setVariable [Q(Selected), !(_ctrl getVariable [Q(Selected), true])];
        _ctrl ctrlSetBackgroundColor ([COLOR_BLACK, COLOR_PALE_GREEN] select (_ctrl getVariable Q(Selected)));
    }, [], [["tag", "btn_objects"], ["h", 0.07], ["bg", [COLOR_BLACK, COLOR_PALE_GREEN] select _hasVehicles]]],
    ["BR"],

    ["LABEL", "<t align='center'>Apply preset kits or create new</t>"],
    ["BR"],
    ["DROPDOWN", _crew, 0, [["tag", "d_kitname"]]],
    ["INPUT", "", [
        ["tag", "i_kitname"],
        ["tooltip", "Enter name of the kit if can't find one"]
    ]],
    ["BUTTON", "Apply", {
        ThisCOB call [F(menu_onApplyKit), _this];
        (_this # 0) call ["Close",[]];
    }, [_units, _crew, _objects], [
        ["bg", COLOR_PALE_GREEN],
        ["tooltip", "Apply selected kit to units/vehicles"],
        ["w", 0.25]
    ]],
    ["BR"],
    ["LABEL", "", [["h", 0.0075], ["size",0.0075]]],
    ["BR"],

    ["BUTTON", "Copy gear", {
        ThisCOB call [F(menu_onCopy), _this];
    }, [_units, _crew, _objects], [
        ["tooltip", "Copy gear of the first unit or vehicle"]
    ]],
    ["BUTTON", "Apply copied gear", {
        ThisCOB call [F(menu_onApply), _this];
    }, [_units, _crew, _objects], [
        ["tooltip", "Apply last copied gear to selected units/vehicles"]
    ]],
    ["BUTTON", "Save to kit", {
        ThisCOB call [F(menu_onCreate), _this];
    }, [_units, _crew, _objects], [
        ["tooltip", "Create kit from the gear of the first unit/vehicle (unit first)"]
    ]],
    ["BR"],

    ["LABEL", "Modify inventory", [["bg", COLOR_UI]]],
    ["BR"],

    ["DROPDOWN", _items, nil, [["tag", "d_item"], ["enabled", _hasUnits], ["w", 0.75]]],
    ["BUTTON", "<t align='center'>+</t>", {
        ThisCOB call [F(menu_onAddItem), _this];
    }, [_units, _crew], [
        ["tag", "btn_addItem"],
        ["tooltip", "Add selected item"],
        ["enabled", _hasUnits]
    ]],
    ["BUTTON", "<t align='center'>-</t>", {
        ThisCOB call [F(menu_onRemoveItem), _this];
    }, [_units, _crew], [
        ["tag", "btn_removeItem"],
        ["tooltip", "Remove selected item"],
        ["enabled", _hasUnits]
    ]],
    ["BR"],

    ["LABEL"],
    ["BR"],

    ["BUTTON", "Arsenal", {
        ThisCOB call [F(menu_onArsenal), _this];
    }, [_units, _crew], [["tag", "btn_arsenal"], ["enabled", _hasUnits]]],
    ["LABEL", ""],

    ["BUTTON", "Clear All Items", {
        ThisCOB call [F(menu_onClear), _this];
    }, [_units, _crew, _objects], [["tooltip", "Clears unit/vehicle containers (uniform, vest, cargo)"]]]

];

_menu call dzn_fnc_ShowAdvDialog2;
