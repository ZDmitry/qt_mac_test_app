import QtQuick 2.2
import QtQuick.Window 2.1
import TestApp 1.0


Window {
    visible: true
    width: 360
    height: 360

    TestObj {
        id: tobj
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            tobj.click();
        }
    }

    Text {
        text: qsTr("Hello World")
        anchors.centerIn: parent
    }
}
