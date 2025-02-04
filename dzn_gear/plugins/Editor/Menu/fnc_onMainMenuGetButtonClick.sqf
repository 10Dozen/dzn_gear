#include "defines.h"

params ["_prefix", "_vals"];

private _overrideAssignedItems = (_vals get "l_assignedItems") # 2;
private _overrideUniformItems = (_vals get "l_uniformItems") # 2;

// -- Save to select on next menu open
_self set [Q(MainMenu_AssignedItemsOverrideMode), _overrideAssignedItems];
_self set [Q(MainMenu_UniformItemsOverrideMode), _overrideUniformItems];

private _customName = _vals get "i_customName";
private _name = format ["%1%2", _prefix, _customName];

if (_customName == "") then {
    DBG_ "(OnGET) Name from dropdown. Key=%1, Role=%2", _vals get "i_kitKey", (_vals get "d_rolename") EOL;
    _self set [Q(MainMenu_KitRole), (_vals get "d_rolename") # 0];
    _self set [Q(MainMenu_KitKey), _vals get "i_kitKey"];
    _name = format [
        "%1%2_%3",
        _prefix,
        _vals get "i_kitKey",
        (_vals get "d_rolename") # 2
    ];
};

DBG_ "(OnGET) Name=%1", _name EOL;

ECOB(Editor,Core) call [F(CreateKit), [
    _name,
    cursorTarget,
    _overrideAssignedItems,
    _overrideUniformItems
]];