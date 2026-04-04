import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root
  property var pluginApi: null

  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  property var editApps: {
    const src = cfg.apps ?? defaults.apps ?? [];
    return JSON.parse(JSON.stringify(src));
  }

  spacing: Style.marginL

  NLabel {
    text: pluginApi?.tr("settings.apps.title")
    font.bold: true
  }

  NLabel {
    text: pluginApi?.tr("settings.apps.desc")
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
              label: pluginApi?.tr("settings.apps.name.label")
              text: modelData.name
              onTextChanged: {
                if (index < root.editApps.length) {
                  root.editApps[index].name = text;
                }
              }
            }

            NTextInput {
              Layout.fillWidth: true
              label: pluginApi?.tr("settings.apps.icon.label")
              text: modelData.icon ?? "application"
              onTextChanged: {
                if (index < root.editApps.length) {
                  root.editApps[index].icon = text;
                }
              }
            }
          }

          ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.marginXS

            NLabel {
              text: pluginApi?.tr("settings.apps.commands.label")
              font.bold: true
              font.pixelSize: Style.fontSizeS
            }

            Repeater {
              model: {
                if (index < root.editApps.length && root.editApps[index].commands) {
                  return root.editApps[index].commands;
                } else if (index < root.editApps.length && root.editApps[index].command) {
                  root.editApps[index].commands = [root.editApps[index].command];
                  delete root.editApps[index].command;
                  return root.editApps[index].commands;
                }
                return [];
              }

              RowLayout {
                Layout.fillWidth: true
                spacing: Style.marginXS

                NTextInput {
                  Layout.fillWidth: true
                  label: pluginApi?.tr("settings.apps.command.label")
                  text: modelData
                  onTextChanged: {
                    if (index < root.editApps.length) {
                      var cmdIndex = Repeater.index;
                      root.editApps[index].commands[cmdIndex] = text;
                    }
                  }
                }

                NIconButton {
                  icon: "list-remove"
                  onClicked: {
                    if (index < root.editApps.length) {
                      var cmdIdx = Repeater.index;
                      root.editApps[index].commands.splice(cmdIdx, 1);
                      root.editApps = root.editApps.slice();
                    }
                  }
                }
              }
            }

            NIconButton {
              icon: "list-add"
              tooltipText: pluginApi?.tr("settings.apps.command.add")
              onClicked: {
                if (index < root.editApps.length) {
                  if (!root.editApps[index].commands) {
                    root.editApps[index].commands = [];
                  }
                  root.editApps[index].commands.push("");
                  root.editApps = root.editApps.slice();
                }
              }
            }
          }

          RowLayout {
            Layout.topMargin: Style.marginXS
            spacing: Style.marginS

            NButton {
              text: pluginApi?.tr("settings.apps.remove")
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
    text: pluginApi?.tr("settings.apps.add")
    onClicked: {
      root.editApps.push({
        name: "New App",
        icon: "application",
        commands: [""]
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
