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

#include "app_icon.h"
#include <QImageReader>
#include <QPixmap>

QIcon appIcon()
{
    QIcon icon;
    static const int sizes[] = {16, 24, 32, 48, 64, 128, 256, 512};
    for (int size : sizes) {
        QImageReader reader(QStringLiteral(":/qt/qml/Orchard/app/qml/assets/nebula-music.png"));
        reader.setScaledSize(QSize(size, size));
        const QImage image = reader.read();
        if (!image.isNull()) {
            icon.addPixmap(QPixmap::fromImage(image));
        }
    }
    return icon;
}
