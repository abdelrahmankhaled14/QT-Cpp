import QtQuick

Rectangle {
    id: root

    property string expressionText: ""
    property string displayText: "0"

    implicitHeight: 120
    color: "#2b2b2b"
    radius: 16
    border.color: "#202020"
    border.width: 1

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Text {
            width: parent.width
            text: root.expressionText
            color: "#aaaaaa"
            font.pixelSize: 18
            horizontalAlignment: Text.AlignRight
            elide: Text.ElideLeft
        }

        Text {
            width: parent.width
            text: root.displayText
            color: "white"
            font.pixelSize: 36
            font.bold: true
            horizontalAlignment: Text.AlignRight
            elide: Text.ElideLeft
        }
    }
}
