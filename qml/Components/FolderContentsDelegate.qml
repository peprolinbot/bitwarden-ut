import QtQuick 2.4
import Ubuntu.Components 1.3

ListItem {
  width: parent.width
  anchors.horizontalCenter: parent.horizontalCenter

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
      visible: item.type == 2  // If not a note, disappear
      iconName: "edit-copy"
      text: i18n.tr("Copy note content")
      onTriggered: {
        Clipboard.push(item.notes)
      }
    },
    Action {
      visible: item.type == 1 && item.login.password != null
      iconName: "stock_key"
      text: i18n.tr("Copy password")
      onTriggered: {
        Clipboard.push(item.login.password)
      }
    },
    Action {
      visible: item.type == 1 && item.login.username != null
      iconName: "contact"
      text: i18n.tr("Copy user")
      onTriggered: {
        Clipboard.push(item.login.username)
      }
    },
    Action {
      visible: item.type == 1 && item.login.totp != null
      iconName: "clock"
      text: i18n.tr("Copy 2FA")
      onTriggered: {
        py.call('otp_helper.get_otp', [item.login.totp], function(result) {
          console.log("Obtained 2FA code for  "+item.name);
          Clipboard.push(result);
        })
      }
    },
    Action {
      iconName: "edit"
      text: i18n.tr("Edit")
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

    Image {
      height: units.gu(3)
      width: height

      source: item.type == 2 ? "../../assets/note.svg" : (item.login.uris.length == 0 ? "../../assets/default-icon.png" : "https://icons.bitwarden.net/"+item.login.uris[0].uri.split("//")[1].split("/")[0]+"/icon.png")
    }

    title.text: item.name
    subtitle.text: item.type == 1 && item.login.username != null ? item.login.username : ""

    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter
  }
}
