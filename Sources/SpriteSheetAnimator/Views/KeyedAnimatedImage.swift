//
//  File.swift
//  
//
//  Created by Lukas Simonson on 5/23/24.
//

import SwiftUI

/// A SwiftUI view that displays an animated image using an `KeyedAnimatedImageController`.
///
/// `KeyedAnimatedImage` uses a `KeyedAnimatedImageController` to manage animation and provides
/// customization options for displaying each frame and a placeholder view when there
/// is no frame.
///
/// - Parameters:
///   - FrameImage: A view that displays a frame of the animation.
///   - FrameEmpty: A view that is displayed when there is no frame available.
///   - KeyType: A `Hashable` type that is used to identify different animations within a sprite sheet.
public struct KeyedAnimatedImage<FrameImage: View, FrameEmpty: View, KeyType: Hashable>: View {
    
    /// An environment value indicating which animation should be played.
    @Environment(\.animatedImageAnimation) var imageAnimationKey
    
    /// The `KeyedAnimatedImageController` the manages animation playback.
    @StateObject private var imageController: KeyedAnimatedImageController<KeyType>
    
    /// The `View` to display for each frame of the animation.
    let frameImage: (Image) -> FrameImage
    
    /// The `View` to display when there is no frame to display from the `imageController`.
    let frameEmpty: () -> FrameEmpty
    
    public var body: some View {
        ControlledAnimatedImage(imageController: imageController, frameImage: frameImage, frameEmpty: frameEmpty)
            .onReceive(imageAnimationKey.publisher, perform: setAnimation)
    }
    
    func setAnimation(_ animation: (any Hashable)?) {
        
        // Checks if the environment provided value is the right kind of Key.
        guard let animation = animation as? KeyType,
              animation != imageController.currentAnimationKey
        else { return }
        
        // Attemps to play the animation and crashes if a key that wasn't provided is used.
        do {
            try imageController.play(animation)
        } catch {
            fatalError("KeyedAnimatedImage() was given an invalid animation to play.")
        }
    }
}

public extension KeyedAnimatedImage {
    
    /// Initializes a `KeyedAnimatedImage` with a sprite sheet, frame size, default animation, keyed animations,
    /// and custom views for frame display and empty frames.
    ///
    /// This initializer allows you to create a `KeyedAnimatedImage` by specifying a sprite sheet image,
    /// the size of each frame, a default animation key, and a dictionary of keyed animations. You can also
    /// customize the run loop and its mode for the animation.
    ///
    /// - Parameters:
    ///   - sheet: The `UIImage` containing the sprite sheet.
    ///   - frameSize: The size of each frame in the sprite sheet.
    ///   - defaultAnimation: The key for the default animation to be played.
    ///   - keyedAnimations: A dictionary mapping keys to `AnimationFrames`, defining the animations in the sprite sheet.
    ///   - runLoop: The run loop used for the animation playback. Default is `.main`.
    ///   - runLoopMode: The mode of the run loop used for animation playback. Default is `.common`.
    ///   - frameImage: A closure that provides a view to display for each frame of the animation.
    ///   - frameEmpty: A closure that provides a view to display when there is no frame available.
    public init(
        _ sheet: UIImage,
        frameSize: CGSize,
        defaultAnimation: KeyType,
        keyedAnimations: [KeyType: AnimationFrames],
        runLoop: RunLoop = .main,
        runLoopMode: RunLoop.Mode = .common,
        frameImage: @escaping (Image) -> FrameImage,
        frameEmpty: @escaping () -> FrameEmpty
    ) {
        self._imageController = StateObject(wrappedValue: KeyedAnimatedImageController(
            sheet,
            frameSize: frameSize,
            defaultAnimation: defaultAnimation,
            animations: keyedAnimations,
            animationFPS: 30,
            animationLoop: runLoop,
            animationLoopMode: runLoopMode
        ))
        
        self.frameImage = frameImage
        self.frameEmpty = frameEmpty
    }
    
