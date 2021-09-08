import QtQuick 2.4
import Ubuntu.Components 1.3
import "../Components"

Page {
  objectName: "PageSettings"

  anchors.fill: parent

  header: PageHeader {
    id: header
    title: i18n.tr('Settings')
  }

  Column {
    spacing: 5
    anchors.top: header.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    anchors.horizontalCenter: parent.center

    LabeledTextField {
      id: serverField
      label: i18n.tr('Server')
      Component.onCompleted: {
        py.call('bw_cli_wrapper.get_server', [], function(result) {
          console.log("Server URL is "+result);
          serverField.input = result;
        })
      }
    }

    LabeledTextField {
      id: userField
      label: i18n.tr('User')
    }

    LabeledTextField {
      id: passwordField
      echoMode: TextInput.Password
      label: i18n.tr('Password')
    }

    LabeledTextField {
      id: tfaCodeField
      label: i18n.tr('2FA Code')
    }

    Button {
      id: loginButton
      color: UbuntuColors.green
      anchors.horizontalCenter: parent.horizontalCenter

      text: i18n.tr('Login')

      onClicked: {
        py.call('bw_cli_wrapper.login', [serverField.input, userField.input, passwordField.input, tfaCodeField.input], function(result) {
          console.log("Logged in");
        })
        py.call('bw_cli_wrapper.synchronize', [bwSettings.session], function(result) {
                  console.log("Vault synchronized");
        })
        bwSettings.session = result;
        mainStack.pop();
        mainStack.push(Qt.resolvedUrl("PageSettings.qml"));
      }
    }

    Label {
      id: loginStatusLabel
      anchors.horizontalCenter: parent.horizontalCenter

      font.bold: true
      text: i18n.tr('Checking...')
      Component.onCompleted: {
        py.call('bw_cli_wrapper.is_logged_in', [], function(result) {
          if (result) {
            loginStatusLabel.text = i18n.tr('Logged in')
            console.log("User is already logged in succesfully");
          } else {
            console.log("User is not logged in")
            loginStatusLabel.text = i18n.tr('Not logged in')
          }
        })
      }
    }
  }
}
