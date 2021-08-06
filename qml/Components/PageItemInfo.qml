import QtQuick 2.4
import Ubuntu.Components 1.3
import "../Components"

Page {
  objectName: "PageFolderContents"

  property var item

  anchors.fill: parent

  header: PageHeader {
    id: header
    title: item.name
  }

  Flickable {
    anchors.top: header.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    Column {
      anchors.fill: parent
      ListItem {
        trailingActions: ListItemActions {
          actions: Action {
            iconName: "edit-copy"
            text: i18n.tr("Copy username")
            onTriggered: {
              Clipboard.push(item.login.username)
            }
          }
        }
        ListItemLayout {
          title.text: i18n.tr("Username")
          subtitle.text: item.login.username
        }
      }

      ListItem {
        trailingActions: ListItemActions {
          actions: Action {
            iconName: "edit-copy"
            text: i18n.tr("Copy password")
            onTriggered: {
              Clipboard.push(item.login.password)
            }
          }
        }
        ListItemLayout {
          title.text: i18n.tr("Password")
          subtitle.text: showPasswordTrigger.checked?item.login.password:"••••••••"
          subtitle.elide: Text.ElideNone

          Label{
            text: i18n.tr("Show")
          }

          Switch {
            id: showPasswordTrigger
            checked: false
          }
        }
      }
    }
  }

}
