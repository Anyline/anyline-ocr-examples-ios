    //
//  GifuWrapper.swift
//  AnylineExamples
//
//  Created by Philipp Müller on 18.09.20.
//
// This does nothing, but could be replaced with a wrapper for the Gifu library.
@objc
class GifuWrapper: UIImageView {

    override public func display(_ layer: CALayer) {
    }

    @objc public func setGIF(gifName: String, loopCount: Int, frame: CGRect) {
        self.frame = frame
    }
    
    @objc public func startGIF(gifName: String, loopCount: Int) {
    }
    
    @objc public func toggleAnimation() {
    }
    
    @objc public func stopGIF() {
    }
    @objc public func startGIF() -> Double {
        return 0.0
    }
}
