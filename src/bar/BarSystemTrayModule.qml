import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Services.SystemTray
import "../themeing"
import "../themeing/colors.js" as Colors

Rectangle {
  required property Theme theme
  required property PanelWindow parentWindow

  color: theme.scheme.background
  implicitWidth: tray.width
  height: parent.height

  Row {
    id: tray
    spacing: 12
    height: parent.height

    Repeater {
      model: SystemTray.items

      delegate: Item {
        required property var modelData
        width: 20
        height: 20
        anchors.verticalCenter: parent.verticalCenter

        Image {
          anchors.fill: parent
          anchors.centerIn: parent
          source: modelData.icon
          fillMode: Image.PreserveAspectFit
        }

        MouseArea {
          id: area
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

          onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
              modelData.activate()
            } else if (mouse.button === Qt.MiddleButton) {
              modelData.secondaryActivate()
            } else if (mouse.button === Qt.RightButton) {
              if (modelData.hasMenu) {
                const position = parent.mapToItem(parentWindow.contentItem, 0, parent.height)
                modelData.display(parentWindow, position.x, 24)
              }
            }
          }
        }
      }
    }
  }
}
