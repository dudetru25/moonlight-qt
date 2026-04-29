import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

import AppModel 1.0
import ComputerManager 1.0
import SdlGamepadKeyNavigation 1.0

Item {
    property int computerIndex
    property AppModel appModel: createModel()
    property bool activated
    property bool showHiddenGames
    property bool showGames

    id: appView
    focus: true
    activeFocusOnTab: true

    function computerLost()
    {
        stackView.pop()
    }

    function createModel()
    {
        var model = Qt.createQmlObject('import AppModel 1.0; AppModel {}', appView, '')
        model.initialize(ComputerManager, computerIndex, showHiddenGames)
        return model
    }

    function launchApp(appIndex, appName, appId, running, quitExistingApp)
    {
        var runningId = appModel.getRunningAppId()
        if (runningId !== 0 && runningId !== appId) {
            if (quitExistingApp) {
                quitAppDialog.appName = appModel.getRunningAppName()
                quitAppDialog.segueToStream = true
                quitAppDialog.nextAppName = appName
                quitAppDialog.nextAppIndex = appIndex
                quitAppDialog.open()
            }

            return
        }

        var component = Qt.createComponent("StreamSegue.qml")
        var segue = component.createObject(stackView, {
                                               "appName": appName,
                                               "session": appModel.createSessionForApp(appIndex),
                                               "isResume": runningId === appId || running
                                           })
        stackView.push(segue)
    }

    StackView.onActivated: {
        appModel.computerLost.connect(computerLost)
        activated = true

        if (appList.currentIndex === -1 && SdlGamepadKeyNavigation.getConnectedGamepads() > 0) {
            appList.currentIndex = 0
        }

        if (!showGames && !showHiddenGames) {
            var directLaunchAppIndex = appModel.getDirectLaunchAppIndex()
            if (directLaunchAppIndex >= 0) {
                appList.currentIndex = directLaunchAppIndex
                if (appList.currentItem) {
                    appList.currentItem.launchOrResumeSelectedApp(false)
                }
                showGames = true
            }
        }
    }

    StackView.onDeactivating: {
        appModel.computerLost.disconnect(computerLost)
        activated = false
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 38
            spacing: 16

            Item {
                Layout.preferredWidth: 52
            }

            Label {
                Layout.fillWidth: true
                text: qsTr("Name")
                color: "#BDBDBD"
                font.pixelSize: 14
                font.bold: true
            }

            Label {
                Layout.preferredWidth: 140
                text: qsTr("Type")
                color: "#BDBDBD"
                font.pixelSize: 14
                font.bold: true
            }

            Label {
                Layout.preferredWidth: 130
                text: qsTr("Resolution")
                color: "#BDBDBD"
                font.pixelSize: 14
                font.bold: true
            }

            Item {
                Layout.preferredWidth: 52
            }
        }

        ListView {
            id: appList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: appModel
            clip: true
            focus: true
            activeFocusOnTab: true
            currentIndex: -1
            boundsBehavior: Flickable.OvershootBounds
            section.property: "category"
            section.criteria: ViewSection.FullString
            section.delegate: Rectangle {
                width: appList.width
                height: 34
                color: "#242424"

                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    text: section
                    color: "#E0E0E0"
                    font.pixelSize: 16
                    font.bold: true
                }
            }

            delegate: ItemDelegate {
                id: appRow
                width: appList.width
                height: 62
                highlighted: appList.activeFocus && ListView.isCurrentItem
                opacity: model.hidden ? 0.4 : 1.0

                property alias appContextMenu: appContextMenuLoader.item

                function launchOrResumeSelectedApp(quitExistingApp)
                {
                    appView.launchApp(index, model.name, model.appid, model.running, quitExistingApp)
                }

                function doQuitGame()
                {
                    quitAppDialog.appName = appModel.getRunningAppName()
                    quitAppDialog.segueToStream = false
                    quitAppDialog.open()
                }

                onClicked: launchOrResumeSelectedApp(true)
                onPressAndHold: {
                    if (appContextMenu.popup) {
                        appContextMenu.popup()
                    } else {
                        appContextMenu.open()
                    }
                }

                Keys.onReturnPressed: launchOrResumeSelectedApp(true)
                Keys.onEnterPressed: launchOrResumeSelectedApp(true)
                Keys.onMenuPressed: appContextMenu.open()
                Keys.onUpPressed: {
                    if (appList.currentIndex === 0) {
                        nextItemInFocusChain(false).forceActiveFocus(Qt.TabFocus)
                    } else {
                        appList.decrementCurrentIndex()
                    }
                }
                Keys.onDownPressed: appList.incrementCurrentIndex()

                Rectangle {
                    anchors.fill: parent
                    color: appRow.highlighted ? "#343B63" : (index % 2 === 0 ? "#303030" : "#2B2B2B")
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 16

                    RoundButton {
                        Layout.preferredWidth: 44
                        Layout.preferredHeight: 44
                        focusPolicy: Qt.NoFocus
                        icon.source: "qrc:/res/play_arrow_FILL1_wght700_GRAD200_opsz48.svg"
                        icon.width: 30
                        icon.height: 30
                        Material.background: model.running ? "#4B6A28" : "#3F51B5"
                        onClicked: launchOrResumeSelectedApp(true)
                        ToolTip.text: model.running ? qsTr("Resume") : qsTr("Launch")
                        ToolTip.delay: 750
                        ToolTip.timeout: 2500
                        ToolTip.visible: hovered
                    }

                    Label {
                        Layout.fillWidth: true
                        text: model.name
                        color: "#FFFFFF"
                        font.pixelSize: 20
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    Label {
                        Layout.preferredWidth: 140
                        text: model.mode
                        color: "#D0D0D0"
                        font.pixelSize: 15
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    Label {
                        Layout.preferredWidth: 130
                        text: model.resolution
                        color: "#D0D0D0"
                        font.pixelSize: 15
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    RoundButton {
                        Layout.preferredWidth: 44
                        Layout.preferredHeight: 44
                        visible: model.running
                        focusPolicy: Qt.NoFocus
                        icon.source: "qrc:/res/stop_FILL1_wght700_GRAD200_opsz48.svg"
                        icon.width: 30
                        icon.height: 30
                        Material.background: "#7A2C2C"
                        onClicked: doQuitGame()
                        ToolTip.text: qsTr("Stop")
                        ToolTip.delay: 750
                        ToolTip.timeout: 2500
                        ToolTip.visible: hovered
                    }

                    Item {
                        Layout.preferredWidth: model.running ? 0 : 44
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    propagateComposedEvents: true
                    onClicked: appRow.pressAndHold()
                }

                Loader {
                    id: appContextMenuLoader
                    asynchronous: true
                    sourceComponent: NavigableMenu {
                        id: appContextMenu
                        initiator: appContextMenuLoader.parent
                        NavigableMenuItem {
                            text: model.running ? qsTr("Resume") : qsTr("Launch")
                            onTriggered: launchOrResumeSelectedApp(true)
                        }
                        NavigableMenuItem {
                            text: qsTr("Stop")
                            onTriggered: doQuitGame()
                            visible: model.running
                        }
                        NavigableMenuItem {
                            checkable: true
                            checked: model.directLaunch
                            text: qsTr("Direct Launch")
                            onTriggered: appModel.setAppDirectLaunch(index, !model.directLaunch)
                            enabled: !model.hidden
                        }
                        NavigableMenuItem {
                            checkable: true
                            checked: model.hidden
                            text: qsTr("Hide")
                            onTriggered: appModel.setAppHidden(index, !model.hidden)
                            enabled: model.hidden || (!model.running && !model.directLaunch)
                        }
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {}
        }
    }

    Row {
        anchors.centerIn: parent
        spacing: 5
        visible: appList.count === 0

        Label {
            text: qsTr("This computer doesn't seem to have any applications or some applications are hidden")
            font.pointSize: 20
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
        }
    }

    NavigableMessageDialog {
        id: quitAppDialog
        property string appName: ""
        property bool segueToStream: false
        property string nextAppName: ""
        property int nextAppIndex: 0
        text: qsTr("Are you sure you want to quit %1? Any unsaved progress will be lost.").arg(appName)
        standardButtons: Dialog.Yes | Dialog.No

        function quitApp() {
            var component = Qt.createComponent("QuitSegue.qml")
            var params = {"appName": appName, "quitRunningAppFn": function() { appModel.quitRunningApp() }}
            if (segueToStream) {
                params.nextAppName = nextAppName
                params.nextSession = appModel.createSessionForApp(nextAppIndex)
            } else {
                params.nextAppName = null
                params.nextSession = null
            }

            stackView.push(component.createObject(stackView, params))
        }

        onAccepted: quitApp()
    }
}
