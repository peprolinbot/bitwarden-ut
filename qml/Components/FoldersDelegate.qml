import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

ListItem {
  width: parent.width
  anchors.horizontalCenter: parent.horizontalCenter
  divider.visible: false
  clip: true

  onClicked: {
    mainStack.push(Qt.resolvedUrl("PageFolderContents.qml"), {
      "id": item.id,
      "name": item.name
    });
  }

  leadingActions: ListItemActions {
    actions: Action {
      iconName: "delete"
      text: i18n.tr("Delete")
      onTriggered: {
        py.call('bw_cli_wrapper.delete_object', [bwSettings.session, item.object, item.id], function(result) {
          console.log("Deleting "+item.object+" with id "+item.id);
        })
        mainStack.pop();
        mainStack.push(Qt.resolvedUrl("PageFolders.qml"));
      }
    }
  }

  trailingActions: ListItemActions {
    actions: Action {
      iconName: "edit"
      text: i18n.tr("Rename folder")
      onTriggered: {
        PopupUtils.open(renameFolderDialogComponent)
      }
    }
  }

  Component {
    id: renameFolderDialogComponent
    RenamePopUp {
      id: dialog
      input: item.name
      renameFunction: function rename_folder() {
        py.call('bw_cli_wrapper.rename_object', [bwSettings.session, item.object, item.id, dialog.input], function(result) {
        })
        console.log("Succesfully renamed "+item.id+" to "+dialog.input)
        mainStack.pop();
        mainStack.push(Qt.resolvedUrl("PageFolders.qml"));
      }
    }
  }

  ListItemLayout {
    id:layout

    title.text: item.name
    title.font.bold: true

    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter
  }

  Component.onCompleted: {
    if (item.id == null) { // In case the folder is actually "No folder"
      leadingActions = null
      trailingActions = null
      item.name = i18n.tr("No folder") // To enable translations of "No folder"
    }
  }
}
