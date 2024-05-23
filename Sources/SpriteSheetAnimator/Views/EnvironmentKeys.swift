//
//  File.swift
//  
//
//  Created by Lukas Simonson on 5/23/24.
//

import SwiftUI

/// A struct to store the various `EnvironmentKey`s that are used to control sprite sheet animations.
private struct AnimatedImageKey {
    
    /// The `EnvironmentKey` that controls if a sprite sheet animation is playing or not.
    struct Playing: EnvironmentKey {
        static let defaultValue: Bool = true
    }
    
    /// The `EnvironmentKey` that controls the frames per second that a sprite sheet animation is running at.
    struct FPS: EnvironmentKey {
        static let defaultValue: Float = 30
    }
    
    /// The `EnvironmentKey` that controls which animation a `KeyedAnimatedImage` is currently playing.
    struct Animation: EnvironmentKey {
        static let defaultValue: (any Hashable)? = nil
    }
}

/// Extensions to `EnvironmentValues` to add sprite sheet animation information into the `SwiftUI` `Environment`.
internal extension EnvironmentValues {
    
    /// The environment value that controls if a sprite sheet animation is playing or not.
    var animatedImagePlaying: Bool {
        get { self[AnimatedImageKey.Playing.self] }
        set { self[AnimatedImageKey.Playing.self] = newValue }
    }
    
    /// The environment value that controls the frames per second that a sprite sheet animation is running at.
    var animatedImageFPS: Float {
        get { self[AnimatedImageKey.FPS.self] }
        set { self[AnimatedImageKey.FPS.self] = newValue }
    }
    
    /// The environment value that controls which animation a `KeyedAnimatedImage` is currently playing.
    var animatedImageAnimation: (any Hashable)? {
        get { self[AnimatedImageKey.Animation.self] }
        set { self[AnimatedImageKey.Animation.self] = newValue }
    }
}

/// Extensions to `View` for setting sprite sheet animation values in the `SwiftUI` environment.
public extension View {
    
    /// Sets the environment value that controls whether a sprite sheet animation is playing.
    ///
    /// - Parameter isPlaying: A Boolean value indicating if the animation should be playing. The default value is `true`.
    /// - Returns: A view that sets the animated image playing state in the environment.
    ///
    /// Use this modifier to control whether a sprite sheet animation is playing or paused.
    ///
    /// ```
    /// MyView()
    ///     .animatedImageIsPlaying(true)
    /// ```
    func animatedImageIsPlaying(_ isPlaying: Bool = true) -> some View {
        self.environment(\.animatedImagePlaying, isPlaying)
    }
    
    /// Sets the environment value for the frames per second (FPS) of a sprite sheet animation.
    ///
    /// - Parameter fps: A Float value representing the FPS of the animation.
    /// - Returns: A view that sets the animated image FPS in the environment.
    ///
    /// Use this modifier to specify the frame rate of your sprite sheet animation.
    ///
    /// ```
    /// MyView()
    ///     .animatedImageFPS(24.0)
    /// ```
    func animatedImageFPS(_ fps: Float) -> some View {
        self.environment(\.animatedImageFPS, fps)
    }
    
    /// Sets the environment value for the current animation of a `KeyedAnimatedImage`.
    ///
    /// - Parameter animation: A hashable value representing the current animation.
    /// - Returns: A view that sets the animated image animation in the environment.
    ///
    /// Use this modifier to specify which animation should be currently playing in a `KeyedAnimatedImage`.
    ///
    /// ```
    /// MyView()
    ///     .animatedImageAnimation("run")
    /// ```
    func animatedImageAnimation<A: Hashable>(_ animation: A) -> some View {
        self.environment(\.animatedImageAnimation, animation)
    }
}
