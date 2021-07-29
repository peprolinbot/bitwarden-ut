import QtQuick 2.4
import Ubuntu.Components 1.3

Column {

  property alias label: label.text
  property alias input: textField.text
  property alias echoMode: textField.echoMode

  Label{
    id: label

    font.bold: true
    text: "I use arch btw"
  }

  TextField {
    id: textField

    echoMode: TextInput.Normal
  }
}
