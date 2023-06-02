//
//  WaveFormView.swift
//  NewWorldOrder
//
//  Created by Rahul Umap on 02/06/23.
//

import UIKit
import AVFoundation

class WaveformView: UIView {
    
    var waveformColor: UIColor = .white // Customize the waveform color
    var waveformWidth: CGFloat = 4.0 // Customize the waveform line width
    var waveformSpacing: CGFloat = 4.0 // Customize the spacing between waveform lines
    var amplitudeMultiplier: CGFloat = 2.0 // Adjust the multiplier to control the waveform height
    var audioEngine: AVAudioEngine?
    var audioInputNode: AVAudioInputNode?
    let framesCount = 4800 // Number of frames to capture and draw
    var waveFormArray = [Float]() // Array to store audio waveform data
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineWidth(waveformWidth)
        context.setStrokeColor(waveformColor.cgColor)
        
        let halfHeight = bounds.height / 2.0
        let centerY = bounds.midY
        let horizontalSpacing = waveformWidth + waveformSpacing
        
        context.clear(rect)
        
        var xPosition: CGFloat = 0.0
        for (index, amplitude) in waveFormArray.enumerated() {
            let xPos = xPosition + CGFloat(index) * horizontalSpacing
            
            // Calculate the waveform points based on the audio data
            let waveFormY = centerY - CGFloat(amplitude) * halfHeight * amplitudeMultiplier
            
            context.move(to: CGPoint(x: xPos, y: centerY))
            context.addLine(to: CGPoint(x: xPos, y: waveFormY))
            
            xPosition += horizontalSpacing
        }
        
        context.strokePath()
    }
    
    func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        let framesCount = Int(buffer.frameLength)
        waveFormArray = Array(UnsafeBufferPointer(start: buffer.floatChannelData![0], count: framesCount))
        
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
}
