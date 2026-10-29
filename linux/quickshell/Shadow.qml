import QtQuick
import QtQuick.Effects

// Soft drop shadow behind a floating panel; place it before the panel and fill it
RectangularShadow {
    radius: Theme.radius
    blur: 20
    spread: -2
    offset.y: 6
    color: Theme.shadow
}
