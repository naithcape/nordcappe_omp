#include <ysilib\YSI_Coding\y_hooks>

static  
	player_Skin[MAX_PLAYERS],
	player_Staff[MAX_PLAYERS];

hook Account_Load(playerid, const string: name[], const string: value[])
{
	INI_Int("Staff", player_Staff[playerid]);

	return 1;
}

new stfveh[MAX_PLAYERS] = { INVALID_VEHICLE_ID, ... };

hook OnPlayerConnect(playerid)
{
	stfveh[playerid] = INVALID_VEHICLE_ID;

	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	new INI:File = INI_Open(Account_Path(playerid));
	INI_SetTag( File, "data" );
	INI_WriteInt(File, "Staff", player_Staff[playerid]);
    INI_Close(File);

	DestroyVehicle(stfveh[playerid]);
	stfveh[playerid] = INVALID_PLAYER_ID;

	return 1;
}

hook OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
	DestroyVehicle(stfveh[playerid]);
	stfveh[playerid] = INVALID_PLAYER_ID;

	return 1;
}

YCMD:help(playerid, params[], help)
{
	if (help)
		return SendClientMessage(playerid, -1, "Use `/help <command>` to get information about the command.");

	else if (IsNull(params))
		return SendClientMessage(playerid, -1, "Please enter a command.");

	else
		return Command_ReProcess(playerid, params, true);
}


YCMD:staffcmd(playerid, const string: params[], help)
{
	if (help)
        return SendClientMessage(playerid, -1, ""color_server"HELP >> "color_white"This command show you all staff commands.");

	if (!player_Staff[playerid])
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_red"Only Staff Team!");

	Dialog_Show(playerid, "dialog_staffcmd", DIALOG_STYLE_MSGBOX,
	""color_server"NordKapp : "color_white"Staff Commands",
	""color_white"%s, Vi ste deo naseg "color_server"staff "color_white"tima!\n\
	"color_server"SLVL1 >> "color_white"/sduty\n\
	"color_server"SLVL1 >> "color_white"/sc\n\
	"color_server"SLVL1 >> "color_white"/staffcmd\n\
	"color_server"SLVL1 >> "color_white"/sveh\n\
	"color_server"SLVL1 >> "color_white"/goto\n\
	"color_server"SLVL1 >> "color_white"/cc\n\
	"color_server"SLVL1 >> "color_white"/fv\n\
	"color_server"SLVL2 >> "color_white"/gethere\n\
	"color_server"SLVL3 >> "color_white"/nitro\n\
	"color_server"SLVL4 >> "color_white"/jetpack\n\
	"color_server"SLVL4 >> "color_white"/setskin\n\
	"color_server"SLVL4 >> "color_white"/xgoto\n\
	"color_server"SLVL4 >> "color_white"/spanel\n\
	"color_server"SLVL4 >> "color_white"/setstaff",
	"OK", "", ReturnPlayerName(playerid)
	);

    return 1;
}

YCMD:sc(playerid, const string: params[], help)
{
	if (help)
        return SendClientMessage(playerid, -1, ""color_server"HELP >> "color_white"This is command for Staff Chat.");


	if (player_Staff[playerid] < 1)
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_red"Only Staff Team!");

	if (isnull(params))
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"/sc [text]");

	foreach (new i: Player)
		if (player_Staff[i])
			SendClientMessage(i, -1, "SC // %s(%d): "color_white"%s", ReturnPlayerName(playerid), playerid, params);

    return 1;
}

YCMD:sveh(playerid, params[], help)
{
	if (help)
        return SendClientMessage(playerid, -1, ""color_server"HELP >> "color_white"This command create your staff vehicle.");


	if (player_Staff[playerid] < 1)
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_red"Only Staff Team!");

	new Float:x, Float:y, Float:z;

	GetPlayerPos(playerid, x, y, z);

	if (stfveh[playerid] == INVALID_VEHICLE_ID) 
	{
		if (isnull(params))
			return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"/sveh [Model ID]");

		new modelid = strval(params);

		if (400 > modelid > 611)
			return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"* Valid models from 400 to 611.");

		new vehicleid = stfveh[playerid] = CreateVehicle(modelid, x, y, z, 0.0, 1, 0, -1);

		SetVehicleNumberPlate(vehicleid, "STAFF");
		PutPlayerInVehicle(playerid, vehicleid, 0);
		
	    new bool:engine, bool:lights, bool:alarm, bool:doors, bool:bonnet, bool:boot, bool:objective;
	    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	    if (IsVehicleBicycle(GetVehicleModel(vehicleid)))
	    {
	        SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, doors, bonnet, boot, objective);
	    }
	    else
	    {
	        SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, doors, bonnet, boot, objective);
	    }
		SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"You created a vehicle, to destroy type "color_server"'/sveh'.");
	}
	else 
	{
		DestroyVehicle(stfveh[playerid]);
		stfveh[playerid] = INVALID_PLAYER_ID;
		SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"You destroy a vehicle, to create type "color_server"'/sveh'.");
	}
	
    return 1;
}

