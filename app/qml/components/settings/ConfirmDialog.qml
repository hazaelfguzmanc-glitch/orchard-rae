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

// Modal confirmation for settings that cost bandwidth or delete data.
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

    property string title
    property string message
    property string confirmText: qsTr("Confirm")
    property bool destructive: false

    signal accepted

    parent: Overlay.overlay
    anchors.centerIn: parent
    width: Math.min(420, parent.width - 48)
    padding: 22
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    Overlay.modal: Rectangle {
        color: "#80000000"
    }



    background: Rectangle {
        color: OrchardAppearance.popupColor
        radius: 14
        border.color: "#35ffffff"
        border.width: 1
    }

    contentItem: ConfirmDialogBody {
        title: root.title
        message: root.message
        confirmText: root.confirmText
        destructive: root.destructive
        cancelButton.onClicked: root.close()
        confirmButton.onClicked: {
            root.close();
            root.accepted();
        }
    }
}
