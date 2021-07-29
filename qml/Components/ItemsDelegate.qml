import QtQuick 2.4
import Ubuntu.Components 1.3

ListItem {
  width: parent.width
  anchors.horizontalCenter: parent.horizontalCenter
  divider.visible: false
  clip: true

  onClicked: {
    mainStack.push(Qt.resolvedUrl("PageItemsInfo.qml"), {
      "id": id
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
      }
    }
  }

  trailingActions: ListItemActions {
    actions: [
    Action {
      iconName: "stock_key"
      text: i18n.tr("Copy password")
      onTriggered: {
        Clipboard.push(item.login.password)
      }
    },
    Action {
      iconName: "contact"
      text: i18n.tr("Copy user")
      onTriggered: {
        Clipboard.push(item.login.username)
      }
    },
    Action {
      iconName: "clock"
      text: i18n.tr("Copy 2FA")
      onTriggered: {
        py.call('bw_cli_wrapper.get_totp', [bwSettings.session, item.id], function(result) {
          console.log("Obtained 2FA code for item with id "+item.id);
          Clipboard.push(result);
        })
      }
    },
    Action {
      iconName: "edit"
      text: i18n.tr("Edit key")
      onTriggered: {
        mainStack.push(Qt.resolvedUrl("PageEditAddItem.qml"), {
          "editMode": true,
          "idToEdit": item.id,
        });
      }
    }
    ]
  }

  ListItemLayout {
    id:layout

    title.text: item.name
    title.font.bold: true

    subtitle.text: item.login.username

    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter
  }
}
