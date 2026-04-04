import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Services.UI
import qs.Widgets

Item {
  id: root

  property var pluginApi: null

  readonly property var geometryPlaceholder: panelContainer

  property real contentPreferredWidth: 400 * Style.uiScaleRatio
  property real contentPreferredHeight: 500 * Style.uiScaleRatio

  readonly property bool allowAttach: true

  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  property var apps: cfg.apps ?? defaults.apps ?? []

  anchors.fill: parent

  Rectangle {
    id: panelContainer
    anchors.fill: parent
    color: "transparent"

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: Style.marginL
      spacing: Style.marginL

      RowLayout {
        Layout.fillWidth: true
        spacing: Style.marginS

        NIcon {
          icon: "applications-other"
          pointSize: Style.fontSizeL
          color: Color.mPrimary
        }

        NText {
          text: pluginApi?.tr("panel.title")
          pointSize: Style.fontSizeL
          font.weight: Style.fontWeightBold
          color: Color.mOnSurface
          Layout.fillWidth: true
        }
      }

      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Color.mSurfaceVariant
        radius: Style.radiusL

        ScrollView {
          anchors.fill: parent
          anchors.margins: Style.marginM

          ColumnLayout {
            width: parent.width
            spacing: Style.marginS

            Repeater {
              model: root.apps

              NIconButton {
                Layout.fillWidth: true
                text: modelData.name
                icon: modelData.icon ?? "application"
                onClicked: {
                  executeCommands(modelData.commands ?? [modelData.command]);
                  PanelService.closePanel(root.screen);
                }
              }
            }

            NText {
              visible: root.apps.length === 0
              text: pluginApi?.tr("panel.empty")
              pointSize: Style.fontSizeM
              color: Color.mOnSurfaceVariant
              Layout.alignment: Qt.AlignHCenter
              Layout.topMargin: Style.marginL * 2
            }
          }
        }
      }

      NButton {
        Layout.fillWidth: true
        text: pluginApi?.tr("panel.add")
        icon: "list-add"
        onClicked: {
          BarService.openPluginSettings(root.screen, pluginApi.manifest);
        }
      }
    }
  }

  function executeCommands(commands) {
    for (let i = 0; i < commands.length; i++) {
      Process.startDetached(commands[i], []);
    }
  }
}
