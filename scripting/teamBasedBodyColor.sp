#include <sdktools>
#include <sdkhooks>

#define INVALID_COLOR_RED 1
#define INVALID_COLOR_GREEN 2
#define INVALID_COLOR_BLUE 3
#define INVALID_COLOR_ALPHA 4
#define INVALID_TEAM_ID 5
#define NOT_ENOUGH_ARGUMENTS 6

#define PLUGIN_VERSION "0.0.1"
#pragma newdecls required;

int g_iColorT[4] = {0, 0, 0, 0};
int g_iColorCT[4] = {0, 0, 0, 0};
bool g_bLoading;

public Plugin myinfo =
{
    name = "Team based body color",
    author = "faketuna",
    description = "The simple plugin to colorize models by player team.",
    version = PLUGIN_VERSION,
    url = "https://short.f2a.dev/s/github"
};

ConVar g_hPluginEnabled;
ConVar g_hColorT;
ConVar g_hColorCT;

public void OnPluginStart() {
    g_hPluginEnabled = CreateConVar("sm_team_color_enabled", "0", "Enable/Disable team based body color.");
    g_hColorT = CreateConVar("sm_team_color_t", "255 150 150 100", "The color of T. Specify with RGBA.");
    g_hColorCT = CreateConVar("sm_team_color_ct", "150 150 255 100", "The color of CT. Specify with RGBA.");
    HookEvent("player_spawn", OnPlayerSpawned, EventHookMode_Post);
    HookConVarChange(g_hColorT, OnTColorChanged);
    HookConVarChange(g_hColorCT, OnCTColorChanged);
    g_bLoading = true;
    AutoExecConfig(true, "teamBasedBodyColor");
}

public void OnConfigsExecuted() {
    char check[17];
    GetConVarString(g_hColorT, check, sizeof(check));
    int status = SetTeamColor(check, 2);
    switch(status) {
        case NOT_ENOUGH_ARGUMENTS:
            SetFailState("sm_team_color_t has not enough arguments or too much arguments! Check your plugin config!");
        case INVALID_COLOR_RED:
            SetFailState("The value of red color in sm_team_color_t is invalid! Check your plugin config!");
        case INVALID_COLOR_GREEN:
            SetFailState("The value of green color in sm_team_color_t is invalid! Check your plugin config!");
        case INVALID_COLOR_BLUE:
            SetFailState("The value of blue color in sm_team_color_t is invalid! Check your plugin config!");
        case INVALID_COLOR_ALPHA:
            SetFailState("The value of alpha in sm_team_color_t is invalid! Check your plugin config!");
    }
    GetConVarString(g_hColorCT, check, sizeof(check));
    status = SetTeamColor(check, 3);
    switch(status) {
        case NOT_ENOUGH_ARGUMENTS:
            SetFailState("sm_team_color_ct has not enough arguments or too much arguments! Check your plugin config!");
        case INVALID_COLOR_RED:
            SetFailState("The value of red color in sm_team_color_ct is invalid! Check your plugin config!");
        case INVALID_COLOR_GREEN:
            SetFailState("The value of green color in sm_team_color_ct is invalid! Check your plugin config!");
        case INVALID_COLOR_BLUE:
            SetFailState("The value of blue color in sm_team_color_ct is invalid! Check your plugin config!");
        case INVALID_COLOR_ALPHA:
            SetFailState("The value of alpha in sm_team_color_ct is invalid! Check your plugin config!");
    }
    g_bLoading = false;
}

public void OnTColorChanged(ConVar convar, const char[] oldValue, const char[] newValue) {
    if (g_bLoading) {
        return;
    }
    int check = SetTeamColor(newValue, 2);
    switch(check){
        case NOT_ENOUGH_ARGUMENTS: {
            PrintToServer("Tring to change color convar with not enough arguments!");
            PrintToServer("Revert to old value! %s", oldValue);
            SetConVarString(g_hColorT, oldValue);
            return;
        }
        case INVALID_COLOR_RED: {
            PrintToServer("Tring to change color convar with invalid red value!");
            PrintToServer("Revert to old value! %s", oldValue);
            SetConVarString(g_hColorT, oldValue);
            return;
        }
        case INVALID_COLOR_GREEN: {
            PrintToServer("Tring to change color convar with invalid green value!");
            PrintToServer("Revert to old value! %s", oldValue);
            SetConVarString(g_hColorT, oldValue);
            return;
        }
        case INVALID_COLOR_BLUE: {
            PrintToServer("Tring to change color convar with invalid blue value!");
            PrintToServer("Revert to old value! %s", oldValue);
            SetConVarString(g_hColorT, oldValue);
            return;
        }
        case INVALID_COLOR_ALPHA: {
            PrintToServer("Tring to change color convar with invalid alpha value!");
            PrintToServer("Revert to old value! %s", oldValue);
            SetConVarString(g_hColorT, oldValue);
            return;
        }
    }

}

