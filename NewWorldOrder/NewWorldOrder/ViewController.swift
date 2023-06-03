//
//  ViewController.swift
//  NewWorldOrder
//
//  Created by Rahul Umap on 01/06/23.
//

import UIKit
import AVFoundation
import Speech
import Lottie

class ViewController: UIViewController {
    @IBOutlet private weak var waveformView: WaveformView!
    @IBOutlet private weak var generativeAIResultLabel: UILabel!
    @IBOutlet private weak var userInputLabel: UILabel!
    @IBOutlet weak var lottieView: LottieAnimationView!
    @IBOutlet weak var gifBackgroundView: UIImageView!

    private let userName = "Rahul"
    private let speechRecognitionManager = SpeechRecognitionManager.shared
    private let synthesizer = AVSpeechSynthesizer()
    private var speechTask: DispatchWorkItem?
    
    var flowType: Flow = .normal
    
    var botState: BotState = .speaking {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }

    // MARK: - ViewController's Lifecycle

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
        setUpLottie()
        speechRecognitionManager.delegate = self
        generativeAIResultLabel.text = flowType.getInitialDialog(userName)
        speechRecognitionManager.start()
    }
    
    func setUpLottie() {
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 0.5
        lottieView.backgroundColor = .clear
        lottieView.play()
        
        gifBackgroundView.animationImages = UIImageView.fromGif(frame: gifBackgroundView.bounds, resourceName: "background")
        gifBackgroundView.startAnimating()
    }

    func promptGPT(input: String) {
        botState = .speaking

        OpenAPIManager.shared.getResponse(input: input) { result in
            switch result {
            case .success(let text):
                DispatchQueue.main.async {
                    self.generativeAIResultLabel.text = text
                }
            case .failure(let failure):
                print(failure)
            }
            
            self.botState = .listening
        }
    }
    
    func updateUI() {
        switch botState {
        case .speaking:
            lottieView.isHidden = true
            generativeAIResultLabel.isHidden = false
            userInputLabel.isHidden = true
            userInputLabel.text = ""
            waveformView.isHidden = true
            speechRecognitionManager.stop()
        case .listening:
            lottieView.isHidden = false
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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: task)
    }
    
    func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        waveformView.processAudioBuffer(buffer)
    }
}
