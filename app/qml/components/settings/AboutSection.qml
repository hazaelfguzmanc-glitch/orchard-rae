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

// Credits and bundled licenses. Layout lives in AboutSectionForm.ui.qml.
AboutSectionForm {
    id: root

    // The settings popup closes and opens the release notes window.
    signal releaseNotesRequested

    appVersion: Qt.application.version
    releaseNotes: OrchardReleaseNotes
    releaseSummary: root.summarize(OrchardReleaseNotes, Qt.application.version)

    function summarize(releases, installed) {
        if (releases.length === 0)
            return qsTr("No release notes are included with this build.");
        const current = releases.find(release => release.version === installed);
        return current
            ? qsTr("Installed: %1, %2. Browse every release, including older ones. Works offline.").arg(current.version).arg(current.title)
            : qsTr("Browse what changed in each release. Works offline.");
    }

    function showLicenseModal(title, key) {
        licenseModal.licenseTitle = title;
        licenseModal.licenseText = OrchardBackend.licenseText(key);
        licenseModal.open();
    }

    releaseNotesButton.onClicked: root.releaseNotesRequested()
    orchardLinkButton.onClicked: Qt.openUrlExternally("https://sfg545.dev/orchard")
    orchardLicenseButton.onClicked: root.showLicenseModal(qsTr("Orchard License (AGPL-3.0)"), "orchard")

    licenseList.delegate: SettingsLicenseCard {
        required property var modelData
        name: modelData.name
        license: modelData.license
        blurb: modelData.description
        linkButton.onClicked: Qt.openUrlExternally(modelData.url)
        licenseButton.onClicked: root.showLicenseModal(modelData.name + " (" + modelData.license + ")", modelData.key)
    }

    // Modal License Viewer
    Popup {
        id: licenseModal
        transformOrigin: Popup.Top
        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Motion.popoverIn; easing.type: Motion.enter }
            NumberAnimation { property: "scale"; from: Motion.popoverFrom; to: 1; duration: Motion.popoverIn; easing.type: Motion.enter }
        }
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Motion.popoverOut; easing.type: Motion.exit }
            NumberAnimation { property: "scale"; from: 1; to: Motion.popoverFrom; duration: Motion.popoverOut; easing.type: Motion.exit }
        }

        property string licenseTitle: ""
        property string licenseText: ""

        parent: Overlay.overlay
        anchors.centerIn: parent
        width: Math.min(760, parent.width - 48)
        height: Math.min(540, parent.height - 64)
        padding: 20
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

        contentItem: LicenseViewer {
            licenseTitle: licenseModal.licenseTitle
            licenseText: licenseModal.licenseText
            copied: copyTimer.running
            closeButton.onClicked: licenseModal.close()
            copyButton.onClicked: {
                textArea.selectAll();
                textArea.copy();
                textArea.deselect();
                copyTimer.restart();
            }

            Timer {
                id: copyTimer
                interval: 1800
            }
        }
    }
}
