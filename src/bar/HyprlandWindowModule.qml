import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Hyprland
import qs.modules.common
import "../themeing"
import "../themeing/colors.js" as Colors

Rectangle {
  required property Theme theme

  property string application: ''
  property string title: ''
  property bool isWayland: true
  property bool isFloating: false

  anchors {
    centerIn: parent
  }

  implicitWidth: text.width
  height: parent.height

  color: hover.hovering ? Colors.highlight(theme.scheme.background, theme.scheme.isDarkMode) : theme.scheme.background

  Text {
    id: text
    text: `    ${isWayland ? '': ''}      ${isFloating ? '󰆟' : '󰕰'}    ${application} — ${title}    `
    font: theme.fontRegular
    color: theme.scheme.foreground
    height: parent.height
    verticalAlignment: Text.AlignVCenter

    Process {
      id: windowProc
      command: ["sh", "-c", "hyprctl activewindow -j | jq -r '[.initialTitle,.title,.xwayland,.floating] | join(\"_,_\")'"]
      stdout: SplitParser {
        onRead: data => {
          if (!data) {
            application = ''
            title = ''
            isWayland = true
            isFloating = false

            return
          }

          const segments = data.split('_,_')
          application = segments[0]
          const titleSegment = segments[1]

          if (titleSegment.includes(application)) {
            title = titleSegment
              .replace(`${application} - `, '')
              .replace(` — ${application}`, '')
              .split('-')[0].trim()
          } else {
            title = titleSegment.split('-')[0].trim()
          }

          isWayland = segments[2] === 'false'
          isFloating = segments[3] === 'true'
        }
      }
      Component.onCompleted: running = true
    }

    MouseArea {
      hoverEnabled: true
      anchors.fill: parent
      onClicked: console.log('yo')
    }

    Timer {
      interval: 200
      running: true
      repeat: true
      onTriggered: {
        windowProc.running = true
      }
    }
  }

  MouseArea {
    id: hover
    property bool hovering: false

    anchors.fill: parent
    hoverEnabled: true
    onEntered: hovering = true
    onExited: hovering = false
    onClicked: console.log('hello')
  }
}

