#include "defines.h"
#define DBG_FUNC_PREFIX "fnc_showMainMenu"

params ["_menuNavbar"];

private _options = [
    ["None", NO_OVERRIDE, [["tooltip", "No overrides"]]],
    ["Standard", OVERRIDE_STANDARD, [["tooltip", "Overrides with standard items (defined in Settings file)"]]],
    ["Squad Leader", OVERRIDE_LEADER, [["tooltip", "Overrides with leader items (defined in Settings file)"]]]
];
private _assignedItemsCurSel = _options # 1; // findIf {_self get Q(MainMenu_AssignedItemsOverrideMode) == _x # 1};
private _uniformItemsCurSel = _options # 1; // findIf {_self get Q(MainMenu_UniformItemsOverrideMode) == _x # 1};

// Current target
private _targetIsUnit = true;
private _targetName = "(player)";
private _kitPrefix = "kit_";
if (!isNull cursorTarget) then {
    _targetIsUnit = cursorTarget isKindOf "CAManBase";
    _targetName = format [
        "%1 (%2)",
        cursorTarget,
        getText(configFile >> "CfgVehicles" >> typeOf cursorTarget >> "displayName")
    ];

    _kitPrefix = ["cargo_kit_", "kit_"] select _targetIsUnit;
};


private _menu = +_menuNavbar;
// -- Cargo gear
if (!_targetIsUnit) exitWith {
    _menu append [
        ["LABEL", "<t size='0.9'>On pressing ""GET"" button - formatted cargo kit will be copied to the clipboard"],
        ["BR"],
        ["LABEL", format [
            "<t align='center'><t color='%2'>Target:</t> %1</t>", _targetName, COLOR_HEX_LIME
        ]],
        ["BR"],

        ["LABEL", format ["Set custom name: <t align='right'>%1</t>", _kitPrefix]],
        ["INPUT", [typeOf cursorTarget, ""] select _targetIsUnit, [["tag", "i_customName"]]],
        ["LABEL", "<t size='0.8' color='#ff3333'>No special symbols/spaces!</t>"],
        ["BR"],

        ["LABEL"],["BR"],

        ["LABEL", ""],
        ["BUTTON", "<t align='center'>GET</t>", {
            params ["_ad", "_prefix"];
            ThisCOB call [F(onMainMenuGetButtonClick), [_prefix, _ad call ["GetTaggedValues"], false]];
            _ad call ["Close"];
        }, _kitPrefix, [["w",0.25], ["bg", COLOR_PALE_GREEN]]]
    ];

    _menu call dzn_fnc_ShowAdvDialog2;
};


// -- Unit gear
// -- Higlight kits that already exists with current key + role
private _kitKey = _self get Q(MainMenu_KitKey);
private _kitRolesLastSelectedId = _self get Q(MainMenu_KitRole);
private _kitRoles = _self get Q(Roles);

private _roles = _kitRoles apply {
    _x params ["_title", "_suffix", ["_tags", []]];
    [_title, _suffix, [
        [
            "color", [
                COLOR_WHITE, COLOR_DARK_GREEN
            ] select (!isNil format ["%1%2_%3", _kitPrefix, _kitKey, _suffix])
        ],
        ["tooltip", format [
            "Suffix: %1%2",
            _suffix,
            ["\nTags: " + str(_tags), ""] select (_tags isEqualTo [])
        ]]
    ]]
};

