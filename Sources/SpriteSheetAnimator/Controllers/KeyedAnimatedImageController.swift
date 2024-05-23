//
//  File.swift
//  
//
//  Created by Lukas Simonson on 5/2/23.
//

import Foundation
import UIKit

/// A controller class for managing animations from a given sprite sheet image.
///
/// `KeyedAnimatedImageController` provides functionality to control and manage animations
/// defined by keys, along with handling errors related to animation playback.
///
/// - Parameter KeyType: A `Hashable` type used to identify different animations within the controller.
public class KeyedAnimatedImageController<KeyType: Hashable>: AnimatedImageController {
    
    /// The currently selected animation frames.
    public var currentAnimation: AnimationFrames?
    
    /// The key of the currently selected animation.
    public var currentAnimationKey: KeyType
    
    /// A dictionary containing animations mapped to their respective keys.
    public var animations = [KeyType : AnimationFrames]()
    
    /// Initializes a `KeyedAnimatedImageController` with a sprite sheet, frame size, default animation, animations dictionary, and animation playback settings.
    ///
    /// - Parameters:
    ///   - spriteSheet: The `UIImage` containing the sprite sheet.
    ///   - frameSize: The size of each frame in the sprite sheet.
    ///   - defaultAnimation: The key for the default animation to be played.
    ///   - animations: A dictionary mapping animation keys to `AnimationFrames`.
    ///   - animationFPS: The frame rate of the animation in frames per second.
    ///   - animationLoop: The run loop used for animation playback.
    ///   - animationLoopMode: The mode of the run loop used for animation playback.
    public init(
        _ spriteSheet: UIImage,
        frameSize: CGSize,
        defaultAnimation: KeyType,
        animations: [KeyType : AnimationFrames],
        animationFPS: Float,
        animationLoop: RunLoop,
        animationLoopMode: RunLoop.Mode
    ) {
        self.currentAnimationKey = defaultAnimation
        super.init(spriteSheet, frameSize: frameSize, startingFrame: .zero, animationFPS: animationFPS, animationLoop: animationLoop, animationLoopMode: animationLoopMode)
        self.animations = animations
        self.currentAnimation = animations[defaultAnimation]
    }
    
    /// Initializes a `KeyedAnimatedImageController` with a keyed sprite sheet, default animation, and animation playback settings.
    ///
    /// - Parameters:
    ///   - sheet: The `KeyedSpriteSheet` that defines the sprite sheet and its animations.
    ///   - defaultAnimation: The key for the default animation to be played.
    ///   - animationLoop: The run loop used for animation playback.
    ///   - animationLoopMode: The mode of the run loop used for animation playback.
    public init<S: KeyedSpriteSheet>(
        using sheet: S,
        defaultAnimation: KeyType,
        animationLoop: RunLoop,
        animationLoopMode: RunLoop.Mode
    ) where S.Key == KeyType {
        self.currentAnimationKey = defaultAnimation
        super.init(sheet.sheet, frameSize: sheet.frameSize, startingFrame: .zero, animationFPS: 30, animationLoop: animationLoop, animationLoopMode: animationLoopMode)
        self.animations = sheet.animations
        self.currentAnimation = animations[defaultAnimation]
    }
    
    /// Attempts to play the animation corresponding to the provided animation key.
    ///
    /// - Parameter animationKey: The key of the animation to play.
    /// - Throws: A `KeyedAnimationError` if the animation key is not found in the controller's animations dictionary.
    public func play(_ animationKey: KeyType) throws {
        guard let animation = animations[animationKey]
        else { throw KeyedAnimationError.noAnimationFoundForKey(animationKey) }
        
        self.currentAnimation = animation
        self.currentAnimationKey = animationKey
        play()
    }
    
    @objc override public func nextFrame() {
        guard currentAnimation != nil
        else { fatalError("No Animation Selected To Play") }
        
        self.currentAnimation!.nextFrame()
        self.currentFrame = self.currentAnimation!.getFrame()
        
        showFrame(self.currentFrame)
    }
    
    @objc override public func previousFrame() {
        guard currentAnimation != nil
        else { fatalError("No Animation Selected To Play") }
        
        self.currentAnimation!.previousFrame()
        self.currentFrame = self.currentAnimation!.getFrame()
        
        showFrame(self.currentFrame)
    }
}

extension KeyedAnimatedImageController {
    
    /// An enumeration defining errors related to keyed animations.
    enum KeyedAnimationError: Error {
        /// Indicates that no animation was found for the provided key.
        case noAnimationFoundForKey(KeyType)
    }
}

extension KeyedAnimatedImageController {
    
    /// Adds an animation to the controller's animations dictionary using individual frame coordinates.
    ///
    /// - Parameters:
    ///   - key: The key for the animation to be added.
    ///   - frames: An `AnimationFrames`
    public func addAnimation(_ key: KeyType, frames: AnimationFrames) {
        animations[key] = frames
    }
}

extension KeyedAnimatedImageController {
    /// Adds an animation to the controller's animations dictionary using individual frame coordinates.
    ///
    /// - Parameters:
    ///   - key: The key for the animation to be added.
    ///   - frames: An array of `CGPoint` coordinates representing frames in the sprite sheet.
    @available(*, deprecated, renamed: "addAnimation(key:frames:)")
    public func addAnimation(_ key: KeyType, frames: [CGPoint]) {
        animations[key] = AnimationFrames(frames: frames)
    }
    
    /// Adds an animation to the controller's animations dictionary using a row and a number of frames.
    ///
    /// - Parameters:
    ///   - key: The key for the animation to be added.
    ///   - row: The row index in the sprite sheet containing the animation frames.
    ///   - frames: The number of frames in the animation.
    @available(*, deprecated, renamed: "addAnimation(key:frames:)")
    public func addAnimation(_ key: KeyType, row: Int, numFrames frames: Int) {
        addAnimation(key, row: row, trailingColumn: frames - 1)
    }
    
    /// Adds an animation to the controller's animations dictionary using a row and leading and trailing columns.
    ///
    /// - Parameters:
    ///   - key: The key for the animation to be added.
    ///   - row: The row index in the sprite sheet containing the animation frames.
    ///   - leading: The index of the leading frame column.
    ///   - trailingColumn: The index of the trailing frame column.
    @available(*, deprecated, renamed: "addAnimation(key:frames:)")
    public func addAnimation(_ key: KeyType, row: Int, leadingColumn leading: Int = 0, trailingColumn: Int? = nil) {
        let trailing: Int
        if let trailingColumn = trailingColumn {
            trailing = trailingColumn
        } else {
            trailing = Int(maxFrameX - 1)
        }

        var frames = [CGPoint]()
        for num in leading...trailing {
            frames.append(CGPoint(x: num, y: row))
        }

        addAnimation(key, frames: frames)
    }
}
