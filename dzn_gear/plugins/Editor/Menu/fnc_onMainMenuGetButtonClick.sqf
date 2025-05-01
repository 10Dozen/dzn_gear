#include "defines.h"

DBG_1("Params: %1", _this);
params ["_prefix", "_vals", ["_isUnit", true]];

if (!_isUnit) exitWith {
    DBG("Is vehicle");
    ECOB(Editor,Core) call [F(CreateKit), [
        format ["%1%2", _prefix, _vals get "i_customName"],
        cursorTarget
    ]];
};

private _overrideAssignedItems = (_vals get "l_assignedItems") # 2;
private _overrideUniformItems = (_vals get "l_uniformItems") # 2;

// -- Save to select on next menu open
//_self set [Q(MainMenu_AssignedItemsOverrideMode), _overrideAssignedItems];
//_self set [Q(MainMenu_UniformItemsOverrideMode), _overrideUniformItems];

private _customName = _vals get "i_customName";
private _name = format ["%1%2", _prefix, _customName];
private _roleDesc = [];
if (_customName == "") then {
    DBG_2("(OnGET) Name from dropdown. Key=%1, Role=%2", _vals get "i_kitKey", (_vals get "d_rolename"));
    _self set [Q(MainMenu_KitRole), (_vals get "d_rolename") # 0];
    _self set [Q(MainMenu_KitKey), _vals get "i_kitKey"];
    private _selectedRoleIdx = (_vals get "d_rolename") # 0;
    _roleDesc = (_self get Q(Roles)) # _selectedRoleIdx;
    _name = format [
        "%1%2_%3",
        _prefix,
        _vals get "i_kitKey",
        (_vals get "d_rolename") # 2
    ];
};

DBG_1("(OnGET) Name=%1", _name);

ECOB(Editor,Core) call [F(CreateKit), [
    [_name, _roleDesc],
    cursorTarget,
    _overrideAssignedItems,
    _overrideUniformItems
]];
