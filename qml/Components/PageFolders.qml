import QtQuick 2.4
import Ubuntu.Components 1.3
import "../Components"

Page {
  objectName: "PageFolders"

  anchors.fill: parent

  header: PageHeader {
    id: header
    title: i18n.tr('uBitwarden')

    trailingActionBar {
      actions: [
      Action {
        iconName: "settings"
        onTriggered: {
          mainStack.push(Qt.resolvedUrl("PageLogin.qml"));
        }
      },
      Action {
        iconName: "reload"
        onTriggered: {
          activityIndicator.running = true;
          py.call('bw_cli_wrapper.synchronize', [bwSettings.session], function(result) {
                    console.log("Vault synchronized");
                })
          mainStack.pop();
          mainStack.push(Qt.resolvedUrl("PageFolders.qml"));
        }
      }
      ]
    }
  }

  ActivityIndicator {
    id: activityIndicator
    anchors.centerIn: parent
    running: true
  }

  Component {
    id: foldersDelegate

    FoldersDelegate {}
  }

  ItemsList {
    id: folderList
    visible: !activityIndicator.running
    anchors.top: header.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    delegate: foldersDelegate
  }

  Component.onCompleted: {
    py.call('bw_cli_wrapper.get_folders', [bwSettings.session], function(result) {
              folderList.populate(result);
              console.log("Obtained items from Bitwarden");
              activityIndicator.running = false;
          })
  }
}
