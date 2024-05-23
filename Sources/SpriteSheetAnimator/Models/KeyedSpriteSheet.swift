//
//  File.swift
//  
//
//  Created by Lukas Simonson on 5/23/24.
//

import Foundation
import UIKit

/// A protocol for managing a sprite sheet with keyed animations.
public protocol KeyedSpriteSheet {
    
    /// The type of keys used to identify animations. Must conform to `Hashable`.
    associatedtype Key: Hashable
    
    /// The sprite sheet image containing all frames.
    var sheet: UIImage { get }
    
    /// The size of each frame in the sprite sheet.
    var frameSize: CGSize { get }
    
    /// A dictionary mapping keys to their corresponding animation frames.
    var animations: [Key: AnimationFrames] { get }
}
