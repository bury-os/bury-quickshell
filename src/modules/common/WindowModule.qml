import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  enum WindowState { None = 0, Floating = 1, Tiled = 2, PseudoTiled = 4 }
  enum DisplayServer { None = 0, Wayland = 1, XWayland = 2 }

  property string activeWindowApplication: ''
  property string activeWindowTitle: ''
  property int activeWindowState: 0
  property int activeDisplayServer: 0

  function getDisplayServerIcon() {
    console.log('here!')

    switch(activeDisplayServer) {
      case root.DisplayServer.Wayland:
        return ''
      case root.DisplayServer.XWayland:
        return ''
      default:
        return '?'
    }
  }

  Process {
    id: windowProc
    command: ["sh", "-c", "hyprctl activewindow -j | jq -r '[.initialTitle,.title,.xwayland,.floating] | join(\"_,_\")'"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) {
          activeWindowApplication = ''
          activeWindowTitle = ''
          activeWindowState = 0
          activeDisplayServer = 0

          return
        }

        const segments = data.split('_,_')
        const applicationSegment = segments[0]
        const titleSegment = segments[1]

        // This is kind of a hack, try to distinguish the window title from the application itself
        if (titleSegment.includes(applicationSegment)) {
          activeWindowTitle = titleSegment
            .replace(`${applicationSegment} - `, '')
            .replace(` — ${applicationSegment}`, '')
            .split('-')[0].trim()
        } else {
          activeWindowTitle = titleSegment.split('-')[0].trim()
        }

        // TODO: these checks don't cover everything
        activeDisplayServer = segments[2] === 'true'
          ? 2
          : 1

        activeWindowState = segments[3] === 'true'
          ? 1
          : 2
      }
    }
    Component.onCompleted: running = true
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