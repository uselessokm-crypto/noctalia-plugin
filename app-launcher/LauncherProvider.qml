import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Item {
  id: root
  property var pluginApi: null

  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  property var apps: cfg.apps ?? defaults.apps ?? []

  function queryLauncher(searchText) {
    if (!searchText || searchText.length === 0) {
      return apps.map(app => ({
        id: app.name,
        title: app.name,
        subtitle: app.command,
        icon: app.icon ?? "application",
        action: "launch:" + app.command
      }));
    }

    const lowerSearch = searchText.toLowerCase();
    const filtered = apps.filter(app => {
      return app.name.toLowerCase().includes(lowerSearch) ||
             app.command.toLowerCase().includes(lowerSearch);
    });

    return filtered.map(app => ({
      id: app.name,
      title: app.name,
      subtitle: app.command,
      icon: app.icon ?? "application",
      action: "launch:" + app.command
    }));
  }

  function executeAction(action) {
    if (action && action.startsWith("launch:")) {
      const command = action.substring(7);
      Process.startDetached(command, []);
      return true;
    }
    return false;
  }
}