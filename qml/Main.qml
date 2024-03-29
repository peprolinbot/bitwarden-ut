/*
 * Copyright (C) 2021  Pedro Rey Anca
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * bitwarden-ut is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import io.thp.pyotherside 1.3
import "Components"

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'bitwarden-ut.peprolinbot'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

   Settings {
     id: bwSettings

     property string session: ""
   }

   PageStack {
     id: mainStack
     anchors.fill: parent

     onCurrentPageChanged: {
       console.log("Current PageStack Page: " + currentPage.objectName)
     }
   }

   Component.onCompleted: {
     if (bwSettings.session == "") {
       mainStack.push(Qt.resolvedUrl("Components/PageLogin.qml"));
     } else {
       mainStack.push(Qt.resolvedUrl("Components/PageFolders.qml"));
     }
   }
      Python {
        id: py

        Component.onCompleted: {

          // Print version of plugin and Python interpreter
          console.log('PyOtherSide version: ' + pluginVersion());
          console.log('Python version: ' + pythonVersion());

          addImportPath(Qt.resolvedUrl('../src/'));

          // Add needed python libraries to sys.path
          addImportPath(Qt.resolvedUrl('../pylibs/pexpect'));
          addImportPath(Qt.resolvedUrl('../pylibs/ptyprocess'));
          addImportPath(Qt.resolvedUrl('../pylibs/pyotp/src'));

          importModule('bw_cli_wrapper', function() {});
          importModule('otp_helper', function() {});
          console.log('Python modules imported');
        }

        onError: {
          console.log('Python error: ' + traceback);
        }
      }
}
