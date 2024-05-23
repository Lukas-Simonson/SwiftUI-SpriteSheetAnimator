# SpriteSheetAnimator
A SwiftUI package for animating sprite sheets!

## Installation

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the Swift compiler.

To add [SwiftUI-Navigation-Router](https://github.com/Lukas-Simonson/SwiftUI-Navigation-Router) to your project do the following.
- Open Xcode
- Click on `File -> Add Packages`
- Use this repositories URL (https://github.com/Lukas-Simonson/SwiftUI-Navigation-Router.git) in the top right of the window to download the package.
- When prompted for a Version or a Branch, we suggest you use the branch: main
  - If you need, or want to try some experimental features, you can use the branch: dev


## Quickstart Guide

### Animating A Single Row Sprite Sheet

This package is meant to handle image sheets. Many of these sheets may only be a single animation that you want to loop. Like the sheet below:

[SawImage](https://github.com/Lukas-Simonson/SwiftUI-SpriteSheetAnimator/blob/main/Static/notices.gif)

For these sheets things can be kept very simple. You can use the `AnimatedImage` view to animate and show one of these sheets.

`AnimatedImage` takes a couple of required parameters.
    - sheet: A UIImage that is the sheet you want to animate.
    - frameSize: The size of a single frame within the sheet.
    - frameImage: A closure that provides a `SwiftUI.Image` that you can customize.
    - frameEmpty(Can be skipped if you want to provide just an empty view): A clsoure that provides what View you want displayed if there is no image to display.

```swift
import SwiftUI
import SpriteSheetAnimator

struct SawView: View {
    var body: some View {
        AnimatedImage(UIImage(named: "saw")!, frameSize: CGSize(width: 38, height: 38)) { image in
            image
                .interpolation(.none)               // Keep Pixel Art Style
                .resizable()                        // Resize the image
                .aspectRatio(contentMode: .fit)     // Keep Aspect Ratio
        }
    }
}
```
