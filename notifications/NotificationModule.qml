import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import Quickshell.Io
import QtQuick.Layouts

import "../themeing/colors.js" as Colors
import "../themeing"

Item {
  required property Theme theme
  required property NotificationConfig config

  // Is notification center open
  property bool centerOpen: false

  // Show ephemeral notifications
  property bool showEmphemeral: true

  // Notification center history
  ListModel { id: history }

  NotificationServer {
    id: server
    actionsSupported: true
    bodySupported: true
    imageSupported: true

    onNotification: n => {
      history.insert(0, {
        summary: n.summary,
        body: n.body,
        appName: n.appName,
        urgency: n.urgency,
        image: n.image || n.appIcon || '',
        time: Qt.formatDateTime(new Date(), 'HH:mm')
      })
      n.tracked = true
    }
  }

  IpcHandler {
    target: 'notifications'

    function toggle(): void {
      centerOpen = !centerOpen
    }

    function open(): void {
      centerOpen = true
    }

    function close(): void {
      centerOpen = false
    }
  }

  // Notifications
  PanelWindow {
    visible: showEmphemeral
    anchors {
      top: true
      right: true
    }
    margins {
      top: 12
      right: 12
    }

    implicitWidth: config.width
    implicitHeight: Math.max(1, column.implicitHeight)
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    ColumnLayout {
      id: column
      width: parent.width
      spacing: 10

      Repeater {
        model: server.trackedNotifications

        delegate: Rectangle {
          required property var modelData

          id: card
          Layout.fillWidth: true
          Layout.preferredHeight: layout.implicitHeight + 20
          radius: 8
          color: cardArea.isMouseHovering ? Colors.highlight(theme.scheme.background, theme.scheme.isDarkMode) : theme.scheme.background
          border.width: 2
          border.color: modelData.urgency === NotificationUrgency.Critical
            ? theme.scheme.error : theme.scheme.foreground

          Timer {
            running: modelData.urgency !== NotificationUrgency.Critical
            interval: config.timeout
            onTriggered: card.modelData.dismiss()
          }

          RowLayout {
            id: layout
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Image {
              Layout.preferredHeight: 36
              Layout.preferredWidth: 36
              Layout.alignment: Qt.AlignTop
              fillMode: Image.PreserveAspectFit
              visible: source.toString() !== ''
              source: card.modelData.image || card.modelData.appIcon || ''
            }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 2

              Text {
                Layout.fillWidth: true
                text: card.modelData.summary
                color: theme.scheme.foreground
                elide: Text.ElideRight
                font {
                  family: theme.fontRegular.family
                  pixelSize: theme.fontRegular.pixelSize + 2
                  bold: true
                }
              }

              Text {
                Layout.fillWidth: true
                visible: card.modelData.body !== ''
                text: card.modelData.body
                color: theme.scheme.foreground
                wrapMode: Text.WordWrap
                font {
                  family: theme.fontRegular.family
                  pixelSize: theme.fontRegular.pixelSize
                  italic: true
                }
              }
            }
          }

          MouseArea {
            property bool isMouseHovering: false
            id: cardArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: isMouseHovering = true
            onExited: isMouseHovering = false
            onClicked: card.modelData.dismiss()
          }
        }
      }
    }
  }

  // Notification center
  PanelWindow {
    visible: centerOpen
    anchors {
      top: true
      right: true
    }
    margins {
      top: 12
      right: 12
    }

    implicitWidth: config.width
    implicitHeight: centerCol.implicitHeight + 24
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    Rectangle {
      anchors.fill: parent
      radius: 8
      color: theme.scheme.background

      border {
        width: 2
        color: theme.scheme.foreground
      }

      ColumnLayout {
        id: centerCol
        spacing: 10
        anchors {
          left: parent.left
          right: parent.right
          top: parent.top
          margins: 12
        }

        RowLayout {
          Layout.fillWidth: true

          Text {
            Layout.fillWidth: true
            text: 'Notifications'
            color: theme.scheme.foreground
            font {
              family: theme.fontRegular.family
              pixelSize: theme.fontRegular.pixelSize + 2
              bold: true
            }
          }

          Rectangle {
            visible: history.count > 0
            color: clearButton.hovering ? theme.scheme.accent : theme.scheme.background
            implicitWidth: clearLabel.implicitWidth + 20
            implicitHeight: clearLabel.implicitHeight + 16
            radius: 6

            border {
              width: 2
              color: theme.scheme.accent
            }

            Text {
              id: clearLabel
              text: '  CLEAR'
              color: clearButton.hovering ? Colors.highlight(theme.scheme.foreground, theme.scheme.isDarkMode) : theme.scheme.foreground
              horizontalAlignment: Text.AlignCenter
              verticalAlignment: Text.AlignVCenter
              anchors {
                centerIn: parent
                margins: 10
              }
              font {
                family: theme.fontRegular.family
                pixelSize: theme.fontRegular.pixelSize
              }
            }

            MouseArea {
              id: clearButton
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              anchors.fill: parent
              onEntered: hovering = true
              onExited: hovering = false
              onClicked: history.clear()
              property bool hovering: false
            }
          }

          Rectangle {
            visible: history.count > 0
            color: closeButton.hovering ? theme.scheme.foreground : theme.scheme.background
            implicitWidth: closeLabel.implicitWidth + 20
            radius: width / 2
            height: width

            border {
              width: 2
              color: theme.scheme.foreground
            }

            Text {
              id: closeLabel
              text: ''
              color: closeButton.hovering ? theme.scheme.background : theme.scheme.foreground
              horizontalAlignment: Text.AlignCenter
              verticalAlignment: Text.AlignVCenter
              anchors {
                right: parent.right
                top: parent.top
                rightMargin: 10
                topMargin: 4
              }
              font {
                family: theme.fontRegular.family
                pixelSize: theme.fontRegular.pixelSize
              }
            }

            MouseArea {
              id: closeButton
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              anchors.fill: parent
              onEntered: hovering = true
              onExited: hovering = false
              onClicked: centerOpen = false
              property bool hovering: false
            }
          }
        }

        ListView {
          Layout.fillWidth: true
          Layout.preferredHeight: history.count > 0 ? 300 : 0

          model: history

          delegate: Rectangle {
            width: ListView.view.width
            height: 40
            radius: 8
            color: theme.scheme.background
            border {
              width: 2
              color: theme.scheme.foreground
            }

            RowLayout {
              Layout.fillWidth: true
              spacing: 6

              Text {
                Layout.fillWidth: true
                text: model.summary
                elide: Text.ElideRight
                color: theme.scheme.foreground
                font {
                  family: theme.fontRegular.family
                  pixelSize: theme.fontRegular.pixelSize
                  bold: true
                }
              }

              Text {
                Layout.fillWidth: true
                text: model.time
                color: Colors.mute(theme.scheme.foreground, theme.scheme.isDarkMode)
                font {
                  family: theme.fontRegular.family
                  pixelSize: theme.fontRegular.pixelSize - 2
                }
              }

              Text {
                text: 'x'
                color: Colors.mute(theme.scheme.foreground, theme.scheme.isDarkMode)
                font {
                  family: theme.fontRegular.family
                  pixelSize: theme.fontRegular.pixelSize
                }

                MouseArea {
                  anchors.fill: parent
                  onClicked: history.remove(index)
                }
              }
            }

            Text {
              Layout.fillWidth: true
              visible: model.body !== ''
              text: model.body
              color: theme.scheme.foreground
              font: theme.fontRegular
              wrapMode: Text.WordWrap
            }

            Text {
              visible: model.appName !== ''
              text: model.appName
              font {
                family: theme.fontRegular.family
                pixelSize: theme.fontRegular.pixelSize - 2
              }
              color: Colors.mute(theme.scheme.foreground, theme.scheme.isDarkMode)
            }
          }
        }
      }
    }
  }
}