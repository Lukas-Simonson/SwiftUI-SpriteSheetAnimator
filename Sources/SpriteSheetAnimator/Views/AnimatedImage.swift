//
//  File.swift
//  
//
//  Created by Lukas Simonson on 5/23/24.
//

import SwiftUI

/// A SwiftUI view that displays an animated image using an `AnimatedImageController`.
///
/// `AnimatedImage` uses an `AnimatedImageController` to manage animation and provides
/// customization options for displaying each frame and a placeholder view when there
/// is no frame.
///
/// - Parameters:
///   - FrameImage: A view that displays a frame of the animation.
///   - FrameEmpty: A view that is displayed when there is no frame available.
public struct AnimatedImage<FrameImage: View, FrameEmpty: View>: View {
    
    /// The controller for managing the animation playback.
    @StateObject var imageController: AnimatedImageController
    
    /// The `View` to display for each frame of the animation.
    let frameImage: (Image) -> FrameImage
    
    /// The `View` to display when there is no frame to display from the `imageController`
    let frameEmpty: () -> FrameEmpty
    
    public var body: some View {
        ControlledAnimatedImage(imageController: imageController, frameImage: frameImage, frameEmpty: frameEmpty)
    }
}

extension AnimatedImage {
    
    /// Initializes an `AnimatedImage` view using a sprite sheet image and frame size.
    ///
    /// This initializer creates an `AnimatedImage` view with the specified sprite sheet,
    /// frame size, and run loop configuration. The `frameImage` and `frameEmpty` closures
    /// are used to define the views that display each frame of the animation and a placeholder
    /// when there is no frame available, respectively.
    ///
    /// - Parameters:
    ///   - spriteSheet: The `UIImage` containing the sprite sheet for the animation frames.
    ///   - frameSize: The size of each frame in the sprite sheet.
    ///   - runLoop: The `RunLoop` used for the animation playback. Defaults to `.main`.
    ///   - runLoopMode: The `RunLoop.Mode` used for the animation playback. Defaults to `.common`.
    ///   - frameImage: A closure that returns a view to display for each frame of the animation.
    ///     - Parameter image: An `Image` representing the current frame of the animation.
    ///   - frameEmpty: A closure that returns a view to display when there is no frame available.
    ///
    /// - Returns: An `AnimatedImage` view configured with the specified parameters.
    ///
    /// - Example:
    ///   ```swift
    ///   AnimatedImage(
    ///       spriteSheet,
    ///       frameSize: CGSize(width: 64, height: 64),
    ///       frameImage: { image in
    ///           image
    ///               .resizable()
    ///               .scaledToFit()
    ///       },
    ///       frameEmpty: {
    ///           Text("No frame available")
    ///       }
    ///   )
    ///   ```
    public init(
        _ spriteSheet: UIImage,
        frameSize: CGSize,
        runLoop: RunLoop = .main,
        runLoopMode: RunLoop.Mode = .common,
        frameImage: @escaping (Image) -> FrameImage,
        frameEmpty: @escaping () -> FrameEmpty
    ) {
        self._imageController = StateObject(wrappedValue: AnimatedImageController(
            spriteSheet,
            frameSize: frameSize,
            animationLoop: runLoop,
            animationLoopMode: runLoopMode
        ))
        self.frameImage = frameImage
        self.frameEmpty = frameEmpty
    }
    
    /// Initializes an `AnimatedImage` view using a sprite sheet image and frame size.
    ///
    /// This initializer creates an `AnimatedImage` view with the specified sprite sheet,
    /// frame size, and run loop configuration. The `frameImage` closure is used to define
    /// the view that displays each frame of the animation. If there is no frame, nothing will be shown.
    ///
    /// - Parameters:
    ///   - spriteSheet: The `UIImage` containing the sprite sheet for the animation frames.
    ///   - frameSize: The size of each frame in the sprite sheet.
    ///   - runLoop: The `RunLoop` used for the animation playback. Defaults to `.main`.
    ///   - runLoopMode: The `RunLoop.Mode` used for the animation playback. Defaults to `.common`.
    ///   - frameImage: A closure that returns a view to display for each frame of the animation.
    ///     - Parameter image: An `Image` representing the current frame of the animation.
    ///   - frameEmpty: A closure that returns a view to display when there is no frame available.
    ///
    /// - Returns: An `AnimatedImage` view configured with the specified parameters.
    ///
    /// - Example:
    ///   ```swift
    ///   AnimatedImage(
    ///       spriteSheet,
    ///       frameSize: CGSize(width: 64, height: 64),
    ///       frameImage: { image in
    ///           image
    ///               .resizable()
    ///               .scaledToFit()
    ///       },
    ///       frameEmpty: {
    ///           Text("No frame available")
    ///       }
    ///   )
    ///   ```
    public init(
        _ spriteSheet: UIImage,
        frameSize: CGSize,
        runLoop: RunLoop = .main,
        runLoopMode: RunLoop.Mode = .common,
        frameImage: @escaping (Image) -> FrameImage
    ) where FrameEmpty == Color {
        self._imageController = StateObject(wrappedValue: AnimatedImageController(
            spriteSheet,
            frameSize: frameSize,
            animationLoop: runLoop,
            animationLoopMode: runLoopMode
        ))
        self.frameImage = frameImage
        self.frameEmpty = { Color.clear }
    }
}
