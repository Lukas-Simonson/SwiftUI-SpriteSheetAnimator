//
//  File.swift
//  
//
//  Created by Lukas Simonson on 5/2/23.
//

import Foundation
import CoreGraphics

extension CGImage {
    internal func cropFrame(_ frame: CGSize, origin: CGPoint) throws -> CGImage {
        let cropRect = CGRect(origin: origin, size: frame)
        if let cropped = self.cropping(to: cropRect) {
            return cropped
        }
        throw SpriteSheetAnimatorError.couldntCropImage
    }
}
