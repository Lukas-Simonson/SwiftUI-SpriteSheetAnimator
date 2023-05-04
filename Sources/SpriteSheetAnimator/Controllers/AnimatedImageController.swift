//
//  File.swift
//  
//
//  Created by Lukas Simonson on 5/2/23.
//

import Foundation
import SwiftUI

/// AnimatedImageController uses a given Sprite Sheet as a `UIImage` to break down into
/// individual sprites, to then display to the user.
public class AnimatedImageController: ObservableObject {
    
    /// The current frame Image to display.
    @Published public var frame: UIImage?
    
    // Animation Controls
    /// The offset to reach the current frame in the full Sprite Sheet Image.
    public var currentFrame: CGPoint
    
    /// The entire sheet to get individual Sprite frames from.
    public private(set) var spriteSheet: UIImage
    
    /// The size of an individual Sprite frame.
    public private(set) var frameSize: CGSize
    
    /// The maximum number of horizontal frames in the given Sprite Sheet.
    public private(set) var maxFrameX: CGFloat
    
    /// The maximum number of vertical frames in the given Sprite Sheet.
    public private(set) var maxFrameY: CGFloat
    
    // Animation Player
    /// A `Bool` providing if the animation is currently running or not.
    public private(set) var isPlaying: Bool = false
    
    /// The timer that runs the animation.
    private var updater: CADisplayLink = CADisplayLink()
    
    /// What `RunLoop` the updater runs on.
    private var updaterLoop: RunLoop
    
    /// What `RunLoop.Mode` the updater should update on.
    private var updaterMode: RunLoop.Mode
    
    /// Creates an AnimatedImageController for a given Sprite Sheet.
    ///
    /// - Parameters:
    ///   - spriteSheet: A `UIImage` containing all the Sprites needed for animation.
    ///   - frameSize: A `CGSize` representing the size of an individual sprite in the Sprite Sheet.
    ///   - startingFrame: A `CGPoint` representing the frame offset for the desired first frame.
    ///   - animationFPS: A `Float` representing how many times per second the current frame should be changed to a new one.
    ///   - animationLoop: A `RunLoop` for the animation updater to run on.
    ///   - animationLoopMode: A `RunLoop.Mode` to add the animation updater to.
    ///
    public init(
        _ spriteSheet: UIImage,
        frameSize: CGSize,
        startingFrame: CGPoint = .zero,
        animationFPS: Float = 30,
        animationLoop: RunLoop = .main,
        animationLoopMode: RunLoop.Mode = .common
    ) {
        self.spriteSheet = spriteSheet
        self.frameSize = frameSize
        self.currentFrame = startingFrame
        self.maxFrameX = spriteSheet.size.width / frameSize.width
        self.maxFrameY = spriteSheet.size.height / frameSize.height
        
        updaterLoop = animationLoop
        updaterMode = animationLoopMode
        
        updater = CADisplayLink(target: self, selector: #selector(nextFrame))
        setFPS(animationFPS)
    }
}

extension AnimatedImageController {
    
    /// Updates the current frame to be the next frame in the current animation.
    @objc public func nextFrame() {
        currentFrame.x += 1
        if currentFrame.x >= maxFrameX {
            currentFrame.x = 0
        }
        showFrame(currentFrame)
    }
    
    /// Updates the current frame to be the previous frame in the current animation.
    @objc public func previousFrame() {
        currentFrame.x -= 1
        if currentFrame.x < 0 {
            currentFrame.x = maxFrameX - 1
        }
        showFrame(currentFrame)
    }
    
    /// Updates the `frame` property to the frame at a given frame offset.
    ///
    /// - Parameters:
    ///   - framePos: A `CGPoint` of the desired frame offset of which frame to display.
    ///
    public func showFrame(_ framePos: CGPoint) {
        currentFrame = framePos
        let origin = CGPoint(x: currentFrame.x * frameSize.width, y: currentFrame.y * frameSize.height)
        self.frame = try? spriteSheet.cropFrame(frameSize, origin: origin)
    }
}

extension AnimatedImageController {
    
    /// Starts playing the current animation.
    public func play() {
        if !isPlaying {
            isPlaying = true
            updater.add(to: updaterLoop, forMode: updaterMode)
        }
    }
    
    /// Stops playing the current animation.
    public func pause() {
        if isPlaying {
            isPlaying = false
            updater.remove(from: updaterLoop, forMode: updaterMode)
        }
    }
}

extension AnimatedImageController {

    /// Updates the current Sprite Sheet.
    ///
    /// - Parameters:
    ///   - image: The new Sprite Sheet to retrieve animations from.
    public func setSpriteSheet(to image: UIImage) {
        self.spriteSheet = image
    }
    
    /// Updates the desired frame rate to run the animation.
    ///
    /// - Parameters:
    ///   - fps: The desired frame rate to run the animation at, represented as a `Float`.
    public func setFPS(_ fps: Float) {
        if #available(iOS 15, *) {
            updater.preferredFrameRateRange = CAFrameRateRange(minimum: fps, maximum: fps)
        } else {
            updater.preferredFramesPerSecond = Int(fps)
        }
    }
}
