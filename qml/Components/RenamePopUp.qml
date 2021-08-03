import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
  property var renameFunction
  property alias input: textField.text
  title: i18n.tr("Enter the new name")
  TextField {
    id: textField
  }
  Button {
    text: i18n.tr("Confirm")
    color: UbuntuColors.green
    onClicked: {
      renameFunction()
      PopupUtils.close(dialog)
    }
  }
  Button {
    text: i18n.tr("Cancel")
    color: UbuntuColors.red
    onClicked: PopupUtils.close(dialog)
  }
}
