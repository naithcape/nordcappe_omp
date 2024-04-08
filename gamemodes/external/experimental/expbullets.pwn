#include <ysilib\YSI_Coding\y_hooks>

static bool:explosive[MAX_PLAYERS char] = {false,...};
 
hook OnPlayerDisconnect(playerid, reason)
{
	explosive{playerid} = false;
	return 1;
}

YCMD:eb(playerid, params[], help)
{
	if(!explosive{playerid})
	{
		SendClientMessage(playerid, 0xFFFF00FF, "Explosive bullets on");
	    explosive{playerid} = true;
	}
	else
	{
        SendClientMessage(playerid, 0xFFFF00FF, "Explosive bullets off");
	    explosive{playerid} = false;
	}
	return 1;
}
 
hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(explosive{playerid})
	{
	    CreateExplosion(fX, fY, fZ, 12, 5.0);
	}
	return 1;
}
 
