#include "defines.h"

params ["_noteIdx"];

_self set [Q(MemberInfoShown), true];

private _record = _self get Q(GroupInfoRecord);
player removeDiaryRecord ["Diary", _record];

private _content = _self call [F(getTotals), (_self get Q(SharedNotes)) # _noteIdx];
_content = format [
    "<font size='16'><execute expression='%1 call [""fnc_AddGroupNotes"", []]'>%2</execute>  </font>%3",
    Q(ThisCOB),
    "&lt;&lt;",
    _content
];

_self set [
    Q(GroupInfoRecord),
    player createDiaryRecord ["Diary", [TOPIC_GROUP_GEAR, _content]]
];
