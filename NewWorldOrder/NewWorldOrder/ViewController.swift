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
    @IBOutlet private weak var aiImageView: UIImageView!
    @IBOutlet private weak var waveformView: WaveformView!
    @IBOutlet private weak var generativeAIResultLabel: UILabel!
    @IBOutlet private weak var userInputLabel: UILabel!
    
    private let userName = "Rahul"
    private let speechRecognitionManager = SpeechRecognitionManager.shared
    private let synthesizer = AVSpeechSynthesizer()
    private var speechTask: DispatchWorkItem?
    
    var flowType: Flow = .normal
    
    var botState: BotState = .speaking {
        didSet {
            updateUI()
        }
    }

    // MARK: - ViewController's Lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

// MARK: - Nested Types

extension ViewController {
    enum BotState {
        case listening
        case speaking
    }
}

// MARK: - Private methods

private extension ViewController {
    func setup() {
        speechRecognitionManager.delegate = self
        synthesizer.delegate = self
        
        aiImageView.animationImages = UIImageView.fromGif(frame:aiImageView.bounds, resourceName: "listening")
        aiImageView.startAnimating()
        
        generativeAIResultLabel.text = flowType.getInitialDialog(userName)
        convertToAudio(flowType.getInitialDialog(userName))
    }
    
    func promptGPT(input: String) {
        OpenAPIManager.shared.getResponse(input: input) { result in
            switch result {

            case .success(let text):
                print(text)
                DispatchQueue.main.async {
                    self.convertToAudio("Hello I'm chat gpt speaking. \(Int.random(in: 1...100))")
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func convertToAudio(_ text: String) {
        generativeAIResultLabel.text = text
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-us")
        utterance.rate = 0.45
        synthesizer.speak(utterance)
    }

    func updateUI() {
        switch botState {
        case .speaking:
            generativeAIResultLabel.isHidden = false
            userInputLabel.isHidden = true
            userInputLabel.text = ""
            waveformView.isHidden = true
            speechRecognitionManager.stop()
        case .listening:
            generativeAIResultLabel.isHidden = true
            generativeAIResultLabel.text = ""
            userInputLabel.isHidden = false
            waveformView.isHidden = false
            speechRecognitionManager.start()
        }
    }
}

// MARK: - SpeechRecognitionServiceDelegate

extension ViewController: SpeechRecognitionServiceDelegate {
    func didReceiveTranscribedText(_ text: String) {
        userInputLabel.text = text
        
        speechTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            self?.promptGPT(input: text)
        }

        self.speechTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: task)
    }
    
    func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        waveformView.processAudioBuffer(buffer)
    }
}


// MARK: - AVSpeechSynthesizerDelegate

extension ViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        botState = .listening
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        botState = .speaking
    }
}
