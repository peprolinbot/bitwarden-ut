import QtQuick 2.4
import Ubuntu.Components 1.3
import "../Components"

Item {
  property alias delegate: itemsListView.delegate
  readonly property var populate: storedItemsModel.populate

  ScrollView {
    anchors.fill: parent
    contentItem: itemsListView
  }

  ListView {
    id: itemsListView
    anchors.fill: parent
    model: storedItemsModel // searching ? searchKeysModel : storedKeys
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
}
