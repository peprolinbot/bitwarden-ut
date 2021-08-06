import QtQuick 2.4
import Ubuntu.Components 1.3

ListItem {
  width: parent.width
  anchors.horizontalCenter: parent.horizontalCenter
  divider.visible: true
  clip: true

  onClicked: {
    mainStack.push(Qt.resolvedUrl("PageItemInfo.qml"), {
      "item": item
    });
  }

  leadingActions: ListItemActions {
    actions: Action {
      iconName: "delete"
      text: i18n.tr("Delete")
      onTriggered: {
        py.call('bw_cli_wrapper.delete_object', [bwSettings.session, item.object, item.id], function(result) {
          console.log("Deleting "+item.object+" "+item.name);
        })
        mainStack.pop();
        mainStack.push(Qt.resolvedUrl("PageFolders.qml"));
      }
    }
  }

  trailingActions: ListItemActions {
    actions: [
    Action {
      iconName: "edit-copy"
      text: i18n.tr("Copy note content")
      onTriggered: {
        Clipboard.push(item.notes)
      }
      Component.onCompleted: {
        if (item.type != 2) { // If not a note, disappear
          this.visible = false
        }
      }
    },
    Action {
      iconName: "stock_key"
      text: i18n.tr("Copy password")
      onTriggered: {
        Clipboard.push(item.login.password)
      }
      Component.onCompleted: {
        if (item.type != 1) { // If not a login, disappear
          this.visible = false
        }
      }
    },
    Action {
      iconName: "contact"
      text: i18n.tr("Copy user")
      onTriggered: {
        Clipboard.push(item.login.username)
      }
      Component.onCompleted: {
        if (item.type != 1) { // If not a login, disappear
          this.visible = false
        }
      }
    },
    Action {
      iconName: "clock"
      text: i18n.tr("Copy 2FA")
      onTriggered: {
        py.call('bw_cli_wrapper.get_totp', [bwSettings.session, item.id], function(result) {
          console.log("Obtained 2FA code for  "+item.name);
          Clipboard.push(result);
        })
      }
      Component.onCompleted: {
        if (item.type != 1 || item.login.totp == null) { // If not a login, or a login without 2fa, disappear
          this.visible = false
        }
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

    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter

    Component.onCompleted: {
      if (item.type == 1) {
        this.subtitle.text = item.login.username
      }
    }
  }
}
