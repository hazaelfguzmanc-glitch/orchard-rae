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

pragma ComponentBehavior: Bound
import Orchard
import QtQuick
import QtQuick.Controls

// Modal panel on frosted glass, or a solid one with frosted off. Subclasses set the size and the content item.
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
    required property Item backdrop
    property bool frosted: true

    parent: Overlay.overlay
    anchors.centerIn: parent
    padding: 0
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    Overlay.modal: Rectangle {
        color: "#66000000"
    }



    background: Loader {
        active: root.visible
        sourceComponent: root.frosted ? frostedSurface : solidSurface
    }

    Component {
        id: solidSurface

        Rectangle {
            radius: 20
            color: OrchardAppearance.popupColor
            border.color: "#1cffffff"
            border.width: 1
        }
    }

    Component {
        id: frostedSurface

        Item {
            Glass {
                anchors.fill: parent
                backdrop: root.backdrop
                // Track the backdrop so artwork keeps moving behind the blur.
                live: true
                // Reading surface: dim and flat so the lens never competes with the text.
                brightness: -0.35
                blurRadius: 36
                refraction: 0.3
                chromaticAberration: 0.0
                edgeHighlight: 0.15
                fresnel: 0.25
            }
            Rectangle {
                anchors.fill: parent
                radius: 20
                color: Qt.alpha(OrchardAppearance.popupColor, 1 - OrchardAppearance.popupTranslucency)
                border.color: "#1cffffff"
                border.width: 1
            }
        }
    }
}
