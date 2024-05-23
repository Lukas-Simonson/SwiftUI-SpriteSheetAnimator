//
//  File.swift
//  
//
//  Created by Lukas Simonson on 5/23/24.
//

import SwiftUI

/// A SwiftUI view that displays an animated image controlled by an `AnimatedImageController`.
///
/// `ControlledAnimatedImage` uses an `AnimatedImageController` to manage the playback of the frames.
/// It provides customization options for displaying each frame and a placeholder view when there is no frame.
///
/// - Parameters:
///   - FrameImage: A view that displays a frame of the animation.
///   - FrameEmpty: A view that is displayed when there is no frame available.
///   - Controller: A type conforming to `AnimatedImageController` that manages the animation playback.
internal struct ControlledAnimatedImage<FrameImage: View, FrameEmpty: View, Controller: AnimatedImageController>: View {
    
    /// An environment value indicating whether the image is playing.
    @Environment(\.animatedImagePlaying) private var imageIsPlaying
    
    /// An environment value specifying the frames per second the animation should be running at.
    @Environment(\.animatedImageFPS) private var imageFPS
    
    /// The `Controller` that manages the animation playback.
    @ObservedObject var imageController: Controller
    
    /// The `View` to display for each frame of the animation.
    let frameImage: (Image) -> FrameImage
    
    /// The `View` to display when there is no frame to display from the `imageController`.
    let frameEmpty: () -> FrameEmpty
    
    public var body: some View {
        Group {
            if let frame = imageController.frame {
                frameImage(Image(uiImage: frame))
            } else {
                frameEmpty()
            }
        }
        // Sets up the initial state of the `imageController` based on the environment values.
        .onAppear {
            setIsPlaying(imageIsPlaying)
            imageController.setFPS(imageFPS)
        }
        // Updates the `imageController` when a change the the environment is made.
        .onChange(of: imageIsPlaying, perform: setIsPlaying)
        .onChange(of: imageFPS, perform: imageController.setFPS)
    }
    
    func setIsPlaying(_ isPlaying: Bool) {
        if isPlaying { imageController.play() }
        else { imageController.pause() }
    }
}
