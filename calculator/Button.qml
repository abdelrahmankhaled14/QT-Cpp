import QtQuick

Rectangle {
    id: root

    property string text: ""
    property color backgroundColor: "#3a3a3a"
    property color textColor: "white"
    property int fontSize: 22
    property int buttonRadius: 10

    signal clicked()

    implicitWidth: 70
    implicitHeight: 70

    color: backgroundColor
    radius: buttonRadius
    border.color: "#202020"
    border.width: 1

    Text {
        anchors.centerIn: parent
        text: root.text
        color: root.textColor
        font.pixelSize: root.fontSize
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
        onPressed: root.opacity = 0.4
        onReleased: root.opacity = 1.0
        onCanceled: root.opacity = 1.0
    }
}
