
#define DBG_PREFIX "(dzn_gear) "
#define DBG_FUNC_PREFIX ""
#define DBG_ diag_log format [DBG_PREFIX + "[" + DBG_FUNC_PREFIX + "] " +
#define EOL ]


#define Q(X) #X
#define SQ(X) 'X'
#define _F(X) fnc_##X
#define F(X) Q(_F(X))

#define COB dzn_gear_GenericComponent
#define COMPONENT_PATH dzn_gear\plugins

#define PREP_COMPONENT_FUNCTION(NAME) [F(NAME), compileScript ['COMPONENT_PATH\fnc_##NAME##.sqf']]