    /// Initializes a `KeyedAnimatedImage` with a sprite sheet, frame size, default animation, keyed animations,
    /// and custom views for frame display and empty frames.
    ///
    /// This initializer allows you to create a `KeyedAnimatedImage` by specifying a sprite sheet image,
    /// the size of each frame, a default animation key, and a dictionary of keyed animations. You can also
    /// customize the run loop and its mode for the animation.
    ///
    /// - Parameters:
    ///   - sheet: The `UIImage` containing the sprite sheet.
    ///   - frameSize: The size of each frame in the sprite sheet.
    ///   - defaultAnimation: The key for the default animation to be played.
    ///   - keyedAnimations: A dictionary mapping keys to `AnimationFrames`, defining the animations in the sprite sheet.
    ///   - runLoop: The run loop used for the animation playback. Default is `.main`.
    ///   - runLoopMode: The mode of the run loop used for animation playback. Default is `.common`.
    ///   - frameImage: A closure that provides a view to display for each frame of the animation.
    public init(
        _ sheet: UIImage,
        frameSize: CGSize,
        defaultAnimation: KeyType,
        keyedAnimations: [KeyType: AnimationFrames],
        runLoop: RunLoop = .main,
        runLoopMode: RunLoop.Mode = .common,
        frameImage: @escaping (Image) -> FrameImage
    ) where FrameEmpty == Color {
        self._imageController = StateObject(wrappedValue: KeyedAnimatedImageController(
            sheet,
            frameSize: frameSize,
            defaultAnimation: defaultAnimation,
            animations: keyedAnimations,
            animationFPS: 30,
            animationLoop: runLoop,
            animationLoopMode: runLoopMode
        ))
        
        self.frameImage = frameImage
        self.frameEmpty = { Color.clear }
    }
    
    /// Initializes a `KeyedAnimatedImage` with a keyed sprite sheet, default animation, and custom views for frame display and empty frames.
    ///
    /// This initializer allows you to create a `KeyedAnimatedImage` by specifying a keyed sprite sheet,
    /// a default animation key, and closures for custom views for each frame and empty frames.
    /// You can also customize the run loop and its mode for the animation.
    ///
    /// - Parameters:
    ///   - sheet: The `KeyedSpriteSheet` that defines the sprite sheet and its animations.
    ///   - defaultAnimation: The key for the default animation to be played.
    ///   - runLoop: The run loop used for the animation playback. Default is `.main`.
    ///   - runLoopMode: The mode of the run loop used for animation playback. Default is `.common`.
    ///   - frameImage: A closure that provides a view to display for each frame of the animation.
    ///   - frameEmpty: A closure that provides a view to display when there is no frame available.
    public init<S: KeyedSpriteSheet>(
        _ sheet: S,
        defaultAnimation: KeyType,
        runLoop: RunLoop = .main,
        runLoopMode: RunLoop.Mode = .common,
        frameImage: @escaping (Image) -> FrameImage,
        frameEmpty: @escaping () -> FrameEmpty
    ) where S.Key == KeyType {
        self._imageController = StateObject(wrappedValue: KeyedAnimatedImageController(
            using: sheet,
            defaultAnimation: defaultAnimation,
            animationLoop: runLoop,
            animationLoopMode: runLoopMode
        ))
        self.frameImage = frameImage
        self.frameEmpty = frameEmpty
    }
    
    /// Initializes a `KeyedAnimatedImage` with a keyed sprite sheet, default animation, and custom views for frame display and empty frames.
    ///
    /// This initializer allows you to create a `KeyedAnimatedImage` by specifying a keyed sprite sheet,
    /// a default animation key, and a clsure for the view of each frame.
    /// You can also customize the run loop and its mode for the animation.
    ///
    /// - Parameters:
    ///   - sheet: The `KeyedSpriteSheet` that defines the sprite sheet and its animations.
    ///   - defaultAnimation: The key for the default animation to be played.
    ///   - runLoop: The run loop used for the animation playback. Default is `.main`.
    ///   - runLoopMode: The mode of the run loop used for animation playback. Default is `.common`.
    ///   - frameImage: A closure that provides a view to display for each frame of the animation.
    public init<S: KeyedSpriteSheet>(
        _ sheet: S,
        defaultAnimation: KeyType,
        runLoop: RunLoop = .main,
        runLoopMode: RunLoop.Mode = .common,
        frameImage: @escaping (Image) -> FrameImage
    ) where S.Key == KeyType, FrameEmpty == Color {
        self._imageController = StateObject(wrappedValue: KeyedAnimatedImageController(
            using: sheet,
            defaultAnimation: defaultAnimation,
            animationLoop: runLoop,
            animationLoopMode: runLoopMode
        ))
        self.frameImage = frameImage
        self.frameEmpty = { Color.clear }
    }
}
