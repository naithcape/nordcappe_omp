#include <ysilib\YSI_Coding\y_hooks>

static stock const USER_PATH[64] = "/Users/%s.ini";

const MAX_LOGIN_ATTEMPTS = 	3;

enum
{
	e_SPAWN_TYPE_REGISTER = 1,
    e_SPAWN_TYPE_LOGIN
};

static  
    player_Password[MAX_PLAYERS][BCRYPT_HASH_LENGTH],
    player_Score[MAX_PLAYERS],
	player_Skin[MAX_PLAYERS],
    player_Money[MAX_PLAYERS],
    player_LoginAttempts[MAX_PLAYERS];

new 
    Float:player_PosX[MAX_PLAYERS],
    Float:player_PosY[MAX_PLAYERS],
    Float:player_PosZ[MAX_PLAYERS];

hook Account_Load(playerid, const string: name[], const string: value[])
{
    INI_String("Password", player_Password[playerid]);
	INI_Int("Score", player_Score[playerid]);
	INI_Int("Skin", player_Skin[playerid]);
	INI_Int("Money", player_Money[playerid]);
	INI_Float("positionX", player_PosX[playerid]);
	INI_Float("positionY", player_PosY[playerid]);
	INI_Float("positionZ", player_PosZ[playerid]);
	
	return 1;
}

hook OnPlayerConnect(playerid)
{
	if (fexist(Account_Path(playerid)))
	{
		INI_ParseFile(Account_Path(playerid), "Account_Load", true, true, playerid);
		Dialog_Show(playerid, "dialog_login", DIALOG_STYLE_PASSWORD,
			"Login",
			"%s, type your password: ",
			"Ok", "Exit", ReturnPlayerName(playerid)
		);

		return 1;
	}

	Dialog_Show(playerid, "dialog_regpassword", DIALOG_STYLE_INPUT,
		"Register",
		"%s, type your password: ",
		"Ok", "Exit", ReturnPlayerName(playerid)
	);

	SetPlayerPos(playerid, player_PosX[playerid], player_PosY[playerid], player_PosZ[playerid]);

	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	GetPlayerPos(playerid, player_PosX[playerid], player_PosY[playerid], player_PosZ[playerid]);

	new INI:File = INI_Open(Account_Path(playerid));
	INI_SetTag( File, "data" );
    INI_WriteInt(File, "Score",GetPlayerScore(playerid));
    INI_WriteInt(File, "Skin",GetPlayerSkin(playerid));
    INI_WriteInt(File, "Money", GetPlayerMoney(playerid));
	INI_WriteFloat(File, "positionX", player_PosX[playerid]);
    INI_WriteFloat(File, "positionY", player_PosY[playerid]);
    INI_WriteFloat(File, "positionZ", player_PosZ[playerid]);
    INI_Close(File);

	return 1;
}

hook OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
	SetSpawnInfo(playerid, 255, player_Skin[playerid],
		1216.1213, -1276.8828, 63.5066, 132.2329,
		WEAPON_PARACHUTE, 1, WEAPON_FIST, 0, WEAPON_FIST, 0
	);
	GivePlayerMoney(playerid, -1000);

	return 1;
}

timer Spawn_Player[100](playerid, type)
{
	if (type == e_SPAWN_TYPE_REGISTER)
		{
			SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"Welcome to the server!");
			SetSpawnInfo(playerid, 255, player_Skin[playerid],
				1216.1213, -1276.8828, 63.5066, 132.2329,
				WEAPON_PARACHUTE, 1, WEAPON_FIST, 0, WEAPON_FIST, 0
			);
			SpawnPlayer(playerid);

			SetPlayerScore(playerid, player_Score[playerid]);
			GivePlayerMoney(playerid, player_Money[playerid]);
			SetPlayerSkin(playerid, player_Skin[playerid]);
			SetPlayerHealth(playerid, 80.0);
		}

		else if (type == e_SPAWN_TYPE_LOGIN)
		{
			SendClientMessage(playerid, -1,""color_server"NordKapp : "color_white"Welcome to the server!");
			SetSpawnInfo(playerid, 255, player_Skin[playerid],
				player_PosX[playerid], player_PosY[playerid], player_PosZ[playerid], 0,
				WEAPON_FIST, 0, WEAPON_FIST, 0,	WEAPON_FIST, 0
			);
			SpawnPlayer(playerid);

			SetPlayerScore(playerid, player_Score[playerid]);
			GivePlayerMoney(playerid, player_Money[playerid]);
			SetPlayerSkin(playerid, player_Skin[playerid]);
			SetPlayerHealth(playerid, 80.0);
		}

}

Dialog: dialog_regpassword(playerid, response, listitem, string: inputtext[])
{
	if (!response)
		return Kick(playerid);

	bcrypt_hash(playerid, "OnPlayerPasswordHash", inputtext, BCRYPT_COST);

	new INI:File = INI_Open(Account_Path(playerid));
	INI_SetTag( File, "data" );
	INI_WriteInt(File, "Level", 0);
	INI_WriteInt(File, "Skin", 240);
	INI_WriteInt(File, "Money", 1000);
	INI_Close(File);

	player_Money[playerid] = 1000;
	player_Skin[playerid] = 240;
	player_Score[playerid] = 0;
	
	return 1;
}


Dialog: dialog_login(const playerid, response, listitem, string: inputtext[])
{
	bcrypt_verify(playerid, "OnPlayerVerifyHash", inputtext, player_Password[playerid]);

	return 1;
}

Account_Path(const playerid)
{
	new tmp_fmt[64];
	format(tmp_fmt, sizeof(tmp_fmt), USER_PATH, ReturnPlayerName(playerid));

	return tmp_fmt;
}

forward OnPlayerPasswordHash(playerid);
public OnPlayerPasswordHash(playerid)
{
	new hash[BCRYPT_HASH_LENGTH];
	bcrypt_get_hash(hash);

    new INI:File = INI_Open(Account_Path(playerid));
    INI_SetTag(File, "data");
    INI_WriteString(File, "Password", hash);
    INI_Close(File);

    defer Spawn_Player(playerid, 1);

    return 1;
}

forward OnPlayerVerifyHash(playerid, bool: success);
public OnPlayerVerifyHash(playerid, bool: success)
{
	if (success)
    {
        defer Spawn_Player(playerid, 2);
    }
    else
    {
        if (player_LoginAttempts[playerid] == MAX_LOGIN_ATTEMPTS)
            return Kick(playerid);

        ++player_LoginAttempts[playerid];

        Dialog_Show(playerid, "dialog_login", DIALOG_STYLE_PASSWORD,
            "Login",
            "%s, wrong password, try again: ",
            "Ok", "Exit", ReturnPlayerName(playerid)
        );
    }
    return 1;
}