/*
 * Copyright (C) 2026 SFG545
 *
 * This file is part of Orchard.
 *
 * Orchard is free software: you can redistribute it and/or modify it under the
 * terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * Orchard is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with Orchard. If not, see <https://www.gnu.org/licenses/>.
 */

import Orchard
import QtQuick
import QtQuick.Controls

// Vertical volume slider that opens below the player bar volume button.
Popup {
    id: root
    transformOrigin: Popup.Top
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Motion.popoverIn; easing.type: Motion.enter }
        NumberAnimation { property: "scale"; from: Motion.popoverFrom; to: 1; duration: Motion.popoverIn; easing.type: Motion.enter }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Motion.popoverOut; easing.type: Motion.exit }
        NumberAnimation { property: "scale"; from: 1; to: Motion.popoverFrom; duration: Motion.popoverOut; easing.type: Motion.exit }
    }

    // The player bar owns the colours and the volume helpers.
    required property Item bar

    property bool pointerInside: false
    HoverHandler { onHoveredChanged: root.pointerInside = hovered }

    width: 168
    height: 44
    padding: 0
    x: parent.width - width
    y: -height - 8
    // Presses on the volume button toggle the popup instead of dismissing it.
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent



    background: Rectangle {
        radius: 14
        color: Qt.alpha(OrchardAppearance.popupColor, 0.95)
        border.color: "#1cffffff"
        border.width: 1
    }

    contentItem: Item {
        Slider {
            id: slider

            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            orientation: Qt.Horizontal
            from: 0
            to: 1
            stepSize: 0.01
            hoverEnabled: true
            value: root.bar.volumeLevel
            onMoved: root.bar.setVolumeLevel(value)
            Accessible.name: qsTr("Volume")

            // One wheel notch is 5%.
            WheelHandler {
                target: null
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: function(event) {
                    const step = (event.inverted ? -event.angleDelta.y : event.angleDelta.y) / 120 * 0.05;
                    root.bar.setVolumeLevel(Math.max(0, Math.min(1, root.bar.volumeLevel + step)));
                }
            }

            background: Item {
                x: slider.leftPadding
                y: slider.topPadding
                width: slider.availableWidth
                height: slider.availableHeight

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 4
                    radius: height / 2
                    color: root.bar.trackColor

                    Rectangle {
                        anchors.left: parent.left
                        width: slider.position * parent.width
                        height: parent.height
                        radius: parent.radius
                        color: root.bar.accentColor
                    }
                }
            }

            handle: Rectangle {
                x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                width: 12
                height: 12
                radius: width / 2
                scale: slider.pressed ? 1.15 : 1
                color: root.bar.accentColor

                Behavior on scale {
                    NumberAnimation { duration: 90; easing.type: Easing.OutCubic }
                }
            }
        }
    }
}