public void OnCTColorChanged(ConVar convar, const char[] oldValue, const char[] newValue) {
    if (g_bLoading) {
        return;
    }
    int check = SetTeamColor(newValue, 3);
    switch(check){
        case NOT_ENOUGH_ARGUMENTS: {
            PrintToServer("Tring to change color convar with not enough arguments!");
            PrintToServer("Revert to old value! %s", oldValue);
            SetConVarString(g_hColorCT, oldValue);
            return;
        }
        case INVALID_COLOR_RED: {
            PrintToServer("Tring to change color convar with invalid red value!");
            PrintToServer("Revert to old value! %s", oldValue);
            SetConVarString(g_hColorCT, oldValue);
            return;
        }
        case INVALID_COLOR_GREEN: {
            PrintToServer("Tring to change color convar with invalid green value!");
            PrintToServer("Revert to old value! %s", oldValue);
            SetConVarString(g_hColorCT, oldValue);
            return;
        }
        case INVALID_COLOR_BLUE: {
            PrintToServer("Tring to change color convar with invalid blue value!");
            PrintToServer("Revert to old value! %s", oldValue);
            SetConVarString(g_hColorCT, oldValue);
            return;
        }
        case INVALID_COLOR_ALPHA: {
            PrintToServer("Tring to change color convar with invalid alpha value!");
            PrintToServer("Revert to old value! %s", oldValue);
            SetConVarString(g_hColorCT, oldValue);
            return;
        }
    }
}

public void OnPlayerSpawned(Handle event, const char[] name, bool dontBroadcast) {
    if(!GetConVarBool(g_hPluginEnabled)) {
        return;
    }

    int client = GetClientOfUserId(GetEventInt(event, "userid"));

    if(IsFakeClient(client)) {
        return;
    }

    if(GetClientTeam(client) == 2) {
        SetEntityRenderColor(client, g_iColorT[0], g_iColorT[1], g_iColorT[2], g_iColorT[3]);
    }
    else if(GetClientTeam(client) == 3) {
        SetEntityRenderColor(client, g_iColorCT[0], g_iColorCT[1], g_iColorCT[2], g_iColorCT[3]);
    }
}

int SetTeamColor(const char[] conVarValue, int teamID) {
    char cBuff[5][4];
    int colors = ExplodeString(conVarValue, " ", cBuff, 4, 4);
    if(colors < 4 || colors > 4) {
        return NOT_ENOUGH_ARGUMENTS;
    }

    int check = -1;
    bool onlyNumber = true;
    check = StringToInt(cBuff[0]);
    onlyNumber = true;
    for(int i = 0; i < strlen(cBuff[0]); i++) {
        if (!IsCharNumeric(cBuff[0][i])) {
            onlyNumber = false;
            break;
        }
    }
    if(check > 255 || check < 0 || check == 0 && !StrEqual(cBuff[0], "0")) {
        return INVALID_COLOR_RED;
    }

    check = StringToInt(cBuff[1]);
    onlyNumber = true;
    for(int i = 0; i < strlen(cBuff[1]); i++) {
        if (!IsCharNumeric(cBuff[1][i])) {
            onlyNumber = false;
            break;
        }
    }
    if(check > 255 || check < 0 || check == 0 && !StrEqual(cBuff[1], "0")) {
        return INVALID_COLOR_GREEN;
    }

    check = StringToInt(cBuff[2]);
    onlyNumber = true;
    for(int i = 0; i < strlen(cBuff[2]); i++) {
        if (!IsCharNumeric(cBuff[2][i])) {
            onlyNumber = false;
            break;
        }
    }
    if(check > 255 || check < 0 || check == 0 && !StrEqual(cBuff[2], "0")) {
        return INVALID_COLOR_BLUE;
    }

    check = StringToInt(cBuff[3]);
    onlyNumber = true;
    for(int i = 0; i < strlen(cBuff[3]); i++) {
        if (!IsCharNumeric(cBuff[3][i])) {
            onlyNumber = false;
            break;
        }
    }
    if(check > 255 || check < 0 || !onlyNumber) {
        return INVALID_COLOR_ALPHA;
    }

    if(teamID == 2) {
        g_iColorT[0] = StringToInt(cBuff[0])
        g_iColorT[1] = StringToInt(cBuff[1])
        g_iColorT[2] = StringToInt(cBuff[2])
        g_iColorT[3] = StringToInt(cBuff[3])
    }
    else if(teamID == 3) {
        g_iColorCT[0] = StringToInt(cBuff[0])
        g_iColorCT[1] = StringToInt(cBuff[1])
        g_iColorCT[2] = StringToInt(cBuff[2])
        g_iColorCT[3] = StringToInt(cBuff[3])
    }
    else {
        return INVALID_TEAM_ID;
    }
    return 0;
}