#include <ysilib\YSI_Coding\y_hooks>

new Blinker[MAX_VEHICLES];
new BlinkerObject[MAX_VEHICLES];
new BlinkerState[MAX_VEHICLES]; // Track blinker state separately

new
    Blinkers[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
    Blinkers[playerid] = 0;

    return 1;
}

YCMD:blinkers(playerid, params[], help)
{
    new veh = GetPlayerVehicleID(playerid);
   
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"You are not in a vehicle!");
    
    if(BlinkerState[veh] == 0)
    {
        Blinker[veh] = 1;
        BlinkerObject[veh] = CreateObject(18646, 10.0, 10.0, 10.0, 0, 0, 0);
        AttachObjectToVehicle(BlinkerObject[veh], veh, 0.0, 0.75, 0.275, 0.0, 0.1, 0.0);
        BlinkerState[veh] = 1; // Update blinker state
    }
    else
    {
        if(BlinkerObject[veh] != INVALID_OBJECT_ID) // Check if the object id is valid
        {
            DestroyObject(BlinkerObject[veh]); // Destroy the object
            BlinkerObject[veh] = INVALID_OBJECT_ID; // Set object id to invalid
            BlinkerState[veh] = 0; // Update blinker state
        }
    }
    SendClientMessage(playerid, -1, ""color_server"NordKapp : "color_white"Blinker State : "color_yellow"%s", (BlinkerState[veh] == 0) ? "OFF" : "ON");
    
    return 1;
}
