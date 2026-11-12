import Quickshell
import QtQuick
import "../themeing"

Item {
  required property Theme theme

  width: theme.fontRegular.pixelSize
  height: theme.fontRegular.pixelSize

  Rectangle {
    height: parent.height
    width: 2
    color: theme.scheme.accent
    anchors.horizontalCenter: parent.horizontalCenter
  }
}
