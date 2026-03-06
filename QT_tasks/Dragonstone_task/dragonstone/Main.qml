import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
ApplicationWindow {
    visible: true
    width: 1200
    height: 1200
    title: "Game of Thrones"

    ListModel { id: dragonsModel }
    ListModel { id: characterModel }

    property bool showSplash: true
    property string selectedName: ""
    property string selectedImage: ""
    property string selectedType: ""
    property string selectedExtra1: ""
    property string selectedExtra2: ""
    property string selectedDescription: ""

    function jsonFetchDrogans() {
        const xhr = new XMLHttpRequest()
        xhr.open("GET", "qrc:/assets/data/dragons.json")

        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return

            console.log("Dragons status:", xhr.status)

            if (xhr.status !== 200) {
                console.log("Failed to load dragons.json")
                return
            }

            const obj = JSON.parse(xhr.responseText)
            dragonsModel.clear()

            for (let i = 0; i < obj.dragons.length; i++) {
                const d = obj.dragons[i]

                dragonsModel.append({
                    itemId: d.id,
                    name: d.name,
                    image: "qrc:/" + d.image,
                    extra1Label: "Rider",
                    extra1Value: d.rider,
                    extra2Label: "Nickname",
                    extra2Value: d.nickname,
                    description: d.description,
                    type: "Dragon"
                })
            }

            if (dragonsModel.count > 0 && selectedName === "") {
                const first = dragonsModel.get(0)
                selectedName = first.name
                selectedImage = first.image
                selectedType = first.type
                selectedExtra1 = first.extra1Label + ": " + first.extra1Value
                selectedExtra2 = first.extra2Label + ": " + first.extra2Value
                selectedDescription = first.description
            }
        }

        xhr.send()
    }

    function jsonFetchCharacters() {
        const xhr = new XMLHttpRequest()
        xhr.open("GET", "qrc:/assets/data/characters.json")

        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return

            console.log("Characters status:", xhr.status)

            if (xhr.status !== 200) {
                console.log("Failed to load characters.json")
                return
            }

            const obj = JSON.parse(xhr.responseText)
            characterModel.clear()

            for (let i = 0; i < obj.characters.length; i++) {
                const c = obj.characters[i]

                characterModel.append({
                    itemId: c.id,
                    name: c.name,
                    image: "qrc:/" + c.image,
                    extra1Label: "House",
                    extra1Value: c.house,
                    extra2Label: "Title",
                    extra2Value: c.title,
                    description: c.description,
                    type: "Character"
                })
            }
        }

        xhr.send()
    }

    function selectItem(item) {
        selectedName = item.name
        selectedImage = item.image
        selectedType = item.type
        selectedExtra1 = item.extra1Label + ": " + item.extra1Value
        selectedExtra2 = item.extra2Label + ": " + item.extra2Value
        selectedDescription = item.description
    }

    Component.onCompleted: {
        jsonFetchDrogans()
        jsonFetchCharacters()
        splashPlayer.play()
    }

    function closeSplash() {
        showSplash = false
        splashPlayer.stop()
    }
    Row {
        anchors.fill: parent
        visible: !showSplash

        Rectangle {
            id: galleryArea
            width: parent.width * 0.7
            height: parent.height
            color: "#f5f5f5"

            Column {
                anchors.fill: parent
                spacing: 0

                TabBar
                {
                    id: tabBar
                    width: parent.width

                    TabButton { text: "Dragons" }
                    TabButton { text: "Characters" }
                }

                SwipeView {
                    id: swipeView
                    width: parent.width
                    height: parent.height
                    currentIndex: tabBar.currentIndex

                    onCurrentIndexChanged: tabBar.currentIndex = currentIndex

                    Item {
                        GridView {
                            id: dragonsGrid
                            anchors.fill: parent
                            anchors.margins: 20
                            model: dragonsModel
                            cellWidth: (galleryArea.width - 60) / 2
                            cellHeight: 190
                            clip: true

                            delegate: Rectangle {
                                width: dragonsGrid.cellWidth
                                height: dragonsGrid.cellHeight
                                radius: 10
                                color: "white"
                                border.color: "#d0d0d0"
                                border.width: 1

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true

                                    onEntered: selectItem(model)

                                    onClicked: {
                                        selectItem(model)
                                        descriptionPopup.open()
                                    }
                                }

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 8

                                    Rectangle {
                                        width: parent.width
                                        height: 130
                                        radius: 8
                                        color: "#eaeaea"
                                        clip: true

                                        Image {
                                            anchors.fill: parent
                                            source: model.image
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }

                                    Text {
                                        text: model.name
                                        width: parent.width
                                        horizontalAlignment: Text.AlignHCenter
                                        font.pixelSize: 16
                                        font.bold: true
                                        color: "black"
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        text: model.extra1Value
                                        width: parent.width
                                        horizontalAlignment: Text.AlignHCenter
                                        font.pixelSize: 12
                                        color: "gray"
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        GridView {
                            id: charactersGrid
                            anchors.fill: parent
                            anchors.margins: 20
                            model: characterModel
                            cellWidth: (galleryArea.width - 60) / 2
                            cellHeight: 190
                            clip: true

                            delegate: Rectangle {
                                width: charactersGrid.cellWidth
                                height: charactersGrid.cellHeight
                                radius: 10
                                color: "white"
                                border.color: "#d0d0d0"
                                border.width: 1
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true

                                    onEntered: selectItem(model)

                                    onClicked: {
                                        selectItem(model)
                                        descriptionPopup.open()
                                    }
                                }

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 8

                                    Rectangle {
                                        width: parent.width
                                        height: 130
                                        radius: 8
                                        color: "#eaeaea"
                                        clip: true

                                        Image {
                                            anchors.fill: parent
                                            source: model.image
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }

                                    Text {
                                        text: model.name
                                        width: parent.width
                                        horizontalAlignment: Text.AlignHCenter
                                        font.pixelSize: 16
                                        font.bold: true
                                        color: "black"
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        text: model.extra1Value
                                        width: parent.width
                                        horizontalAlignment: Text.AlignHCenter
                                        font.pixelSize: 12
                                        color: "gray"
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: sidePanel
            width: parent.width * 0.3
            height: parent.height
            color: "#34495e"

            Column {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 14

                Text {
                    text: "Details"
                    color: "white"
                    font.pixelSize: 24
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: 180
                    radius: 10
                    color: "#2c3e50"
                    clip: true

                    Image {
                        anchors.fill: parent
                        source: selectedImage
                        fillMode: Image.PreserveAspectFit
                    }
                }

                Text {
                    text: selectedName
                    color: "white"
                    font.pixelSize: 20
                    font.bold: true
                    wrapMode: Text.WordWrap
                    width: parent.width
                }

                Text {
                    text: selectedType
                    color: "#d6eaf8"
                    font.pixelSize: 14
                    width: parent.width
                }

                Text {
                    text: selectedExtra1
                    color: "white"
                    font.pixelSize: 14
                    wrapMode: Text.WordWrap
                    width: parent.width
                }

                Text {
                    text: selectedExtra2
                    color: "white"
                    font.pixelSize: 14
                    wrapMode: Text.WordWrap
                    width: parent.width
                }

            }
        }
    }

    Popup {
        id: descriptionPopup
        width: 500
        height: 300
        modal: true
        focus: true
        anchors.centerIn: Overlay.overlay
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: "white"
            radius: 12
            border.color: "#999999"
            border.width: 1
        }

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: selectedName
                font.pixelSize: 22
                font.bold: true
                color: "black"
                wrapMode: Text.WordWrap
                width: parent.width
            }

            ScrollView {
                width: parent.width
                height: 180

                Text {
                    text: selectedDescription
                    width: descriptionPopup.width - 60
                    wrapMode: Text.WordWrap
                    font.pixelSize: 15
                    color: "#333333"
                }
            }

            Button {
                text: "Close"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: descriptionPopup.close()
            }
        }
    }
    Rectangle {
    id: splashScreen
    anchors.fill: parent
    visible: showSplash
    z: 9999
    color: "black"

    MediaPlayer {
        id: splashPlayer
        source: "qrc:/assets/media/intro.mp4"
        videoOutput: splashVideo
        audioOutput: AudioOutput {
            volume: 1.0
        }

        onPlaybackStateChanged: {
            if (playbackState === MediaPlayer.StoppedState && showSplash)
                closeSplash()
        }

        onErrorOccurred: function(error, errorString) {
            console.log("Media error:", errorString)
        }
    }

    VideoOutput {
        id: splashVideo
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectFit
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.2
    }

    Button {
        text: "Skip"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        onClicked: closeSplash()
    }
}

}
