import Quickshell
import QtQuick
import Quickshell.Io
import "../themeing"
import "../themeing/colors.js" as Colors

Rectangle {
  required property Theme theme

  property string time: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")

  color: hover.hovering ? Colors.highlight(theme.scheme.background, theme.scheme.isDarkMode) : theme.scheme.background
  implicitWidth: clock.width
  height: parent.height

  Text {
    id: clock
    text: `       ${time}    `
    color: theme.scheme.foreground
    font: theme.fontRegular
    verticalAlignment: Text.AlignVCenter
    height: parent.height

    Timer {
      interval: 1000
      running: true
      repeat: true
      onTriggered: time = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
    }
  }

  MouseArea {
    id: hover
    property bool hovering: false

    anchors.fill: parent
    hoverEnabled: true
    onEntered: hovering = true
    onExited: hovering = false
    onClicked: console.log('Date module clicked')
  }
}
