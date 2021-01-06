// -- Constants
#define VERSION_MAJOR 2
#define VERSION_MINOR 10
#define VERSION QUOTE(VERSION_MAJOR.VERSION_MINOR)

#define DEFAULT_BACKPACK "B_Carryall_khk"


// --- 
#define QUOTE(s) #s
#define TITLE "dzn Gear"
#define	gCOMPONENT dzn_gear

// -- Module and file execution
#define COMPONENT_PATH(FILE) gCOMPONENT\FILE
#define COMPONENT_DATA_PATH(FILE) gCOMPONENT\data\FILE
#define COMPONENT_FILE_PATH(DIR,FILE) gCOMPONENT\DIR\FILE
#define COMPILE_EXECUTE(PATH) call compile preProcessFileLineNumbers 'PATH.sqf'

#define INIT_FILE(FILE) COMPILE_EXECUTE(COMPONENT_PATH(FILE))
#define INIT_DFILE(FILE) COMPILE_EXECUTE(COMPONENT_PATH(data\FILE))
#define INIT_PLUGIN_FILE(FILE) COMPILE_EXECUTE(COMPONENT_PATH(data\plugins\FILE))
#define INIT_PLUGIN(VAR,FILE) if (VAR) then { INIT_PLUGIN_FILE(FILE); }

#define INIT_COMMON COMPILE_EXECUTE(COMPONENT_DATA_PATH(Init))
#define INIT_SERVER if (isServer) then { COMPILE_EXECUTE(COMPONENT_DATA_PATH(InitServer)) }
#define INIT_CLIENT if (hasInterface) then { COMPILE_EXECUTE(COMPONENT_DATA_PATH(InitClient)) }

// -- Vars 
#define GVAR(X) gADDON_NAME##_##X
#define SVAR(X) QUOTE(GVAR(X))
#define FORMAT_VAR(X) format ["%1_%2", ADDON_NAME, X]

#define gSTR_NAME(X) STR_##gADDON##_##X
#define STR_NAME(X) QUOTE(gSTR_NAME(X))

#define COMPILE_FUNCTION(X) GVAR(X) = compile preprocessFileLineNumbers format ["%1%2.sqf", FNC_PATH, #X]