//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "./modules/common"
import "./notifications"
import "./background"
import "./themeing"
import "./bar"
import "./material.js" as Mat

ShellRoot {
  readonly property string primaryMonitor: Quickshell.env('QS_MONITOR_PRIMARY') || 'DP-3'

  Theme {
    id: theme
    fontRegular: Mat.fonts.regular
    fontMono: Mat.fonts.mono
    scheme: ColorScheme {
      isDarkMode: true
      foreground: Mat.colors.grey['50']
      background: Mat.colors.grey['900']
      primary: Mat.colors.teal['500']
      accent: Mat.colors.pink['500']
      error: Mat.colors.red['500']
      warning: Mat.colors.amber['500']
      success: Mat.colors.teal['500']
    }
  }

  NotificationModule {
    theme: theme
    config: NotificationConfig {
      timeout: 5000
      width: 500
    }
  }

  BackgroundModule { }

  PanelWindow {
    id: topPanel
    exclusiveZone: 30
    screen: Quickshell.screens.find(s => s.name === primaryMonitor)
    implicitHeight: 40
    color: theme.scheme.background

    anchors {
      top: true
      left: true
      right: true
    }

    RowLayout {
      anchors {
        fill: parent
      }

      BarDateModule { theme: theme }

      Item { Layout.fillWidth: true }

      HyprlandWindowModule { theme: theme }

      BarSystemTrayModule {
        theme: theme
        parentWindow: topPanel
      }

      BarSeparator { theme: theme }

      BarCpuModule { theme: theme }

      BarSeparator { theme: theme }

      BarMemModule { theme: theme }
    }
  }
}
