#include <ysilib\YSI_Coding\y_hooks>

#define DRIFT_MIN_ANGLE 10.0
#define DRIFT_MAX_ANGLE 90.0
#define DRIFT_SPEED 30.0

#pragma unused GetPlayerTheoreticAngle
new Float:gpps[20][3];
enum Float:Pos{ Float:sX,Float:sY,Float:sZ };
new Float:SavedPos[MAX_PLAYERS][Pos];

new DriftPointsNow[200];
new PlayerDriftPoints[200];

new Text:DriftTD;

static
    player_Money[MAX_PLAYERS];

hook Account_Load(playerid, const string: name[], const string: value[])
{
    INI_Int("Money", player_Money[playerid]);

    return 1;
}

hook OnGameModeInit()
{
    DriftTD = TextDrawCreate(123.968872, 431.417358, " ");
	TextDrawLetterSize(DriftTD, 0.291303, 1.594166);
	TextDrawAlignment(DriftTD, TEXT_DRAW_ALIGN_CENTER);
	TextDrawColour(DriftTD, -1);
	TextDrawSetShadow(DriftTD, 0);
	TextDrawBackgroundColour(DriftTD, 255);
	TextDrawFont(DriftTD, TEXT_DRAW_FONT_1);
	TextDrawSetProportional(DriftTD, true);

    SetTimer("AngleUpdate" , 700, true);
    SetTimer("DriftCount", 500, true);

	return 1;
}

hook OnPlayerConnect(playerid)
{
    TextDrawHideForPlayer(playerid, DriftTD);

	return 1;
}

hook OnPlayerUpdate(playerid)
{
    if (!IsPlayerInAnyVehicle(playerid))
	{
 		TextDrawHideForPlayer(playerid, DriftTD);
	}

	return 1;
}

hook OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate)
{
	if (newstate == PLAYER_STATE_DRIVER) 
    {
		TextDrawShowForPlayer(playerid, DriftTD);
    }

	return 1;
}

forward AngleUpdate();
public AngleUpdate()
{
    for(new g = 0; g < GetMaxPlayers(); g++) 
    {
        if (IsPlayerConnected(g))
        {
            new Float:x, Float:y, Float:z;
            if (IsPlayerInAnyVehicle(g))
                GetVehiclePos(GetPlayerVehicleID(g), x, y, z);
            else
                GetPlayerPos(g, x, y, z);
                
            gpps[g][0] = x;
            gpps[g][1] = y;
            gpps[g][2] = z;
        }
    }
}

Float:GetPlayerTheoreticAngle(i)
{
    new Float:sin;
    new Float:dis;
    new Float:angle2;
    new Float:x,Float:y,Float:z;
    new Float:tmp3;
    new Float:tmp4;
    new Float:MindAngle;
    if (IsPlayerConnected(i)) 
    {
        GetPlayerPos(i,x,y,z);
        dis = floatsqroot(floatpower(floatabs(floatsub(x,gpps[i][0])),2)+floatpower(floatabs(floatsub(y,gpps[i][1])),2));
        if (IsPlayerInAnyVehicle(i))GetVehicleZAngle(GetPlayerVehicleID(i), angle2); else GetPlayerFacingAngle(i, angle2);
        if (x>gpps[i][0]) 
        {
            tmp3=x-gpps[i][0];
        }
        else 
        {
            tmp3=gpps[i][0]-x;
        }
        if (y>gpps[i][1]) 
        {
            tmp4=y-gpps[i][1];
        }
        else 
        {
            tmp4=gpps[i][1]-y;
        }
        if (gpps[i][1]>y && gpps[i][0]>x) 
        {        //1
            sin = asin(tmp3/dis);
            MindAngle = floatsub(floatsub(floatadd(sin, 90), floatmul(sin, 2)), -90.0);
        }
        if (gpps[i][1]<y && gpps[i][0]>x) 
        {        //2
            sin = asin(tmp3/dis);
            MindAngle = floatsub(floatadd(sin, 180), 180.0);
        }
        if (gpps[i][1]<y && gpps[i][0]<x) 
        {        //3
            sin = acos(tmp4/dis);
            MindAngle = floatsub(floatadd(sin, 360), floatmul(sin, 2));
        }
        if (gpps[i][1]>y && gpps[i][0]<x) 
        {        //4
            sin = asin(tmp3/dis);
            MindAngle = floatadd(sin, 180);
        }
    }
    if (MindAngle == 0.0) 
    {
        return angle2;
    } 
    else
    return MindAngle;
}

forward DriftSummary(playerid);
public DriftSummary(playerid)
{
    PlayerDriftPoints[playerid] = 0;

    GivePlayerMoney(playerid,DriftPointsNow[playerid]);
    DriftPointsNow[playerid] = 0;
    TextDrawSetString(DriftTD," ");

	new INI:File = INI_Open(Account_Path(playerid));
	INI_SetTag( File, "data" );
    INI_WriteInt(File, "Money", GetPlayerMoney(playerid));

	INI_Close( File );

}


Float:ReturnPlayerAngle(playerid)
{
    new Float:Ang;
    if (IsPlayerInAnyVehicle(playerid))GetVehicleZAngle(GetPlayerVehicleID(playerid), Ang); else GetPlayerFacingAngle(playerid, Ang);

    return Ang;
}

forward DriftCount();
public DriftCount()
{
    new Float:Angle1, Float:Angle2, Float:BySpeed, s[256];
    new Float:Z;
    new Float:X;
    new Float:Y;
    new Float:SpeedX;
    for(new g=0;g<200;g++) 
    {
        GetPlayerPos(g, X, Y, Z);
        SpeedX = floatsqroot(floatadd(floatadd(floatpower(floatabs(floatsub(X,SavedPos[ g ][ sX ])),2),floatpower(floatabs(floatsub(Y,SavedPos[ g ][ sY ])),2)),floatpower(floatabs(floatsub(Z,SavedPos[ g ][ sZ ])),2)));
        Angle1 = ReturnPlayerAngle(g);
        Angle2 = GetPlayerTheoreticAngle(g);
        BySpeed = floatmul(SpeedX, 12);
        if (GetPlayerState(g) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(g) && floatabs(floatsub(Angle1, Angle2)) > DRIFT_MIN_ANGLE && floatabs(floatsub(Angle1, Angle2)) < DRIFT_MAX_ANGLE && BySpeed > DRIFT_SPEED) 
        {
            if (PlayerDriftPoints[g] > 0)KillTimer(PlayerDriftPoints[g]);
            PlayerDriftPoints[g] = 0;
            DriftPointsNow[g] += floatval( floatabs(floatsub(Angle1, Angle2)) * 3 * (BySpeed*0.1) )/800;
            PlayerDriftPoints[g] = SetTimerEx("DriftSummary", 3000, false, "d", g);
        }
        if (DriftPointsNow[g] > 0) 
        {
            format(s, sizeof(s), "%d Drift Points", DriftPointsNow);
            TextDrawSetString(DriftTD, s);
        }
        SavedPos[ g ][ sX ] = X;
        SavedPos[ g ][ sY ] = Y;
        SavedPos[ g ][ sZ ] = Z;
    }
}

floatval(Float:val)
{
    new str[256];
    format(str, 256, "%.0f", val);
    return todec(str);
}

todec(const str[])
{
    return strval(str);
} 