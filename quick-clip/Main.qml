import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Services.UI

Item {
  id: root
  property var pluginApi: null

  // Shared state — the snippets list
  property var snippets: {
    var cfg = pluginApi?.pluginSettings || ({});
    var defaults = pluginApi?.manifest?.metadata?.defaultSettings || ({});
    return cfg.snippets ?? defaults.snippets ?? [];
  }

  function addSnippet(label, content) {
    if (!pluginApi) return;
    var list = pluginApi.pluginSettings.snippets || [];
    list.push({ "label": label, "content": content });
    pluginApi.pluginSettings.snippets = list;
    pluginApi.saveSettings();
    snippetsChanged();
    Logger.d("QuickClip", "Snippet added: " + label);
  }

  function removeSnippet(index) {
    if (!pluginApi) return;
    var list = pluginApi.pluginSettings.snippets || [];
    if (index >= 0 && index < list.length) {
      list.splice(index, 1);
      pluginApi.pluginSettings.snippets = list;
      pluginApi.saveSettings();
      snippetsChanged();
      Logger.d("QuickClip", "Snippet removed at index: " + index);
    }
  }

  function moveSnippet(fromIndex, toIndex) {
    if (!pluginApi) return;
    var list = pluginApi.pluginSettings.snippets || [];
    if (fromIndex >= 0 && fromIndex < list.length && toIndex >= 0 && toIndex < list.length) {
      var item = list.splice(fromIndex, 1)[0];
      list.splice(toIndex, 0, item);
      pluginApi.pluginSettings.snippets = list;
      pluginApi.saveSettings();
      snippetsChanged();
    }
  }

  IpcHandler {
    target: "plugin:quick-clip"

    function toggle() {
      if (pluginApi) {
        pluginApi.withCurrentScreen(screen => {
          pluginApi.togglePanel(screen);
        });
      }
    }

    function add(label: string, content: string) {
      root.addSnippet(label, content);
      ToastService.showNotice("Snippet added: " + label);
    }
  }
}
