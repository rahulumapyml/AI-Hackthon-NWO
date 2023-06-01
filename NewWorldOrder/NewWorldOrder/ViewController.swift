//
//  ViewController.swift
//  NewWorldOrder
//
//  Created by Rahul Umap on 01/06/23.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController {
    @IBOutlet weak var aiImageView: UIImageView!
    
    let speechRecognitionManager = SpeechRecognitionManager.shared
    let synthesizer = AVSpeechSynthesizer()
    
    var speechTask: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        speechRecognitionManager.delegate = self
        
        aiImageView.animationImages = UIImageView.fromGif(frame:aiImageView.frame , resourceName: "listening")
        aiImageView.startAnimating()
        
        createGradient()
    }
    
    func promptGPT() {
        OpenAPIManager.shared.getResponse(input: "help me book an appointment for the chest pain") { result in
            switch result {
            case .success(let text):
                self.convertToAudio(text)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func createGradient() {
        // Create gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        let color1 = UIColor(red: 70/255, green: 120/255, blue: 230/255, alpha: 1).cgColor
        let color2 = UIColor(red: 58/255, green: 101/255, blue: 229/255, alpha: 1).cgColor
        let color3 = UIColor(red: 20/255, green: 71/255, blue: 211/255, alpha: 1).cgColor
        
        gradientLayer.colors = [color1, color2, color3]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        // Add gradient layer to the view's layer
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

// MARK: -  Text to Audio & Audio to Text Conversion
extension ViewController {
    func convertToAudio(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-us")
        utterance.rate = 0.45
        synthesizer.speak(utterance)
    }
}


extension ViewController: SpeechRecognitionServiceDelegate {
    func didReceiveTranscribedText(_ text: String) {
        speechTask?.cancel()

        let task = DispatchWorkItem {
            print(text)
        }

        self.speechTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: task)
    }
}

