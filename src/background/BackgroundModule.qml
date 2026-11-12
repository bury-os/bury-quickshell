import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import qs.modules.common

Variants {
  id: root
  model: Quickshell.screens

  property string wallpaper

  PanelWindow {
    id: panelRoot
    required property var modelData

    screen: modelData
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Bottom
    WlrLayershell.namespace: "quickshell:background"
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"

    StyledImage {
      anchors.fill: parent
      source: wallpaper
      fillMode: Image.PreserveAspectCrop
      fallbacks: [
        // TODO: absolute file path
        "bg_garden.jpeg"
      ]
    }
  }
}