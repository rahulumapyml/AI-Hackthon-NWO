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
    let synthesizer = AVSpeechSynthesizer()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

    override func viewDidLoad() {
        super.viewDidLoad()
       // createGradient()
        synthesizer.delegate = self

        promptGPT()
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
    
    
    @IBAction func audioButtonAction(_ sender: Any) {
        convertToAudio("We call ourselves 'dreamers and doers' for a reason: we can make happen not just what is possible, but what is impossible. NEOM is a unique investment opportunity, unrivalled anywhere else. This is not business as usual. Be a part of it. Invest in the new future now, invest in NEOM.")
       // convertToText()
    }
    
}

// MARK: -  Text to Audio & Audio to Text Conversion
extension ViewController {
    func convertToAudio(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Set the preferred voice
        synthesizer.speak(utterance)
    }
    
    func convertToText() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == .authorized {
                let audioEngine = AVAudioEngine()
                let request = SFSpeechAudioBufferRecognitionRequest()
                let node = audioEngine.inputNode

                let recordingFormat = node.outputFormat(forBus: 0)
                node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                    request.append(buffer)
                }

                audioEngine.prepare()
                do {
                    try audioEngine.start()

                    self.speechRecognizer?.recognitionTask(with: request) { result, error in
                        if let transcription = result?.bestTranscription {
                            let text = transcription.formattedString
                            print(text)
                        }
                    }
                } catch {
                    print("Error starting audio engine: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
}

extension ViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("Speech synthesis canceled.")
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("Speech synthesis finished.")
    }
}
