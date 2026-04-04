import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root
  property var pluginApi: null

  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  property var editApps: JSON.parse(JSON.stringify(cfg.apps ?? defaults.apps ?? []))

  spacing: Style.marginL

  NLabel {
    text: pluginApi?.tr("settings.apps.title") ?? "Applications"
    font.bold: true
  }

  NLabel {
    text: pluginApi?.tr("settings.apps.desc") ?? "Add applications to launch from the launcher"
    wrapMode: Text.WordWrap
    font.italic: true
  }

  ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.marginS

    Repeater {
      model: root.editApps

      NBox {
        Layout.fillWidth: true
        padding: Style.marginM

        ColumnLayout {
          spacing: Style.marginS

          RowLayout {
            spacing: Style.marginS

            NTextInput {
              Layout.fillWidth: true
              label: pluginApi?.tr("settings.apps.name.label") ?? "Name"
              text: modelData.name
              onTextChanged: {
                if (index < root.editApps.length) {
                  root.editApps[index].name = text;
                }
              }
            }

            NTextInput {
              Layout.fillWidth: true
              label: pluginApi?.tr("settings.apps.command.label") ?? "Command"
              text: modelData.command
              onTextChanged: {
                if (index < root.editApps.length) {
                  root.editApps[index].command = text;
                }
              }
            }
          }

          RowLayout {
            spacing: Style.marginS

            NTextInput {
              Layout.fillWidth: true
              label: pluginApi?.tr("settings.apps.icon.label") ?? "Icon"
              text: modelData.icon ?? "application"
              onTextChanged: {
                if (index < root.editApps.length) {
                  root.editApps[index].icon = text;
                }
              }
            }

            NButton {
              text: pluginApi?.tr("settings.apps.remove") ?? "Remove"
              onClicked: {
                root.editApps.splice(index, 1);
                root.editApps = root.editApps.slice();
              }
            }
          }
        }
      }
    }
  }

  NButton {
    text: pluginApi?.tr("settings.apps.add") ?? "Add Application"
    onClicked: {
      root.editApps.push({
        name: "New App",
        command: "command",
        icon: "application"
      });
      root.editApps = root.editApps.slice();
    }
  }

  function saveSettings() {
    if (!pluginApi) return;
    pluginApi.pluginSettings.apps = root.editApps;
    pluginApi.saveSettings();
  }
}