# dzn_gear

- Allows to choose gear and create gear kit for infantry units
- Allows to create cargo gear kits for vehicles and ammoboxes
- Allows to use created kits to assign gear via: Synchronization with GameLogic or setVariable for unit

<h2>How To</h2>
Download files (except "schemes" folder - it's only shows structure of kits for design purposes) to your mission folder. If you already have "init.sqf", then update it with lines from downloaded "init.sqf". To use 'EDIT' mode use "true" as argument in line <tt>[true] execVM "dzn_gear_init.sqf";</tt>.

<h3>EDIT mode</h3>
In 'EDIT' mode open mission in Editor and click "Preview": inside the mission you'll see new actions at the action menu:
 <ul>
  <li><tt>Open Virtual Arsenal</tt> -- Simply opens VA with all available gear</li>
  <li><tt>Copy Current Gear to Clipboard</tt> -- Copy current gear to clipboard for inserting to <tt>dzn_gear_kits.sqf</tt> file</li>
  <li><tt>Copy and Assign Gear of Cursor Unit</tt> -- Shows up when you staring on infantryman, action will copy unit's gear to player and additionally copy kit to the clipboard</li>
  <li><tt>Copy Gear of Cursor Vehicle or Box</tt> -- Shows up when you staring on vehicle or ammobox, action will copy vehicle's cargo to the clipboard in vehicle kit's format</li>
  <li><tt>Kit with (mission time) (primary weapon classname)</tt> -- After any infanty's kit copied, new action will be added. On action - copied kit will be assigned to player.</li>
  <li><tt>Kit for Vehicle/Box (mission time)</tt> -- After any vehicle's kit copied, new action will be added. Shows up when you starung on vehicle or box, action will assign kit to vehicle/box player looking at.</li>
</ul> 
<br>Basic flow of usage is: Open Virtual Arsenal, choose any gear you need, quit Arsenal and use Copy Current Gear to Clipboard. Than open <tt>dzn_gear_kit.sqf</tt> and paste kit. It will be something like:
<br><tt>_kitName = ["U_B_CombatUniform_mcam", ... ];</tt>
<br>Change <tt>_kitName</tt> to some unique kit name, e.g. <tt>riflemanNATO</tt>, <tt>SF_Demo_NATO</tt>, <tt>OPFOR_OfficerWithMG</tt>. It's preffered to use global variable as name of kit.

<h3>Kits</h3>
Structure of kits is described as xml at <tt>schemes/manKitStructure.xml</tt> and <tt>schemes/boxKitStructure.xml</tt>. For examples you can check <tt>dzn_gear_kits.sqf</tt> file.
<br>There are several types of gear kits are presented:
<ol>
 <li>Gear Kit (for infantries)<ol>
  <li>Simple Kits</li>
  <li>Randomized Kits</li>
  <li>Random Kits</li>
 </ol></li>
 <li>Cargo Kit (for vehicle and ammoboxes)</li>
</ol>

(1)<tt>Gear Kit</tt> could be assigned to any infantry (even to crew of vehicles). It has some randomization option.
<br>(1.i)<tt>Simple Kit</tt> is simple. It has one item for each category (uniform, weapons) which will be assigned to unit as is.
<br>(1.ii)<tt>Randomized Kit</tt> has some variations of gear for some category. E.g. if you change classname of uniform to array of classnames, then unit will get random item from this array (<tt>BIS_fnc_selectRandom</tt> is used). If you want to give unit random weapon, then change weapon's classname to array of classnames and change magazines for weapon to array of magazines - e.g. for Primary weapon:
<br>    change weapon <tt>"arifle_MX_SW_Black_F"</tt> to <tt>["arifle_MX_SW_Black_F","LMG_Zafir_F"]</tt> and then change primary weapon's magazines from <tt>["100Rnd_65x39_caseless_mag_Tracer",3]</tt> to <tt>[["100Rnd_65x39_caseless_mag_Tracer",3],["150Rnd_762x51_Box",3]]</tt>
<br>Categories allowed to randomization are: <tt>Equipment: Uniform, Vest, Backpack, Headgear, Goggles</tt>,  <tt>Primary Weapon: Weapon, Optics Attachement, Muzzle Attachement, Pointer Attachement</tt>, <tt>Secondary (Launcher) Weapon: Weapon</tt>, <tt>Handgun Weapon: Weapon, Optics Attachement, Muzzle Attachement, Pointer Attachement</tt>, <tt>Items</tt>, <tt>Magazines: Primary Weapon Magazine, Secondary Weapon Magazine, Handgun Weapon Magazine</tt>
<br>(1.iii)<tt>Random Kit</tt> is a kit of kits. It doesn't contain any classname, but it is the array of another kit's names (bounded with "). Script will choose random kit from this array and assign it to unit.
<br><br>(2)<tt>Cargo Kit</tt> could be assigned to vehicles and ammoboxes. It contain only items which will be placed in cargo of unit (there is no weight/volume limits, so check quantity of items).

<h3>Assign Kits</h3>
There are several ways to assign kit to unit:
<ol>
 <li>Unit's variable</li>
 <li>GameLogic's variable</li>
 <li>GameLogic's name</li>
</ol>
(1) At the unit's <tt>init</tt> field place line: <tt>this setVariable ["dzn_gear", "%kitName%"]</tt>(for gear kit) or <tt>this setVariable ["dzn_gear_box", "%kitName%"]</tt>(for cargo kit).
<br>(2) Place object <tt>GameLogic-Objects-GameLogic</tt> on map and add a line <tt>this setVariable ["dzn_gear", "%kitName%"]</tt> or <tt>this setVariable ["dzn_gear_box", "%kitName%"]</tt> to it's <tt>init</tt> field. Then synchronize GameLogic with units to assign gear on them (F5 in editor, to better accuracy - link unit to GameLogic). You can also synchronize vehicles with crew to assign gear kit.
<br>(3) Place object <tt>GameLogic-Objects-GameLogic</tt> on map and name it <tt>dzn_gear_%kitname%</tt> or <tt>dzn_gear_box_%kitname%</tt>. Then synchronize GameLogic with units to assign gear on them. You can also synchronize vehicles with crew to assign gear kit.

<h3>How it works</h3> 
After mission starts, all GameLogics will be checked. For any of them which have "dzn_gear" or "dzn_gear_box" in the name or as the variable. All synchronized objects will be returned, for each object the chosen kit will be assigned.
Then all units will be checked for variable "dzn_gear" or "dzn_gear_box" and kits will be assigned.
<br>After gear assigned, unit/object updates with variable "dzn_gear_assigned" which store the name of assigned kit.
<br>Seems that script should be runned from server side, so at the <tt>dzn_gear_init.sqf</tt> there is line <tt>if !(isServer) exitWith {};</tt> before any function or kit will be defined. If you want to use script at client side do not forget to comment this line.
<br>You can also use gear assignment "manually" using next function:
<ul>
 <li><tt>[ unit(object), kitName(string), isBox(boolean) ] spawn dzn_gearSetup</tt> - will assign given kit by name, third argument <tt>isBox</tt> should be set <tt>false</tt> for gear kits or <tt>true</tt> for cargo kits</li>
</ul>
