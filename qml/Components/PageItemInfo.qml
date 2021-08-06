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

      ListItem {
        visible: item.login.totp!=null
        trailingActions: ListItemActions {
          actions: Action {
            iconName: "edit-copy"
            text: i18n.tr("Copy 2FA code")
            onTriggered: {
              Clipboard.push(item.login.password)
            }
          }
        }
        ListItemLayout {
          title.text: i18n.tr("One time password")
          subtitle.text: ""

          Label {
            id: dueTime
            text: ""
          }

          Timer {
            interval: 100
            repeat: true
            running: item.login.totp!=null
            onTriggered: {
              py.call('otp_helper.get_remaining_time', [item.login.totp], function(result) {
                dueTime.text = result
              })
              py.call('otp_helper.get_otp', [item.login.totp], function(result) {
                parent.subtitle.text = result
              })
            }
          }


          ProgressCircle {
            size: parent.height - units.dp(32)
            colorCircle: UbuntuColors.inkstone
            showBackground: false
            isPie: true
            arcBegin: 0
            arcEnd: dueTime.text*360/30
          }
        }
      }
    }
  }

}
