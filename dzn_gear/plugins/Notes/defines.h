#include "..\macro.h"


#define ThisCOB dzn_gear_NotesComponent
#define COMPONENT_PATH dzn_gear\plugins\Notes

#define INIT_COMPONENT(NAME) [] call compileScript ['COMPONENT_PATH\Component.sqf']

#define DBG_PREFIX "(dzn_gear.Notes) "

#define NEWLINE_AND_TAB toString[10,32,32,32,32]
#define NEWLINE toString[10]

// -- Palette

#define COLOR_HEX_GOLD SQ(#FFD000)
#define COLOR_HEX_LIGHT_BLUE SQ(#84b0f0)
#define COLOR_HEX_LIGHT_GREEN SQ(#acdb8b)
#define COLOR_HEX_LIME SQ(#7bbf37)
#define COLOR_HEX_AQUA SQ(#12C4FF)
#define COLOR_HEX_BRICK_RED SQ(#eb4f34)

// -- Converts
#define MASS_TO_KG(X) (X * 0.1 * 0.453592) toFixed 2

#define TOPIC_MY_GEAR "Снаряжение"
#define TOPIC_GROUP_GEAR "Снаряжение моей группы"

#define TOTALS_WEIGHT_F "<font>Общий вес: %1 кг</font>"
#define TOTALS_PRIMARY "Основное"
#define TOTALS_SECONDARY "Вторичное"
#define TOTALS_HANDGUN "Пистолет"
#define TOTALS_HEADGEAR "Голова"
#define TOTALS_FACEWEAR "Лицо"
#define TOTALS_VEST "Разгрузка"
#define TOTALS_BACKPACK "Рюкзак"
#define TOTALS_UNIFORM "Униформа"
#define TOTALS_ASSIGNED "Инструменты"
