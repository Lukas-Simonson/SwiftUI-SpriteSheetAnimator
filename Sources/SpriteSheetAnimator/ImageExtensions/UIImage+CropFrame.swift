//
//  File.swift
//  
//
//  Created by Lukas Simonson on 5/2/23.
//

import Foundation
import UIKit

extension UIImage {
    internal func cropFrame(_ frame: CGSize, origin: CGPoint) throws -> UIImage {
        if let cgImage = self.cgImage {
            return UIImage(cgImage: try cgImage.cropFrame(frame, origin: origin), scale: 0, orientation: self.imageOrientation)
        } else {
            throw SpriteSheetAnimatorError.couldntGetBitmapData
        }
    }
}
