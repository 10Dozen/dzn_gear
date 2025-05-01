#include "defines.h"

DBG_1("Params: %1", _this);
params [];

private _content = _self call [F(getTotals), [
    name player,
    roleDescription player,
    (getUnitLoadout player) + [loadAbs player]
]];

player removeDiaryRecord ["Diary", _self get Q(PersonalInfoRecord)];
_self set [
    Q(PersonalInfoRecord),
    player createDiaryRecord [
        "Diary",
        [TOPIC_MY_GEAR, _content]
    ]
];
