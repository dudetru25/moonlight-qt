#include "nvapp.h"

#define SER_APPNAME "name"
#define SER_APPID "id"
#define SER_APPHDR "hdr"
#define SER_APPCOLLECTOR "appcollector"
#define SER_STREAMRESOLUTION "streamresolution"
#define SER_CLIENTDISPLAYMODE "clientdisplaymode"
#define SER_AUTOSPAWNFROM "autospawnfrom"
#define SER_APPWINDOWREADY "appwindowready"
#define SER_CLIENTAPPWINDOWSET "clientappwindowset"
#define SER_CLIENTAPPWINDOW "clientappwindow"
#define SER_CLIENTABSOLUTEMOUSESET "clientabsolutemouseset"
#define SER_CLIENTABSOLUTEMOUSE "clientabsolutemouse"
#define SER_HIDDEN "hidden"
#define SER_DIRECTLAUNCH "directlaunch"

NvApp::NvApp(QSettings& settings)
{
    name = settings.value(SER_APPNAME).toString();
    id = settings.value(SER_APPID).toInt();
    hdrSupported = settings.value(SER_APPHDR).toBool();
    isAppCollectorGame = settings.value(SER_APPCOLLECTOR).toBool();
    streamResolution = settings.value(SER_STREAMRESOLUTION).toString();
    clientDisplayMode = settings.value(SER_CLIENTDISPLAYMODE).toString();
    autoSpawnFrom = settings.value(SER_AUTOSPAWNFROM).toString();
    appWindowReady = settings.value(SER_APPWINDOWREADY).toBool();
    clientAppWindowSet = settings.value(SER_CLIENTAPPWINDOWSET).toBool();
    clientAppWindow = settings.value(SER_CLIENTAPPWINDOW).toBool();
    clientAbsoluteMouseSet = settings.value(SER_CLIENTABSOLUTEMOUSESET).toBool();
    clientAbsoluteMouse = settings.value(SER_CLIENTABSOLUTEMOUSE).toBool();
    hidden = settings.value(SER_HIDDEN).toBool();
    directLaunch = settings.value(SER_DIRECTLAUNCH).toBool();
}

void NvApp::serialize(QSettings& settings) const
{
    settings.setValue(SER_APPNAME, name);
    settings.setValue(SER_APPID, id);
    settings.setValue(SER_APPHDR, hdrSupported);
    settings.setValue(SER_APPCOLLECTOR, isAppCollectorGame);
    settings.setValue(SER_STREAMRESOLUTION, streamResolution);
    settings.setValue(SER_CLIENTDISPLAYMODE, clientDisplayMode);
    settings.setValue(SER_AUTOSPAWNFROM, autoSpawnFrom);
    settings.setValue(SER_APPWINDOWREADY, appWindowReady);
    settings.setValue(SER_CLIENTAPPWINDOWSET, clientAppWindowSet);
    settings.setValue(SER_CLIENTAPPWINDOW, clientAppWindow);
    settings.setValue(SER_CLIENTABSOLUTEMOUSESET, clientAbsoluteMouseSet);
    settings.setValue(SER_CLIENTABSOLUTEMOUSE, clientAbsoluteMouse);
    settings.setValue(SER_HIDDEN, hidden);
    settings.setValue(SER_DIRECTLAUNCH, directLaunch);
}
