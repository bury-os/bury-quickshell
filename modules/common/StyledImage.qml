import qs.modules.common
import QtQuick
import Quickshell

Image {
  property list<string> fallbacks: []
  property int currentFallbackIndex: 0

  asynchronous: true
  retainWhileLoading: true
  visible: opacity > 0
  opacity: (status === Image.Ready) ? 1 : 0

  Behavior on opacity {
    animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
  }

  onStatusChanged: {
    if ((status === Image.Error || status === Image.Null) && currentFallbackIndex < fallbacks.length) {
      source = fallbacks[currentFallbackIndex];
      currentFallbackIndex += 1;
    }
  }

  sourceSize: {
    const dpr = (QsWindow.window as QsWindow)?.devicePixelRatio ?? 1;
    return Qt.size(width * dpr, height * dpr);
  }
}