private _onRoleSelection = {
    params ["_eventData", "_dialogCOB", "_kitRoles"];
    // -- Check if current selected role has "leader" tag
    (_dialogCOB call ["GetValueByTag", "d_rolename"]) params ["_curIdx"];
    (_kitRoles # _curIdx) params ["", "", ["_tags", []]];
    // -- Update Asg/Uni Items selection to "leader"
    private _ctrls = [
        _dialogCOB call ["GetByTag", "l_assignedItems"],
        _dialogCOB call ["GetByTag", "l_uniformItems"]
    ];
    private _selectIndex = [1, 2] select (TAG_LEADER in _tags);
    {
        _x lbSetCurSel _selectIndex;
        _x lbSetColor [_selectIndex, COLOR_AQUA];
    } forEach _ctrls;
    [{
        {  _x lbSetColor [1, COLOR_WHITE]; _x lbSetColor [2, COLOR_WHITE];} forEach _this;
    }, _ctrls, 0.5] call CBA_fnc_waitAndExecute;
};
_menu append [
    ["OnDraw", {
        params ["_ad", "_args"];
        _args params ["_callback", "_kitRoles"];
        ["", _ad, _kitRoles] call _callback;
    }, [_onRoleSelection, _kitRoles]],
    [
        "LABEL",
        "<t size='0.9'>Kit name should be in format: kit_usmc_ar, where ""usmc"" is a key to faction and ""ar"" is a role."
    ],
    ["BR"],

    ["LABEL", "<t size='0.9'>On pressing ""GET"" button - formatted kit will be copied to the clipboard"],
    ["BR"],
    ["LABEL", format [
        "<t align='center'><t color='%2'>Target:</t> %1</t>", _targetName, COLOR_HEX_LIME
    ]],
    ["BR"],

    ["LABEL"],
    ["LABEL", "Key", [["enabled", _targetIsUnit], ["show", _targetIsUnit]]],
    ["LABEL", "Role", [["enabled", _targetIsUnit], ["show", _targetIsUnit]]],
    ["BR"],

    ["LABEL", format ["Set kit by role: <t align='right'>%1</t>", _kitPrefix], [["enabled", _targetIsUnit], ["show", _targetIsUnit]]],
    ["INPUT", _kitKey, [["tag", "i_kitKey"], ["enabled", _targetIsUnit], ["show", _targetIsUnit]], [
        ["EditChanged", {
            params ["_eventData", "_dialogCOB", "_args"];
            _args params ["_kitPrefix", "_kitRoles"];
            private _ctrl = _dialogCOB call ["GetByTag", "d_rolename"];
            {
                DBG_ "%1 :: %2 = %3", _x # 1, format ["kit_%1_%2", _eventData # 1, _x # 1], !isNil format ["kit_%1_%2", _eventData # 1, _x # 1] EOL;
                _ctrl lbSetColor [
                    _forEachIndex,
                    [
                        COLOR_WHITE, COLOR_DARK_GREEN
                    ] select (!isNil format ["%1%2_%3", _kitPrefix, _eventData # 1, _x # 1])
                ];
            } forEach _kitRoles;
        }, [_kitPrefix, _kitRoles]]
    ]],
    ["DROPDOWN", _roles, _kitRolesLastSelectedId, [["tag", "d_rolename"], ["enabled", _targetIsUnit], ["show", _targetIsUnit]], [
        ["KillFocus", _onRoleSelection, _kitRoles]
    ]],
    ["BR"],

    ["LABEL", "or", [["enabled", _targetIsUnit], ["show", _targetIsUnit]]],
    ["BR"],

    ["LABEL", format ["Set custom name: <t align='right'>%1</t>", _kitPrefix]],
    ["INPUT", [typeOf cursorTarget, ""] select _targetIsUnit, [["tag", "i_customName"]]],
    ["LABEL", "<t size='0.8' color='#ff3333'>No special symbols/spaces!</t>"],
    ["BR"],

    ["LABEL"],["BR"],

    [
        "LABEL",
        "<t size='0.9'>Option to override ASSIGNED_ITEMS and UNIFORM_ITEMS by presets defined in Settings</t>",
        [["bg", COLOR_STEEL_BLUE]]
    ],
    ["BR"],

    ["LABEL", "Assigned items"],
    ["LISTBOX", _options, _assignedItemsCurSel, [["tag", "l_assignedItems"]]],
    ["BR"],

    ["LABEL", "Uniform items"],
    ["LISTBOX", _options, _uniformItemsCurSel, [["tag", "l_uniformItems"]]],
    ["BR"],

    ["LABEL", ""],
    ["BUTTON", "<t align='center'>GET</t>", {
        params ["_ad", "_prefix"];
        ThisCOB call [F(onMainMenuGetButtonClick), [_prefix, _ad call ["GetTaggedValues"]]];
        _ad call ["Close"];
    }, _kitPrefix, [["w",0.25], ["bg", COLOR_PALE_GREEN]]]
];


_menu call dzn_fnc_ShowAdvDialog2;