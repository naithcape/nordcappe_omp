#include <ysilib\YSI_Coding\y_hooks>

YCMD:money(playerid, const string: params[], help)
{
    GivePlayerMoney(playerid, 20000);
    return 1;
}

YCMD:kill(playerid, const string: params[], help)
{
    SetPlayerHealth(playerid, 0.0);
    return 1;
}

YCMD:deagle(playerid, const string: params[], help)
{
    GivePlayerWeapon(playerid, WEAPON_DEAGLE, 100);
    return 1;
}

YCMD:m4(playerid, const string: params[], help)
{
    GivePlayerWeapon(playerid, WEAPON_M4, 100);
    return 1;
}

YCMD:ak(playerid, const string: params[], help)
{
    GivePlayerWeapon(playerid, WEAPON_AK47, 100);
    return 1;
}

YCMD:sniper(playerid, const string: params[], help)
{
    GivePlayerWeapon(playerid, WEAPON_SNIPER, 100);
    return 1;
}

YCMD:bomb(playerid, const string: params[], help)
{
    GivePlayerWeapon(playerid, WEAPON_GRENADE, 100);
    return 1;
}

YCMD:rpg(playerid, const string: params[], help)
{
    GivePlayerWeapon(playerid, WEAPON_ROCKETLAUNCHER, 100);
    return 1;
}

YCMD:molotov(playerid, const string: params[], help)
{
    GivePlayerWeapon(playerid, WEAPON_MOLTOV, 100);
    return 1;
}

YCMD:mp5(playerid, const string: params[], help)
{
    GivePlayerWeapon(playerid, WEAPON_MP5, 100);
    return 1;
}