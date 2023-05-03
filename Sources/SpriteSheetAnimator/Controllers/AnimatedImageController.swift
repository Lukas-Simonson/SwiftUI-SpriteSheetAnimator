//
//  File.swift
//  
//
//  Created by Lukas Simonson on 5/2/23.
//

import Foundation
import SwiftUI

public class AnimatedImageController: ObservableObject {
    
    @Published public var frame: UIImage?
    
    // Animation Controls
    public var currentFrame: CGPoint
    private(set) var spriteSheet: UIImage
    private(set) var frameSize: CGSize
    private(set) var maxFrameX: CGFloat
    private(set) var maxFrameY: CGFloat
    
    // Animation Player
    public var isPlaying: Bool = false
    private var updater: CADisplayLink = CADisplayLink()
    private var updaterLoop: RunLoop
    private var updaterMode: RunLoop.Mode
    
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
    
    @objc public func nextFrame() {
        currentFrame.x += 1
        if currentFrame.x >= maxFrameX {
            currentFrame.x = 0
        }
        showFrame(currentFrame)
    }
    
    public func showFrame(_ framePos: CGPoint) {
        currentFrame = framePos
        let origin = CGPoint(x: currentFrame.x * frameSize.width, y: currentFrame.y * frameSize.height)
        self.frame = try? spriteSheet.cropFrame(frameSize, origin: origin)
    }
}

extension AnimatedImageController {
    
    public func play() {
        if !isPlaying {
            isPlaying = true
            updater.add(to: updaterLoop, forMode: updaterMode)
        }
    }
    
    public func pause() {
        if isPlaying {
            isPlaying = false
            updater.remove(from: updaterLoop, forMode: updaterMode)
        }
    }
}

extension AnimatedImageController {
    public func setFPS(_ fps: Float) {
        if #available(iOS 15, *) {
            updater.preferredFrameRateRange = CAFrameRateRange(minimum: fps, maximum: fps)
        } else {
            updater.preferredFramesPerSecond = Int(fps)
        }
    }
}
