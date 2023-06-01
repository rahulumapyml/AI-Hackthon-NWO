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
    let speechRecognitionManager = SpeechRecognitionManager.shared
    let synthesizer = AVSpeechSynthesizer()
    
    var speechTask: DispatchWorkItem?

    var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "NunitoSans-Regular", size: 26)
        textView.textColor = .white
        textView.textAlignment = .center
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        speechRecognitionManager.delegate = self

        createGradient()
        addImages()
    }

    func addImages() {
        guard let confettiImageView = UIImageView.fromGif(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300),
                                                          resourceName: "listening") else { return }
        confettiImageView.alpha = 0.5
        view.addSubview(confettiImageView)
        confettiImageView.startAnimating()
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
    
    
    @IBAction
    func audioButtonAction(_ sender: Any) {
      //  speechRecognitionManager.start()
        convertToAudio(" Finding more resources You completed this module on SwiftUI and built your first app. Review what you’ve learned, and get ideas about where to go from here.")
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

