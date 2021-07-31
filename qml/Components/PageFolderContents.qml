import QtQuick 2.4
import Ubuntu.Components 1.3
import "../Components"

Page {
  objectName: "PageFolderContents"

  anchors.fill: parent

  header: PageHeader {
    id: header
    title: i18n.tr('uBitwarden')

    trailingActionBar {
      actions: [
      Action {
        iconName: "settings"
        onTriggered: {
          mainStack.push(Qt.resolvedUrl("PageSettings.qml"));
        }
      },
      Action {
        iconName: "reload"
        onTriggered: {
          py.call('bw_cli_wrapper.synchronize', [bwSettings.session], function(result) {
                    console.log("Vault synchronized");
                })
              mainStack.pop();
          mainStack.push(Qt.resolvedUrl("PageMain.qml"));
        }
      }
      ]
    }
  }

  ScrollView {
    anchors.top: parent.header.bottom
    width: parent.width
    height: parent.height
    contentItem: itemsListView
  }

  ListView {
    id: itemsListView
    anchors.fill: parent
    model: storedItemsModel // searching ? searchKeysModel : storedKeys
    delegate: itemsDelegate
  }
  ListModel {
    id: storedItemsModel

    function populate(data) {
      storedItemsModel.clear();
      if (data.length > 0) {
        for (var i = 0; i < data.length; i++) {
          try {
            var itemData = data[i]; // TODO
            storedItemsModel.append({item: itemData});  // TODO searchablestring: data.item(i).description + " " + parsedKey.issuer + " " + parsedKey.label
          } catch(e) {
            console.log("Error",e);
          }
        }
      }
    }
  }

  Component {
    id: itemsDelegate

    ItemsDelegate {}
  }

  Component.onCompleted: {
    py.call('bw_cli_wrapper.get_items', [bwSettings.session], function(result) {
              storedItemsModel.populate(result);
              console.log("Obtained items from Bitwarden");
          })
  }
}
