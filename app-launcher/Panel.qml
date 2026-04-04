import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services.UI
import qs.Widgets

Item {
  id: root
  property var pluginApi: null

  readonly property var geometryPlaceholder: panelContainer

  property real contentPreferredWidth: 380 * Style.uiScaleRatio
  property real contentPreferredHeight: 520 * Style.uiScaleRatio
  readonly property bool allowAttach: true

  anchors.fill: parent

  property var mainInstance: pluginApi?.mainInstance
  property var apps: mainInstance?.apps ?? []

  Rectangle {
    id: panelContainer
    anchors.fill: parent
    color: "transparent"

    ColumnLayout {
      anchors { fill: parent; margins: Style.marginL }
      spacing: Style.marginM

      RowLayout {
        Layout.fillWidth: true
        spacing: Style.marginM

        NIcon { icon: "applications-other"; pointSize: Style.fontSizeL; color: Color.mPrimary }
        NText {
          text: pluginApi?.tr("panel.title")
          font.pointSize: Style.fontSizeL * Style.uiScaleRatio
          font.weight: Font.Bold
          color: Color.mOnSurface
          Layout.fillWidth: true
        }
      }

      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "transparent"
        clip: true

        ColumnLayout {
          anchors.centerIn: parent
          spacing: Style.marginL
          visible: root.apps.length === 0

          NIcon {
            icon: "applications-other"
            Layout.alignment: Qt.AlignHCenter
            pointSize: Style.fontSizeXXL * 2 * Style.uiScaleRatio
            color: Color.mOnSurfaceVariant
            opacity: 0.4
          }

          NText {
            Layout.alignment: Qt.AlignHCenter
            text: pluginApi?.tr("panel.empty")
            font.pointSize: Style.fontSizeM * Style.uiScaleRatio
            color: Color.mOnSurfaceVariant
          }
        }

        ListView {
          id: appsList
          anchors.fill: parent
          model: root.apps
          spacing: Style.marginS
          visible: root.apps.length > 0

          delegate: Item {
            id: appDelegate
            width: appsList.width
            height: appCard.height

            required property int index
            required property var modelData

            Rectangle {
              id: appCard
              width: parent.width
              height: cardContent.implicitHeight + Style.marginM * 2
              color: Color.mSurfaceVariant
              radius: Style.radiusM

              RowLayout {
                id: cardContent
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: Style.marginM }
                spacing: Style.marginM

                NIcon {
                  icon: modelData.icon || "application"
                  pointSize: Style.fontSizeM
                  color: Color.mPrimary
                }

                NText {
                  text: modelData.name || ""
                  font.pointSize: Style.fontSizeM * Style.uiScaleRatio
                  font.weight: Font.Medium
                  color: Color.mOnSurface
                  Layout.fillWidth: true
                  elide: Text.ElideRight
                }

                NIcon {
                  icon: "play"
                  pointSize: Style.fontSizeS
                  color: Color.mOnSurfaceVariant
                }
              }

              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  var commands = modelData.commands || [];
                  if (commands.length === 0 && modelData.command) {
                    commands = [modelData.command];
                  }
                  if (root.mainInstance) root.mainInstance.executeCommands(commands);
                }
              }
            }
          }
        }
      }
    }
  }
}
