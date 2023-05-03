//
//  File.swift
//  
//
//  Created by Lukas Simonson on 5/2/23.
//

import Foundation

public class KeyedAnimatedImageController<KeyType: Hashable>: AnimatedImageController {
    
    public var currentAnimation: KeyedAnimation?
    public var animations = [KeyType : KeyedAnimation]()
    
    public func play(_ animationKey: KeyType) throws {
        guard let animation = animations[animationKey]
        else { throw KeyedAnimationError.noAnimationFoundForKey(animationKey) }
        
        self.currentAnimation = animation
        play()
    }
    
    @objc override public func nextFrame() {
        guard currentAnimation != nil
        else { fatalError("No Animation Selected To Play") }
        
        self.currentAnimation!.updateFrame()
        self.currentFrame = self.currentAnimation!.getFrame()
        
        showFrame(self.currentFrame)
    }
}

extension KeyedAnimatedImageController {
    
    enum KeyedAnimationError: Error {
        case noAnimationFoundForKey(KeyType)
    }
    
    public struct KeyedAnimation {
        
        private(set) var frameIndex = 0
        public var frames: [CGPoint]
        
        func getFrame() -> CGPoint {
            frames[frameIndex]
        }
        
        mutating func updateFrame() {
            frameIndex += 1
            if frameIndex >= frames.count {
                frameIndex = 0
            }
        }
    }
}

extension KeyedAnimatedImageController {
    
    public func addAnimation(_ key: KeyType, frames: [CGPoint]) {
        animations[key] = KeyedAnimation(frames: frames)
    }
    
    public func addAnimation(_ key: KeyType, row: Int, numFrames frames: Int) {
        addAnimation(key, row: row, trailingColumn: frames - 1)
    }
    
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