YCMD:goto(playerid, params[],help)
{
	if (help)
        return SendClientMessage(playerid, -1, ""color_server"HELP >> "color_white"This command allow you teleport to player.");


	if (player_Staff[playerid] < 1)
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_red"Only Staff Team!");

	new giveplayerid, giveplayer[MAX_PLAYER_NAME];

	new Float:plx,Float:ply,Float:plz;

	GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));

	if (!sscanf(params, "u", giveplayerid))
	{	
		GetPlayerPos(giveplayerid, plx, ply, plz);
			
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, plx, ply+4, plz);
		}
		else
		{
			SetPlayerPos(playerid,plx,ply+2, plz);
		}
		SetPlayerInterior(playerid, GetPlayerInterior(giveplayerid));
	}
    return 1;
}

YCMD:cc(playerid, params[], help)
{
	if (help)
        return SendClientMessage(playerid, -1, ""color_server"HELP >> "color_white"This command will clear chat to all.");


	if (player_Staff[playerid] < 1)
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_red"Only Staff Team!");

	for(new cc; cc < 110; cc++)
	{
		SendClientMessageToAll(-1, "");
	}

	SendClientMessageToAll(-1, ""color_server"NordKapp : "color_white"chat is cleared by"color_server" %s", ReturnPlayerName(playerid));

    return 1;
}

YCMD:fv(playerid, params[], help)
{
	if (help)
        return SendClientMessage(playerid, -1, ""color_server"HELP >> "color_white"This command fix your vehicle.");


	if (player_Staff[playerid] < 1)
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_red"Only Staff Team!");

	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid)) 
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"You are not in vehicle!");

	RepairVehicle(vehicleid);

	SetVehicleHealth(vehicleid, 999.0);

	return 1;
}

YCMD:gethere(playerid, const params[], help)
{
	if (help)
		return SendClientMessage(playerid, -1, ""color_server"HELP >> "color_white"This command teleport player to you.");

	if (player_Staff[playerid] < 1)
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_red"Only Staff Team!");

	new targetid = INVALID_PLAYER_ID;

	if (sscanf(params, "u", targetid)) 
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"/gethere [id]");

	if (targetid == INVALID_PLAYER_ID) 
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"That "color_server"ID "color_white"is not connected.");

	new Float:x, Float:y, Float:z;

	GetPlayerPos(playerid, x, y, z);

	SetPlayerPos(targetid, x+1, y, z+1);

	SetPlayerInterior(targetid, GetPlayerInterior(playerid));

	SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));

	new name[MAX_PLAYER_NAME];
	GetPlayerName(targetid, name, sizeof(name));

	SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"You teleported player "color_server"%s "color_white"to you.", name);

	GetPlayerName(playerid, name, sizeof(name));

	SendClientMessage(targetid, -1, ""color_server"NordKapp : "color_white"Staff "color_server"%s "color_white"teleported you to him.", name);

    return 1;
}

YCMD:nitro(playerid, params[], help)
{
	if (help)
		return SendClientMessage(playerid, -1, ""color_server"HELP >> "color_white"This command give you a nitro.");

	if (player_Staff[playerid] < 1)
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_red"Only Staff Team!");

	AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);

	SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"You put nitro in your vehicle.");

	return 1;
}

YCMD:jetpack(playerid, params[], help)
{
	if (help)
		return SendClientMessage(playerid, -1, ""color_server"HELP >> "color_white"This command give you jetpack.");


	if (player_Staff[playerid] < 1)
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_red"Only Staff Team!");

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);

	SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"You take a jetpack.");

	return 1;
}

