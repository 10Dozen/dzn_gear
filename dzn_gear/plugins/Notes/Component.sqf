#include "defines.h"

/*
    Personal kit info (copy GearTotals?)
    Squad gear info (Group + Nickname + Main weapon + Launcher

*/

params ["_settings"];

private _declaration = [
    [Q(Settings), _settings],
    [Q(RefreshGroupNotes), _settings get Q(Group) get Q(enable)],  // Flag to referesh group notes

    [Q(SharedNotes), []], // Notes of other group members - [name, role, loadout]
    [Q(PersonalInfoRecord), diaryRecordNull],  // Ref to Personal info diary record
    [Q(GroupInfoRecord), diaryRecordNull],  // Ref to Group info diary record
    [Q(MemberInfoShown), false],

    PREP_COMPONENT_FUNCTION(AddNotes),
    PREP_COMPONENT_FUNCTION(AddGroupNotes),
    PREP_COMPONENT_FUNCTION(getTotals),
    PREP_COMPONENT_FUNCTION(showItemInfo),
    PREP_COMPONENT_FUNCTION(showMemberNote)
];

private _cob = createHashMapObject [_declaration];

_cob
