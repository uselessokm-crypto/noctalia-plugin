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
  property var snippets: mainInstance?.snippets ?? []
  property int copiedIndex: -1
  property bool showAddDialog: false
  property string newLabel: ""
  property string newContent: ""
  property bool dragActive: false
  property int draggedIndex: -1

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

        NIcon { icon: "content-copy"; pointSize: Style.fontSizeL; color: Color.mPrimary }
        NText {
          text: pluginApi?.tr("panel.title")
          font.pointSize: Style.fontSizeL * Style.uiScaleRatio
          font.weight: Font.Bold
          color: Color.mOnSurface
          Layout.fillWidth: true
        }
        NIconButton {
          icon: "add"
          baseSize: 36 * Style.uiScaleRatio
          colorFg: Color.mPrimary
          tooltipText: pluginApi?.tr("panel.add")
          onClicked: { showAddDialog = true; newLabel = ""; newContent = ""; }
        }
      }

      NText {
        Layout.fillWidth: true
        text: pluginApi?.tr("panel.delete-hint")
        font.pointSize: Style.fontSizeXS * Style.uiScaleRatio
        color: Color.mOnSurfaceVariant
        visible: root.snippets.length > 0 && !root.showAddDialog
        horizontalAlignment: Text.AlignRight
      }

      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: addDialogColumn.implicitHeight + Style.marginL * 2
        color: Color.mSurfaceVariant
        radius: Style.radiusL
        visible: root.showAddDialog

        ColumnLayout {
          id: addDialogColumn
          anchors { fill: parent; margins: Style.marginL }
          spacing: Style.marginM

          NText {
            text: pluginApi?.tr("panel.add-dialog.title")
            font.pointSize: Style.fontSizeM * Style.uiScaleRatio
            font.weight: Font.Bold
            color: Color.mOnSurface
          }

          NTextInput {
            id: labelInput
            Layout.fillWidth: true
            label: pluginApi?.tr("panel.add-dialog.label")
            placeholderText: pluginApi?.tr("panel.add-dialog.label-placeholder")
            text: root.newLabel
            onTextChanged: root.newLabel = text
          }

          NTextInput {
            id: contentInput
            Layout.fillWidth: true
            label: pluginApi?.tr("panel.add-dialog.content")
            placeholderText: pluginApi?.tr("panel.add-dialog.content-placeholder")
            text: root.newContent
            onTextChanged: root.newContent = text
          }

          RowLayout {
            Layout.fillWidth: true
            spacing: Style.marginM
            Item { Layout.fillWidth: true }
            NButton { text: pluginApi?.tr("panel.add-dialog.cancel"); onClicked: root.showAddDialog = false; }
            NButton {
              text: pluginApi?.tr("panel.add-dialog.save")
              enabled: root.newLabel.length > 0 && root.newContent.length > 0
              onClicked: {
                if (root.mainInstance) root.mainInstance.addSnippet(root.newLabel, root.newContent);
                root.showAddDialog = false;
              }
            }
          }
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
          visible: root.snippets.length === 0

          NIcon {
            icon: "content-copy"
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
          id: snippetsList
          anchors.fill: parent
          model: root.snippets
          spacing: Style.marginS
          visible: root.snippets.length > 0

          delegate: Item {
            id: snippetDelegate
            width: snippetsList.width
            height: snippetCard.height

            required property int index
            required property var modelData

            property real dragX: 0
            property bool isDragging: false

            Rectangle {
              id: deleteIndicator
              anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
              width: 60 * Style.uiScaleRatio
              color: "#E53935"
              radius: Style.radiusM
              opacity: snippetDelegate.isDragging ? Math.min(1.0, Math.abs(snippetDelegate.dragX) / (40 * Style.uiScaleRatio)) : 0

              NIcon { anchors.centerIn: parent; icon: "delete"; pointSize: Style.fontSizeL; color: "#FFFFFF" }
              Behavior on opacity { NumberAnimation { duration: 150 } }
            }

            Rectangle {
              id: snippetCard
              width: parent.width
              height: cardContent.implicitHeight + Style.marginM * 2
              color: root.copiedIndex === snippetDelegate.index ? Color.mPrimaryContainer : Color.mSurfaceVariant
              radius: Style.radiusM
              x: snippetDelegate.dragX

              Behavior on color { ColorAnimation { duration: 200 } }
              Behavior on x { enabled: !snippetDelegate.isDragging; NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

              RowLayout {
                id: cardContent
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: Style.marginM }
                spacing: Style.marginM

                ColumnLayout {
                  Layout.fillWidth: true
                  spacing: 2
                  NText {
                    text: snippetDelegate.modelData.label || ""
                    font.pointSize: Style.fontSizeM * Style.uiScaleRatio
                    font.weight: Font.Medium
                    color: root.copiedIndex === snippetDelegate.index ? Color.mOnPrimaryContainer : Color.mOnSurface
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                  }
                  NText {
                    text: snippetDelegate.modelData.content || ""
                    font.pointSize: Style.fontSizeS * Style.uiScaleRatio
                    font.family: Settings.data.ui.fontFixed
                    color: root.copiedIndex === snippetDelegate.index ? Color.mOnPrimaryContainer : Color.mOnSurfaceVariant
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    opacity: 0.8
                  }
                }
                NIcon {
                  icon: root.copiedIndex === snippetDelegate.index ? "check" : "content-copy"
                  pointSize: Style.fontSizeM
                  color: root.copiedIndex === snippetDelegate.index ? Color.mOnPrimaryContainer : Color.mOnSurfaceVariant
                }
              }

              MouseArea {
                id: dragArea
                anchors.fill: parent
                drag.target: null

                property real startX: 0
                property bool hasMoved: false

                onPressed: mouse => { startX = mouse.x; hasMoved = false; }
                onPositionChanged: mouse => {
                  var dx = mouse.x - startX;
                  if (Math.abs(dx) > 5) {
                    hasMoved = true; snippetDelegate.isDragging = true; root.dragActive = true; root.draggedIndex = snippetDelegate.index;
                    snippetDelegate.dragX = Math.min(0, dx);
                  }
                }
                onReleased: {
                  snippetDelegate.isDragging = false; root.dragActive = false;
                  if (snippetDelegate.dragX < -(60 * Style.uiScaleRatio)) {
                    if (root.mainInstance) root.mainInstance.removeSnippet(snippetDelegate.index);
                  } else if (!hasMoved) {
                    copyToClipboard(snippetDelegate.modelData.content || "");
                    root.copiedIndex = snippetDelegate.index;
                    copiedResetTimer.restart();
                  }
                  snippetDelegate.dragX = 0; root.draggedIndex = -1;
                }
              }
            }
          }
        }
      }
    }
  }

  Timer { id: copiedResetTimer; interval: 1500; repeat: false; onTriggered: root.copiedIndex = -1 }

  function copyToClipboard(text) {
    clipboardHelper.text = text;
    clipboardHelper.selectAll();
    clipboardHelper.copy();
    ToastService.showNotice(pluginApi?.tr("panel.copied"));
  }

  TextEdit { id: clipboardHelper; visible: false }
}
