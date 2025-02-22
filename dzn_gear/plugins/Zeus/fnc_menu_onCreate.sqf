#include "defines.h"

DBG_ "Params: %1", _this EOL;

params ["_ad"];

(_self get Q(MenuFilters)) params ["_applyToUnits", "_applyToCrew", "_applyToObjects"];
(_self get Q(ZeusLastSelected)) params ["_units", "_crew", "_objects"];

private _allUnits = [] + ([[], _units] select _applyToUnits) + ([[], _crew] select _applyToCrew);
_objects = [[], _objects] select _applyToObjects;

if (_allUnits isEqualTo [] && _objects isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

private _kitname = _self call [F(saveGear), [_allUnits, _objects]];
if (isNil "_kitname") exitWith {};

private _isPersonal = (_kitname select [0,4] == "kit_");
[
    ["DIALOG", [["y", 0.45]]],
    ["HEADER", "Set custom name for generated kit"],
    ["LABEL", "<t align='center'>Only latin, numbers or underscore (_)</t>", [["h", 0.035], ["size", 0.035]]],
    ["BR"],

    ["LABEL", format [
        "<t align='right'>%1</t>",
        ["cargo_kit_", "kit_"] select _isPersonal
    ],[["size", 0.05]]],
    ["INPUT", [
        _kitname select [10, 50],
        _kitname select [4, 50]
    ] select _isPersonal, [["tag", "inp_kitname"], ["w", 0.75], ["size", 0.05]]],
    ["LABEL", "", [["w",0.05]]],
    ["BR"],

    ["LABEL", "", [["h", 0.03], ["size", 0.03]]],
    ["BR"],

    ["BUTTON", "<t align='center'>Create</t>", {
        params ["_ad", "_args"];
        _args params ["_kitname", "_isPersonal"];

        private _name = trim (_ad call ["GetValueByTag", "inp_kitname"]);
        if (_name == "") exitWith {};
        if !(_name regexMatch "[A-Za-z0-9_]*") exitWith {
            private _ctrl = _ad call ["GetByTag", "inp_kitname"];
            _ctrl ctrlSetBackgroundColor COLOR_BRICK_RED;
            [
                { (_this # 0) ctrlSetBackgroundColor (_this # 1); },
                [_ctrl, [0.92, 0.31, 0.20, 0.6]],
                0.1
            ] call CBA_fnc_waitAndExecute;
            [
                { (_this # 0) ctrlSetBackgroundColor (_this # 1); },
                [_ctrl, [0.92, 0.31, 0.20, 0.3]],
                0.2
            ] call CBA_fnc_waitAndExecute;
            [
                { (_this # 0) ctrlSetBackgroundColor (_this # 1); },
                [_ctrl, [0,0,0,1]],
                0.3
            ] call CBA_fnc_waitAndExecute;
        };

        _name = (["cargo_kit_", "kit_"] select _isPersonal) + _name;
        if (_name != _kitname) then {
            missionNamespace setVariable [_name, missionNamespace getVariable _kitname, true];
            missionNamespace setVariable [_kitname, nil, true];
            private _tgt = [dzn_gear_cargoKits, dzn_gear_personalKits] select _isPersonal;
            _tgt deleteAt (_tgt find _kitname);
            _tgt pushBackUnique _name;
        };

        ThisCOB call [F(openMenu), [_name]];
    }, [_kitname, _isPersonal], [
        ["w", 0.25],
        ["x", 0.75],
        ["size", 0.05],
        ["bg", COLOR_PALE_GREEN]
    ]]
] call dzn_fnc_ShowAdvDialog2;
