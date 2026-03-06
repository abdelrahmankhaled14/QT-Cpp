# Game of Thrones Gallery – Qt Quick (QML) Application

## Project Overview

This project is a Qt Quick application implemented using QML and Qt Multimedia. The application displays Game of Thrones characters and dragons in a dynamic gallery interface. Data is loaded from JSON files embedded in the Qt Resource System and visualized using the Qt Model–View–Delegate architecture.

The application also includes a multimedia splash screen that plays a video with audio during startup.

The goal of this project is to demonstrate practical usage of Qt Quick UI components, dynamic data models, JSON parsing in QML, multimedia integration, and responsive layouts.

# Architecture

The application follows the Model–View–Delegate design pattern used in Qt Quick.

Model
 Stores structured data loaded from JSON files.

View
 Displays the model data using visual containers such as GridView.

Delegate
 Defines the visual template used to render each item inside the view.

Data flow:

JSON File → XMLHttpRequest → ListModel → GridView → Delegate UI

------

# Main Components

## ApplicationWindow

The root component of the UI. It manages global application state including:

- splash screen visibility
- selected item information
- data models for dragons and characters

Key properties used for UI state management:

```
property bool showSplash
property string selectedName
property string selectedImage
property string selectedType
property string selectedExtra1
property string selectedExtra2
property string selectedDescription
```

These properties allow the UI to reactively update when the selected item changes.

# Data Models

Two QML ListModel objects are used to store application data.

```
ListModel { id: dragonsModel }
ListModel { id: characterModel }
```

Each model contains structured entries loaded from the corresponding JSON file.

Example dragon model item:

```
{
    itemId: 1,
    name: "Drogon",
    image: "qrc:/assets/dragons/drogon.jpg",
    extra1Label: "Rider",
    extra1Value: "Daenerys Targaryen",
    extra2Label: "Nickname",
    extra2Value: "Named after Khal Drogo",
    description: "...",
    type: "Dragon"
}
```

Example character model item:

```
{
    itemId: 1,
    name: "Jon Snow",
    image: "qrc:/assets/characters/jon.jpg",
    extra1Label: "House",
    extra1Value: "Stark",
    extra2Label: "Title",
    extra2Value: "King in the North",
    description: "...",
    type: "Character"
}
```

------

# JSON Data Loading

Data is loaded from embedded JSON files using XMLHttpRequest.

Example:

```
xhr.open("GET", "qrc:/assets/data/dragons.json")
```

Steps performed during parsing:

1. Send HTTP request to resource path
2. Wait for `XMLHttpRequest.DONE`
3. Parse JSON response
4. Clear existing model
5. Append items into ListModel

Example parsing logic:

```
for (let i = 0; i < obj.dragons.length; i++) {
    dragonsModel.append({
        itemId: d.id,
        name: d.name,
        image: "qrc:/" + d.image,
        ...
    })
}
```

------

# Gallery Implementation

The main content area uses GridView to render gallery items.

```
GridView {
    model: dragonsModel
    delegate: Rectangle { ... }
}
```

GridView dynamically creates delegate instances based on the number of items in the model.

Layout configuration:

```
cellWidth: (galleryArea.width - 60) / 2
cellHeight: 190
```

Each delegate displays:

- image
- item name
- secondary attribute

# Delegate Interaction

Each gallery card contains a MouseArea component.

Supported interactions:

Hover
 Updates the side panel with item details.

```
onEntered: selectItem(model)
```

Click
 Opens a popup dialog containing the full item description.

```
onClicked: {
    selectItem(model)
    descriptionPopup.open()
}
```

# Tab Navigation and Page Switching

The gallery supports two datasets: dragons and characters.

Navigation is implemented using:

TabBar
 Allows switching between datasets.

SwipeView
 Contains two pages corresponding to each dataset.

Structure:

```
TabBar
    Dragons
    Characters

SwipeView
    Page 1 → Dragons GridView
    Page 2 → Characters GridView
```

SwipeView enables both tab-based and gesture-based navigation.

# Layout Design

The main layout divides the window into two sections.

Left section (70%)

Contains the gallery interface.

Right section (30%)

Displays details of the currently selected item.

Layout hierarchy:

```
Row
 ├─ Gallery Area (70%)
 │   ├─ TabBar
 │   └─ SwipeView
 │       ├─ Dragons Grid
 │       └─ Characters Grid
 │
 └─ Details Panel (30%)
```

------

# Details Panel

The details panel is bound to the selected item properties.

Displayed information includes:

- item image
- item name
- item type
- two metadata attributes

Data binding allows automatic updates when `selectItem()` is triggered.

# Description Popup

Clicking a gallery item opens a Popup dialog.

Popup characteristics:

- modal
- centered overlay
- scrollable description text
- close button

Popup configuration:

```
Popup {
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
}
```

# Splash Screen

The application displays a startup splash screen containing a video.

The splash screen is implemented using Qt Multimedia.

Components used:

MediaPlayer
 Handles video playback and audio.

VideoOutput
 Displays video frames.

Example configuration:

```
MediaPlayer {
    source: "qrc:/assets/media/intro.mp4"
    videoOutput: splashVideo
    audioOutput: AudioOutput {}
}
```

Splash screen visibility is controlled using the `showSplash` property.

The splash screen closes when:

- the video playback finishes
- the user presses the Skip button

# Resource System

All application assets are embedded using the Qt Resource System (QRC).

This allows resources to be accessed using the `qrc:` protocol.

Example resource paths:

```
qrc:/assets/data/dragons.json
qrc:/assets/data/characters.json
qrc:/assets/dragons/drogon.jpg
qrc:/assets/media/intro.mp4
```

The QRC file is registered in CMake to include these resources in the application binary.

------

# Build System

The project uses CMake for building the Qt application.

The resource file is added to the build configuration so that assets are embedded during compilation.

Example usage in CMake:

```
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)
```