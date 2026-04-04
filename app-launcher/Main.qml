import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Services.UI

Item {
  id: root
  property var pluginApi: null

  property var apps: {
    var cfg = pluginApi?.pluginSettings || ({});
    var defaults = pluginApi?.manifest?.metadata?.defaultSettings || ({});
    return cfg.apps ?? defaults.apps ?? [];
  }

  function addApp(name, icon, commands) {
    if (!pluginApi) return;
    var list = pluginApi.pluginSettings.apps || [];
    list.push({ "name": name, "icon": icon, "commands": commands });
    pluginApi.pluginSettings.apps = list;
    pluginApi.saveSettings();
    appsChanged();
    Logger.d("AppLauncher", "App added: " + name);
  }

  function removeApp(index) {
    if (!pluginApi) return;
    var list = pluginApi.pluginSettings.apps || [];
    if (index >= 0 && index < list.length) {
      list.splice(index, 1);
      pluginApi.pluginSettings.apps = list;
      pluginApi.saveSettings();
      appsChanged();
      Logger.d("AppLauncher", "App removed at index: " + index);
    }
  }

  function executeCommands(commands) {
    for (let i = 0; i < commands.length; i++) {
      Process.startDetached(commands[i], []);
    }
  }

  IpcHandler {
    target: "plugin:app-launcher"

    function toggle() {
      if (pluginApi) {
        pluginApi.withCurrentScreen(screen => {
          pluginApi.togglePanel(screen);
        });
      }
    }
  }
}
