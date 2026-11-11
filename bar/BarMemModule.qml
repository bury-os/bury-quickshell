import Quickshell
import QtQuick
import Quickshell.Io
import "../themeing"
import "../themeing/colors.js" as Colors

Rectangle {
  required property Theme theme

  property int memUsage: 0
  property int gpuMemUsage: 0

  color: hover.hovering ? Colors.highlight(theme.scheme.background, theme.scheme.isDarkMode) : theme.scheme.background
  implicitWidth: stats.width
  height: parent.height

  Text {
    id: stats
    text: ` 󰧑  RAM: ${memUsage}% VRAM: ${gpuMemUsage}% `
    color: theme.scheme.foreground
    font: theme.fontMono
    height: parent.height
    verticalAlignment: Text.AlignVCenter

    Process {
      id: memProc
      command: ["sh", "-c", "free | grep Mem"]

      stdout: SplitParser {
        onRead: data => {
          var parts = data.trim().split(/\s+/)
          var total = parseInt(parts[1]) || 1
          var used = parseInt(parts[2]) || 0
          memUsage = Math.round(100 * used / total)
        }
      }

      Component.onCompleted: running = true
    }

    Process {
      id: gpuProc
      command: ["sh", "-c", "nvidia-smi --query-gpu=name,memory.used,memory.total --format=csv,noheader,nounits"]

      stdout: SplitParser {
        onRead: data => {
          const values = data.trim().split(',')
          const name = values[0].trim()
          const vramUsed = values[1].trim()
          const vramTotal = values[2].trim()

          gpuMemUsage = (vramUsed / vramTotal) * 100
        }
      }

      Component.onCompleted: running = true
    }

    Timer {
      interval: 2000
      running: true
      repeat: true
      onTriggered: {
        memProc.running = true
        gpuProc.running = true
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
    onClicked: console.log('Memory module clicked')
  }
}
