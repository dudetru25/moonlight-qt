#pragma once

#include <QSettings>
#include <QString>

class NvApp
{
public:
    NvApp() {}
    explicit NvApp(QSettings& settings);

    bool operator==(const NvApp& other) const
    {
        return id == other.id &&
                name == other.name &&
                hdrSupported == other.hdrSupported &&
                isAppCollectorGame == other.isAppCollectorGame &&
                streamResolution == other.streamResolution &&
                clientDisplayMode == other.clientDisplayMode &&
                autoSpawnFrom == other.autoSpawnFrom &&
                appWindowReady == other.appWindowReady &&
                clientAppWindowSet == other.clientAppWindowSet &&
                clientAppWindow == other.clientAppWindow &&
                clientAbsoluteMouseSet == other.clientAbsoluteMouseSet &&
                clientAbsoluteMouse == other.clientAbsoluteMouse &&
                hidden == other.hidden &&
                directLaunch == other.directLaunch;
    }

    bool operator!=(const NvApp& other) const
    {
        return !operator==(other);
    }

    bool isInitialized()
    {
        return id != 0 && !name.isEmpty();
    }

    void
    serialize(QSettings& settings) const;

    int id = 0;
    QString name;
    QString streamResolution;
    QString clientDisplayMode;
    QString autoSpawnFrom;
    bool hdrSupported = false;
    bool isAppCollectorGame = false;
    bool appWindowReady = false;
    bool clientAppWindowSet = false;
    bool clientAppWindow = false;
    bool clientAbsoluteMouseSet = false;
    bool clientAbsoluteMouse = false;
    bool hidden = false;
    bool directLaunch = false;
};

Q_DECLARE_METATYPE(NvApp)
