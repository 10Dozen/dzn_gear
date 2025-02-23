#include "..\fn\categories.h"

#define DBG_PREFIX "(dzn_gear) "
#define DBG_FUNC_PREFIX __FILE_SHORT__
#define DBG_ diag_log format [DBG_PREFIX + "[" + DBG_FUNC_PREFIX + "] " +
#define EOL ]

#define Q(X) #X
#define SQ(X) 'X'
#define _F(X) fnc_##X
#define F(X) Q(_F(X))

#define COB dzn_gear_GenericComponent
#define ECOB(PLUGIN,NAME) dzn_gear_##PLUGIN##_##NAME##Component
#define COMPONENT_PATH dzn_gear\plugins

#define PREP_COMPONENT_FUNCTION(NAME) [F(NAME), compileScript ['COMPONENT_PATH\fnc_##NAME##.sqf']]

#define CONVERT_NUMERIC_KEYS(HASH) \
    HASH deleteAt "#SOURCE"; \
    HASH deleteAt "#ERRORS"; \
    private _toDelete = []; \
    { \
        if (_x isEqualType "") then { \
            HASH set [parseNumber _x, _y]; \
            _toDelete pushBack _x; \
        }; \
    } forEach HASH; \
    { HASH deleteAt _x } forEach _toDelete

#define STARTS_WITH(STR,SUBSTR) (STR select [0, count SUBSTR] == SUBSTR)

// -- Palette
#define COLOR_UI (["GUI", "BCG_RGB"] call BIS_fnc_displayColorGet)
#define COLOR_PALE_GREEN [0.54, 0.63, 0.44, 1]
#define COLOR_PALE_RED   [0.63, 0.54, 0.44, 1]
#define COLOR_STEEL_BLUE [0.24, 0.29, 0.34, 0.8]

#define COLOR_DARK_GREEN [0.5, 0.7, 0.6, 1]
#define COLOR_WHITE      [1,1,1,1]
#define COLOR_BLACK      [0,0,0,1]
#define COLOR_GOLD       [0.92, 0.81, 0, 1]
#define COLOR_LIME       [0.48, 0.75, 0.22, 1]
#define COLOR_BRICK_RED  [0.92, 0.31, 0.20, 1]
#define COLOR_AQUA       [0.07, 0.77, 255, 1]


#define COLOR_HEX_GOLD SQ(#FFD000)
#define COLOR_HEX_LIGHT_BLUE SQ(#84b0f0)
#define COLOR_HEX_LIGHT_GREEN SQ(#acdb8b)
#define COLOR_HEX_LIME SQ(#7bbf37)
#define COLOR_HEX_AQUA SQ(#12C4FF)
#define COLOR_HEX_BRICK_RED SQ(#eb4f34)