YCMD:setskin(playerid, const string: params[], help)
{
	if (help)
		return SendClientMessage(playerid, -1, ""color_server"HELP >> "color_white"This command allow you to put skin from 1 to 311.");

	if (player_Staff[playerid] < 1)
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_red"Only Staff Team!");

	static
		targetid,
		skinid;

	if (sscanf(params, "ri", targetid, skinid))
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"/setskin [targetid] [skinid]");

	if (!(1 <= skinid <= 311))
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"Wrong skinid!");

	if (GetPlayerSkin(targetid) == skinid)
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"Player have that skinid!");

	SetPlayerSkin(targetid, skinid);

	player_Skin[targetid] = skinid;

    new INI:File = INI_Open(Account_Path(playerid));
	INI_SetTag( File, "data" );
    INI_WriteInt(File, "Skin", GetPlayerSkin(playerid));
	INI_Close(File);

    return 1;
}

YCMD:xgoto(playerid, params[], help)
{
	if (help)
		return SendClientMessage(playerid, -1, ""color_server"HELP >> "color_white"This command teleport you to coordinate.");


	if (player_Staff[playerid] < 1)
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_red"Only Staff Team!");

	new Float:x, Float:y, Float:z;

	if (sscanf(params, "fff", x, y, z)) SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"xgoto <X Float> <Y Float> <Z Float>");
	else
	{
		if (IsPlayerInAnyVehicle(playerid))
		{
		    SetVehiclePos(GetPlayerVehicleID(playerid), x,y,z);
		}
		else
		{
		    SetPlayerPos(playerid, x, y, z);
		}
		SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"You set coordinate to "color_server"%f, %f, %f", x, y, z);
	}
 	return 1;
}

YCMD:setstaff(playerid, const string: params[], help)
{
	if (help)
        return SendClientMessage(playerid, -1, ""color_server"HELP >> "color_white"0 - Revoke Staff | 1. Assistent | 2. Admin | 3. Manager | 4. High Command.");

	if (!IsPlayerAdmin(playerid))
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"You Must Be RCON!");

	static
		targetid,
		level;

	if (sscanf(params, "ri", targetid, level))
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"/setstaff [targetid] [0/1]");

	if (!level && !player_Staff[targetid])
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"That player is not a part of "color_server"Staff Team.");

	if (level == player_Staff[targetid])
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"That player is alredy part of "color_server"Staff Team.");

	player_Staff[targetid] = level;
	
	if (!level)
	{
		SendClientMessage(targetid, -1, ""color_server"NordKapp : "color_server"%s "color_white"demote you from Staff Team.", ReturnPlayerName(playerid));

		SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"You demote "color_server"%s "color_white"from Staff Team.", ReturnPlayerName(targetid));
	}
	else if (level < 0 || level > 4) return SendClientMessage(playerid, -1, ""color_white"NordKapp : "color_white"Please use "color_server"-/help setstaff- "color_white"to see all staff levels.");
	{

		SendClientMessage(targetid, -1, ""color_server"NordKapp : "color_server"%s "color_white"promote you to Staff Team.", ReturnPlayerName(playerid));

		SendClientMessage(targetid, -1, ""color_server"NordKapp : "color_white"You promoted "color_server"%s "color_white"to Staff Team.", ReturnPlayerName(targetid));
	}

    new INI:File = INI_Open(Account_Path(playerid));
	INI_SetTag( File, "data" );
    INI_WriteInt(File, "Staff", player_Staff[playerid]);
	INI_Close(File);
	
    return 1;
}

YCMD:kick(playerid, params[],help)
{
	if (help)
        return SendClientMessage(playerid, -1, ""color_server"HELP >> "color_white"The command allow you to kick player from server.");

	if (player_Staff[playerid] < 1)
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_red"Only Staff Team!");

	static 
		targetid;

	if (sscanf(params, "ri", targetid))
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"/kick [targetid]");

	SendClientMessage(targetid, -1, ""color_server"NordKapp : "color_server"%s "color_white"kick you from the server.", ReturnPlayerName(playerid));

	SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"You kick "color_server"%s "color_white"from server.", ReturnPlayerName(targetid));

	SetTimerEx("DelayedKick", 1000, false, "i", targetid);

    return 1;
}

YCMD:restart(playerid, const string: params[], help)
{
	if (!IsPlayerAdmin(playerid))
		return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"You Must Be RCON!");

	GetPlayerPos(playerid, player_PosX[playerid], player_PosY[playerid], player_PosZ[playerid]);

	new INI:File = INI_Open(Account_Path(playerid));
	INI_SetTag( File, "data" );
	INI_WriteFloat(File, "positionX", player_PosX[playerid]);
    INI_WriteFloat(File, "positionY", player_PosY[playerid]);
    INI_WriteFloat(File, "positionZ", player_PosZ[playerid]);
    INI_Close(File);

	SendRconCommand("gmx 1");
    return 1;
}
