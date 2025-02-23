#include "defines.h"

DBG_ "Params: %1", _this EOL;
params [];

private _content = _self call [F(getTotals), [
    name player,
    ((roleDescription player) splitString "@") # 0,
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