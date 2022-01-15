import QtQuick 2.4
import Ubuntu.Components 1.3
import "../Components"

Page {
  objectName: "PageSettings"
  id: pageSettings

  anchors.fill: parent

  header: PageHeader {
    id: header
    title: i18n.tr('Settings')
  }
  Flickable {
    anchors.top: header.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    ActivityIndicator {
      id: activityIndicator
      anchors.centerIn: parent
      running: true
    }
    Column {
      visible: !activityIndicator.running
      anchors.fill: parent

      ListItem {
        id: serverItem

        height: serverLayout.height + (divider.visible ? divider.height : 0)
        divider.visible: false

        SlotsLayout {
          id: serverLayout

          Label {
            id: serverLabel
            text: i18n.tr('Server')
          }

          TextField {
            id: serverTextField
            anchors.left: serverLabel.right
            anchors.right: parent.right

            Component.onCompleted: {
              py.call('bw_cli_wrapper.get_server', [], function(result) {
                console.log("Server URL is "+result);
                serverTextField.text = result;
              })
            }
          }
        }
      }

      ListItem {
        id: emailItem

        height: emailLayout.height + (divider.visible ? divider.height : 0)
        divider.visible: false

        SlotsLayout {
          id: emailLayout

          Label {
            id: emailLabel
            text: i18n.tr('Email')
          }

          TextField {
            id: emailTextField
            anchors.left: emailLabel.right
            anchors.right: parent.right
          }
        }
      }

      ListItem {
        id: passwordItem

        height: passwordLayout.height + (divider.visible ? divider.height : 0)
        divider.visible: false

        SlotsLayout {
          id: passwordLayout

          Label {
            id: passwordLabel
            text: i18n.tr('Password')
          }

          TextField {
            id: passwordTextField
            echoMode: TextInput.Password
            anchors.left: passwordLabel.right
            anchors.right: parent.right
          }
        }
      }

      ListItem {
        id: tfaCodeItem

        height: tfaCodeLayout.height + (divider.visible ? divider.height : 0)
        divider.visible: false

        SlotsLayout {
          id: tfaCodeLayout

          Label {
            id: tfaCodeLabel
            text: i18n.tr('2FA Code')
          }

          TextField {
            id: tfaCodeTextField
            anchors.left: tfaCodeLabel.right
            anchors.right: parent.right
          }
        }
      }

      ListItem {
        id: loginButtonItem
        divider.visible: false

        SlotsLayout {
          id: loginButtonLayout

          mainSlot: Button {
            id: loginButton
            color: UbuntuColors.green

            text: i18n.tr('Login')

            onClicked: {
              activityIndicator.running = true
              py.call('bw_cli_wrapper.login', [serverTextField.text, emailTextField.text, passwordTextField.text, tfaCodeTextField.text], function(result) {
                bwSettings.session = result;
                console.log("Logged in");
                py.call('bw_cli_wrapper.synchronize', [bwSettings.session], function(result) {
                  console.log("Vault synchronized");
                  mainStack.pop();
                  mainStack.push(Qt.resolvedUrl("PageSettings.qml"));
                })
              })
            }
          }
        }
      }

      ListItem {
        id: loginStatusItem
        divider.visible: false

        SlotsLayout {
          id: loginStatusLayout

          mainSlot: Label {
            id: loginStatusLabel

            font.bold: true
            text: i18n.tr('Checking...')
            horizontalAlignment: Text.AlignHCenter
            Component.onCompleted: {
              py.call('bw_cli_wrapper.is_logged_in', [], function(result) {
                if (result) {
                  loginStatusLabel.text = i18n.tr('Logged in')
                  console.log("User is already logged in succesfully");
                } else {
                  console.log("User is not logged in")
                  loginStatusLabel.text = i18n.tr('Not logged in')
                }
                activityIndicator.running = false
              })
            }
          }
        }
      }
    }
  }
}
