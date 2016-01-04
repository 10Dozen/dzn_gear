# dzn_gear
##### Version: 2.0

<i>Uses aeroson's get_loadout/set_loadout script (see https://github.com/aeroson/a3-loadout)</i>

- Allows to choose gear and create gear kit for infantry units
- Randomized infanty kit (random weapon, equipement, uniforms, etc.)
- Allows to create cargo gear kits for vehicles and ammoboxes
- Allows to use created kits to assign gear via: Synchronization with GameLogic or setVariable for unit

<h2>How To</h2>
Download files to your mission folder. If you already have "init.sqf", then update it with lines from downloaded "init.sqf".
<br>Script should be ran with options<tt>[ editMode(BOOL), startDelay(NUMBER, Optional) ] execVM "dzn_gear_init.sqf";</tt>.
<br>
<ol>
 <li>Open Editor and place GameLogic object</li>
 <li>Name GameLogic as <tt>dzn_gear_%KITNAME%</tt> or <tt>dzn_gear_box_%KITNAME%</tt></li>
 <li>Synchronize GameLogic with units to assign kit for them</li>
 <li><i>(Optional)</i> You can also assign kit by adding <tt>this setVariable ["dzn_gear", "%KITNAME%", true]</tt> or <tt>this setVariable ["dzn_gear_box", "%KITNAME%", true]</tt> to units/vehicle init</li>
 <li><i>(Optional)</i> You can also assign kit by adding <tt>this setVariable ["dzn_gear", "%KITNAME%", true]</tt> or <tt>this setVariable ["dzn_gear_box", "%KITNAME%", true]</tt> to GmaeLogic's init and synchronizing units with this GameLogic</li>
 <li>Open mission in EDIT MODE of dzn_gear and create kits</li>
 <li>Save kits to <tt>dzn_gear/dzn_gear_kits.sqf</tt></li>
 <li>Rename kits (kitname from GameLogic's name or variable should match)</li>
</ol>

<h3>Video HowTo</h3> 
https://www.youtube.com/watch?v=rhsF5Jw3Vdo
<!--
<h3>Google Slides HowTo</h3> 
-->

<h3>Kits</h3>
There are several types of gear kits you can create:
<ol>
 <li>Gear Kit (for infantries)<ol>
  <li>Simple Kits</li>
  <li>Randomized Kits</li>
  <li>Random Kits</li>
 </ol></li>
 <li>Cargo Kit (for vehicles and ammoboxes)</li>
</ol>

(1)<tt>Gear Kit</tt> could be assigned to any infantry (even to crew of vehicles). It has some randomization option.
<br>(1.i)<tt>Simple Kit</tt> is simple. It has one item for each category (uniform, weapons) which will be assigned to unit as is.
<br>(1.ii)<tt>Randomized Kit</tt> has some variations of gear for some category. E.g. if you change classname of uniform to array of classnames, then unit will get random item from this array (<tt>BIS_fnc_selectRandom</tt> is used). If you want to give unit a random weapon, then change weapon's classname to array of classnames and change magazines for weapon to array of magazines - e.g. for Primary weapon:
<br>    change weapon <tt>"arifle_MX_SW_Black_F"</tt> to <tt>["arifle_MX_SW_Black_F","LMG_Zafir_F"]</tt> and then change primary weapon's magazines from <tt>["100Rnd_65x39_caseless_mag_Tracer",3]</tt> to <tt>[["100Rnd_65x39_caseless_mag_Tracer",3],["150Rnd_762x51_Box",3]]</tt>
<br>Categories allowed to randomization are: <tt>Equipment: Uniform, Vest, Backpack, Headgear, Goggles</tt>,  <tt>Primary Weapon: Weapon, Optics Attachement, Muzzle Attachement, Pointer Attachement</tt>, <tt>Secondary (Launcher) Weapon: Weapon</tt>, <tt>Handgun Weapon: Weapon, Optics Attachement, Muzzle Attachement, Pointer Attachement</tt>, <tt>Items</tt>, <tt>Magazines: Primary Weapon Magazine, Secondary Weapon Magazine, Handgun Weapon Magazine</tt>
<br>(1.iii)<tt>Random Kit</tt> is a kit of kits. It doesn't contain any classname, but it is the array of another kit's names (bounded with "). Script will choose random kit from this array and assign it to unit. You can use the name of randomized kit here.
<br><br>(2)<tt>Cargo Kit</tt> could be assigned to vehicles and ammoboxes. It contain only items which will be placed in cargo of unit (there is no weight/volume limits, so check quantity of items).

<h3>Assign Kits</h3>
There are several ways to assign kit to unit:
<ol>
 <li>Unit's variable</li>
 <li>GameLogic's variable</li>
 <li>GameLogic's name</li>
</ol>
(1) At the unit's <tt>init</tt> field place line: <tt>this setVariable ["dzn_gear", "%kitName%"]</tt>(for gear kit) or <tt>this setVariable ["dzn_gear_box", "%kitName%"]</tt>(for cargo kit).
<br>(2) Place object <tt>GameLogic-Objects-GameLogic</tt> on map and add a line <tt>this setVariable ["dzn_gear", "%kitName%"]</tt> or <tt>this setVariable ["dzn_gear_box", "%kitName%"]</tt> to it's <tt>init</tt> field. Then synchronize GameLogic with units to assign gear to them (F5 in editor, to better accuracy - link unit to GameLogic). You can also synchronize vehicles with crew to assign gear kit.
<br>(3) Place object <tt>GameLogic-Objects-GameLogic</tt> on map and name it <tt>dzn_gear_%kitname%</tt> or <tt>dzn_gear_box_%kitname%</tt>. Then synchronize GameLogic with units to assign gear on them. You can also synchronize vehicles with crew to assign gear kit.

<h3>How it works</h3> 
After mission starts, all GameLogics will be checked. For any of them which have "dzn_gear" or "dzn_gear_box" in the name or as the variable all synchronized objects will be returned. For each object the chosen kitname will be checked for existence in file <tt>dzn_gear\dzn_gear_kit.sqf</tt> and then kit with such name will be assigned.
Then all units will be checked for variable "dzn_gear" or "dzn_gear_box" and kits will be assigned.
<br>After gear assigned, unit/object updates with variable "dzn_gear_assigned" which store the name of assigned kit.
<br>Script runs at mission initialization. If you want to delay it, use second argument - e.g. 15 seconds after mission start:  <tt>[ false,  15 ] execVM "dzn_gear_init.sqf";</tt>.

<h4>API</h4>
After 'dzn_gear' initialized the <tt>dzn_gear_initialized = true</tt> variable is published via network.
You can also use gear assignment "manually" using next function:
<ul>
 <li><tt>[ @Unit, @Kitname(string), (Optional)@isVehicle ] spawn dzn_fnc_gear_assignKit</tt> - assign given @kitname (as string, e.g. kit_nato_ar = [...] should be given as "kit_nato_ar") to @Unit or to vehicle, if @isVehicle argument passed as TRUE</li>
 <li><tt>[ @Unit, @Kit(array) ] spawn dzn_fnc_gear_assignGear</tt> - assign given @Kit (array of gear, returned from dzn_fnc_gear_getGear function) to @Unit (infantry)</li>
 <li><tt>[ @Vehicle, @CargoKit(array) ] spawn dzn_fnc_gear_assignCargoGear</tt> - assign given @CargoKit(array of gear, returned from dzn_fnc_gear_getCargoGear function) to @Vehicle (or box)</li> 
 <li><tt>@Kit = @Unit call dzn_fnc_gear_getGear</tt> - return gear of infantry unit in format of dzn_gear kit.</li>
 <li><tt>@CargoKit = @Vehicle call dzn_fnc_gear_getCargoGear</tt> - return Cargo gear of vehicle or box in format of dzn_gear kit</li>
 <br>
 <li><tt>@PreciseGear = @Unit call dzn_fnc_gear_getPreciseGear</tt> - return array of @PreciseGear (gear as it exists in units inventory, ammo in magazines is counted).
 <li><tt>[ @Unit, @PreciseGear ] call dzn_fnc_gear_setPreciseGear</tt> - assign @PreciseGear to @Unit (infantry)</li>
</ul>

<h3>Edit mode</h3>
In 'EDIT' mode open mission in Editor and click "Preview": inside the mission you'll see hint with help text and keybinding.

<h4>Edit mode: Keybinding</h4>
<ul>
 <li><tt>[SPACE]</tt> -- Open Virtual Arsenal</li>
 <li><tt>[CTRL + SPACE]</tt> -- Copy gear of player or cursorTarget and add it to action list</li>
 <li><tt>[SHIFT + SPACE]</tt> -- Copy gear of player or cursorTarget without adding new action</li>
 <li></li>
 <li><tt>[1...6]</tt> -- Show item list (primary weapon, uniform, headgear, etc.) and copy to clipboard</li>
 <li><tt>[SHIFT + 1...6]</tt> -- Set current item list and copy list</li>
 <li><tt>[CTRL + 1...6]</tt> -- Add item to list and copy</li>
 <li><tt>[ALT + 1...6]</tt> --Clear item list</li>
 <br>where 1..6:
 <br><tt>1</tt> -- Primary weapon and magazine
 <br><tt>2</tt> -- Uniform 
 <br><tt>3</tt> -- Headgear
 <br><tt>4</tt> -- Goggles
 <br><tt>5</tt> -- Vest
 <br><tt>6</tt> -- Backpack
</ul>

When kit is created via <tt>[CTRL + SPACE]</tt> an actions will be added:
<ul>
 <li><tt>Kit with MX at 00:01:32</tt> -- action will assign saved gear to player or cursor target (primary weapon and timestamp are added to action name)</li>
 <li><tt>Cargo Kit from ZAMAK (Covered) at 00:02:32</tt> -- action will assign saved cargo gear to player's or cursor vehicle or box (vehicle name and timestamp are added to action name)</li>
</ul>

<h4>Edit mode: Basic flow of usage</h4>
<ol>
 <li>Open Virtual Arsenal by pressing <tt>[SPACE]</tt> key and choose any gear you need</li>
 <li>Quit Arsenal and press <tt>[CTRL + SHIFT]</tt> to copy kit to clipboard</li>
 <li>Then open <tt>dzn_gear/dzn_gear_kit.sqf</tt> and paste kit. It will be something like:
<br><tt>kit_NewKitName = [["<EQUIPEMENT >>", ...]  ... ];</tt>
 <li>Change <tt>kit_NewKitName</tt> to some unique kit name, e.g. <tt>kit_riflemanNATO</tt>, <tt>kit_SF_Demo_NATO</tt>,  <tt>kit_OPFOR_OfficerWithMG</tt>. Use only global variable as name of kit.</li>
</ol>

<h3>Plugins</h4>
<h4>Gear Assignement Table</h4>
Map kits by RoleDescription or unit name.
