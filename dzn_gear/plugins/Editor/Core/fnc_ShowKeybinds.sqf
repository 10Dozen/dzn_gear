#include "defines.h"
#define DBG_FUNC_PREFIX "ShowKeybinds"

hint parseText format["<t size='2' color='#FFD000' shadow='1'>dzn_gear</t>
    <br /><br /><t size='1.45' color='#3793F0' underline='true'>Keybinding:</t>
    <br />
    <br /><t %1>[F1]</t><t %2> - Show keybinding</t>
    <br /><t %1>[F2]</t><t %2> - Show Gear Totals</t>
    <br />
    <br />
    <br /><t %1>[SPACE]</t><t %2> - Open Arsenal</t>
    <br /><t %1>[CTRL + SPACE]</t><t %2> - Copy gear of player or cursorTarget and add it to action list</t>
    <br />
     <br /><t %1>CTRL + I</t><t %2> - copy unit/player identity settings</t>
    <br />
    <br /><t %1>DEL/CTRL + DEL</t><t %2> - clear current unit's gear</t>
    "
    , "align='left' color='#3793F0' size='0.9'"
    , "align='right' size='0.8'"
];

