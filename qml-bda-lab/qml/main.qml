import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "theme"

ApplicationWindow {
    id: window
    visible: true
    width: 1024
    height: 768
    title: qsTr("BDA-Lab Ground Control Station")
    
    // Set application colors based on theme
    color: Theme.currentBackground
    
    header: ToolBar {
        background: Rectangle {
            color: Theme.primary
        }
        
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Theme.spacingM
            anchors.rightMargin: Theme.spacingM
            
            Text {
                text: qsTr("BDA-Lab GCS")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeTitleLarge
                font.weight: Theme.fontWeightMedium
                color: Theme.onPrimary
                Layout.fillWidth: true
            }
            
            Button {
                text: qsTr("Settings")
                font.family: Theme.fontFamily
                background: Rectangle {
                    color: Theme.secondary
                    radius: Theme.cornerRadiusS
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: Theme.onSecondary
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
    
    // Main content area
    ScrollView {
        anchors.fill: parent
        anchors.margins: Theme.spacingL
        
        ColumnLayout {
            width: parent.width - Theme.spacingL * 2
            spacing: Theme.spacingL
            
            // Welcome card
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                color: Theme.currentCardBackground
                radius: Theme.cornerRadiusM
                border.color: Theme.outline
                border.width: 1
                
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Theme.spacingM
                    
                    Text {
                        text: qsTr("Welcome to BDA-Lab")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeHeadlineMedium
                        font.weight: Theme.fontWeightMedium
                        color: Theme.primary
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: qsTr("Ground Control Station for MAVLink Vehicles")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeBodyLarge
                        color: Theme.currentOnSurface
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: qsTr("Theme: Emirates-inspired Red/Gold")
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeLabelMedium
                        color: Theme.secondary
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
            
            // Feature grid
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: Theme.spacingM
                rowSpacing: Theme.spacingM
                
                // Flight Planning Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    color: Theme.currentCardBackground
                    radius: Theme.cornerRadiusM
                    border.color: Theme.outline
                    border.width: 1
                    
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Theme.spacingS
                        
                        Text {
                            text: qsTr("Flight Planning")
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeTitleMedium
                            font.weight: Theme.fontWeightMedium
                            color: Theme.primary
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        Text {
                            text: qsTr("Plan and execute missions")
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeBodySmall
                            color: Theme.currentOnSurface
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
                
                // Vehicle Status Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    color: Theme.currentCardBackground
                    radius: Theme.cornerRadiusM
                    border.color: Theme.outline
                    border.width: 1
                    
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Theme.spacingS
                        
                        Text {
                            text: qsTr("Vehicle Status")
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeTitleMedium
                            font.weight: Theme.fontWeightMedium
                            color: Theme.primary
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        Text {
                            text: qsTr("Monitor telemetry data")
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeBodySmall
                            color: Theme.currentOnSurface
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
                
                // Map Display Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    color: Theme.currentCardBackground
                    radius: Theme.cornerRadiusM
                    border.color: Theme.outline
                    border.width: 1
                    
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Theme.spacingS
                        
                        Text {
                            text: qsTr("Map Display")
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeTitleMedium
                            font.weight: Theme.fontWeightMedium
                            color: Theme.primary
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        Text {
                            text: qsTr("Real-time position tracking")
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeBodySmall
                            color: Theme.currentOnSurface
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
                
                // MAVLink Communication Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    color: Theme.currentCardBackground
                    radius: Theme.cornerRadiusM
                    border.color: Theme.outline
                    border.width: 1
                    
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Theme.spacingS
                        
                        Text {
                            text: qsTr("MAVLink Communication")
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeTitleMedium
                            font.weight: Theme.fontWeightMedium
                            color: Theme.primary
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        Text {
                            text: qsTr("Connect via Bluetooth/Serial")
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeBodySmall
                            color: Theme.currentOnSurface
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
            
            // Action buttons
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.spacingM
                
                Button {
                    text: qsTr("Connect Vehicle")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeBodyMedium
                    background: Rectangle {
                        color: parent.pressed ? Qt.darker(Theme.primary, 1.2) : Theme.primary
                        radius: Theme.cornerRadiusS
                    }
                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: Theme.onPrimary
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                
                Button {
                    text: qsTr("Toggle Theme")
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeBodyMedium
                    background: Rectangle {
                        color: parent.pressed ? Qt.darker(Theme.secondary, 1.2) : Theme.secondary
                        radius: Theme.cornerRadiusS
                    }
                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: Theme.onSecondary
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        Theme.isDarkMode = !Theme.isDarkMode
                    }
                }
            }
        }
    }
}