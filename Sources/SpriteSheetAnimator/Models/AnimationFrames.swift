//
//  File.swift
//  
//
//  Created by Lukas Simonson on 5/23/24.
//

import Foundation

/// A struct to manage a sequence of animation frames represented by `CGPoint` values.
public struct AnimationFrames {
    
    /// The index of the current frame to show
    private(set) var frameIndex = 0
    
    /// An array of `CGPoint` values representing the frames of the animation.
    public var frames: [CGPoint]
    
    /// Initializes an `AnimationFrames` instance with a specified starting frame index and an array of frames.
    ///
    /// - Parameters:
    ///   - frameIndex: An `Int` specifying the starting frame index. Defaults to `0`.
    ///   - frames: An array of `CGPoint` values representing the frames of the animation.
    public init(frameIndex: Int = 0, frames: [CGPoint]) {
        self.frameIndex = frameIndex
        self.frames = frames
    }
    
    /// Initializes an `AnimationFrames` instance with frames generated in the specified row
    /// from the leading column to the trailing column.
    ///
    /// - Parameters:
    ///   - row: An `Int` specifying the row for all frames.
    ///   - leading: An `Int` specifying the leading column index. Defaults to `0`.
    ///   - trailing: An `Int` specifying the trailing column index.
    public init(row: Int, leadingColumn leading: Int = 0, trailingColumn trailing: Int) {
        self.frameIndex = 0
        self.frames = (leading...trailing).map { CGPoint(x: $0, y: row) }
    }
    
    /// Initializes an `AnimationFrames` instance with a specified number of frames,
    /// all in the same row, starting from column 0 to `numFrames` frames.
    ///
    /// - Parameters:
    ///   - row: An `Int` specifying the row for all frames.
    ///   - numFrames: An `Int` specifying the number of frames.
    public init(row: Int, numFrames frames: Int) {
        self.init(row: row, leadingColumn: 0, trailingColumn: frames - 1)
    }
    
    /// Returns the current frame, i.e., the `CGPoint` at the current `frameIndex`.
    ///
    /// - Returns: The `CGPoint` representing the current frame.
    func getFrame() -> CGPoint {
        frames[frameIndex]
    }
    
    /// Advances to the next frame in the sequence. If the end of the frames array is reached, it wraps around to the first frame.
    mutating func nextFrame() {
        frameIndex += 1
        if frameIndex >= frames.count {
            frameIndex = 0
        }
    }
    
    /// Moves to the previous frame in the sequence. If the beginning of the frames array is reached, it wraps around to the last frame.
    mutating func previousFrame() {
        frameIndex -= 1
        if frameIndex < 0 {
            frameIndex = frames.count - 1
        }
    }
}
