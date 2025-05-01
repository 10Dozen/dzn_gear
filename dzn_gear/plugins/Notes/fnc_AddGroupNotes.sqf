#include "defines.h"

DBG_1("Params: %1", _this);
params [
    ["_units", units group player]
];

private _content = [
    format ["<font size='16' color='%2'>%1</font>", groupId group player, COLOR_HEX_GOLD],
    ""
];

private _notes = _self get Q(SharedNotes);
_notes resize 0;

private ["_role", "_name", "_note", "_noteIdx"];
{
    _role =  ((roleDescription _x) splitString "@") # 0;;
    _name = name _x;
    _note = _x getVariable [Q(dzn_gear_Note), []];
    _noteIdx = _notes pushBack [_name, _role, _note];

    _previewLine = "";
    _seeMoreLine = "";
    DBG_2("_note type = %1, _note = %2", typename _note, _note);
    if (_note isNotEqualTo []) then {
        _previewLine = [];
        for "_i" from 0 to 2 do {
            DBG_2("Note %1 = %2", _i, (_note # _i));
            if ((_note # _i) isEqualTo []) then { continue; };
            _previewLine pushBack ((_note # _i # 0) call dzn_fnc_getItemDisplayName);
        };

        DBG_1("_previewLine = %1", _previewLine);

        _previewLine = " (" + (_previewLine joinString " | ") + ")";
        _seeMoreLine = format [
            " <execute expression='%1 call [""fnc_showMemberNote"", [%2]]'>[...]</execute>",
            Q(ThisCOB),
            _noteIdx
        ];

        DBG_2("Preview: %1, See more: %2", _previewLine, _seeMoreLine);
    };

    _content pushBack format [
        "<font color='%5'>%1</font> - %2 <font color='#cccccc'>%3</font> %4",
        _name,
        _role,
        _previewLine,
        _seeMoreLine,
        COLOR_HEX_LIGHT_GREEN
    ];
} forEach _units;

// -- Refresh diary record

_self set [Q(MemberInfoShown), false];
player removeDiaryRecord ["Diary", _self get Q(GroupInfoRecord)];
_self set [
    Q(GroupInfoRecord),
    player createDiaryRecord [
        "Diary",
        [TOPIC_GROUP_GEAR, _content joinString "<br/>"]
    ]
];
