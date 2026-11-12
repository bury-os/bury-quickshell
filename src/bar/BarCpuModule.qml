import Quickshell
import QtQuick
import Quickshell.Io
import "../themeing"
import "../themeing/colors.js" as Colors

Rectangle {
  required property Theme theme

  property int cpuUsage: 0
  property int gpuUsage: 0
  property var lastCpuIdle: 0
  property var lastCpuTotal: 0

  color: hover.hovering ? Colors.highlight(theme.scheme.background, theme.scheme.isDarkMode) : theme.scheme.background
  implicitWidth: stats.width
  height: parent.height

  Text {
    id: stats
    text: ` 󰍛  CPU: ${cpuUsage}% GPU: ${gpuUsage}% `
    color: theme.scheme.foreground
    font: theme.fontMono
    height: parent.height
    verticalAlignment: Text.AlignVCenter

    anchors {
      right: parent.right
    }

    Process {
      id: cpuProc
      command: ["sh", "-c", "head -1 /proc/stat"]

      stdout: SplitParser {
        onRead: data => {
          var p = data.trim().split(/\s+/)
          var idle = parseInt(p[4]) + parseInt(p[5])
          var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)

          if (lastCpuTotal > 0) {
            cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)))
          }

          lastCpuTotal = total
          lastCpuIdle = idle
        }
      }

      Component.onCompleted: running = true
    }

    Process {
      id: gpuProc
      command: ["sh", "-c", "nvidia-smi --query-gpu=name,utilization.gpu --format=csv,noheader,nounits"]

      stdout: SplitParser {
        onRead: data => {
          const values = data.trim().split(',')
          const name = values[0].trim()
          const gpuUtilization = values[1].trim()

          gpuUsage = parseInt(gpuUtilization)
        }
      }

      Component.onCompleted: running = true
    }

    Timer {
      interval: 2000
      running: true
      repeat: true
      onTriggered: {
        cpuProc.running = true
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
    onClicked: console.log('CPU module clicked')
  }
}
