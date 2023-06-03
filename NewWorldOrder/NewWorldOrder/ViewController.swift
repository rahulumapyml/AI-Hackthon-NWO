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
    @IBOutlet weak var speakButton: UIButton!
    
    private let userName = "Rahul"
    private let speechRecognitionManager = SpeechRecognitionManager.shared
    private let synthesizer = AVSpeechSynthesizer()
    private var speechTask: DispatchWorkItem?
    
    private var flowType: Flow = .normal
    private var globalText = ""
    
    var isUserTalking = false {
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

        generativeAIResultLabel.text = flowType.getInitialDialog(userName)
        convertToAudio(flowType.getInitialDialog(userName))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        speechRecognitionManager.stop()
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction
    func starButtonAction(_ sender: Any) {
        if isUserTalking {
            isUserTalking = false
            speechRecognitionManager.stop()
            promptGPT(input: globalText)
        } else {
            speakButton.setTitle("SPEAK", for: .normal)
            isUserTalking = true
            speechRecognitionManager.start()
        }
    }
    
    @IBAction
    func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: - Private methods

private extension ViewController {
    func setup() {
        setUpLottie()
        isUserTalking = false
        waveformView.backgroundColor = .clear
        
        speakButton.layer.cornerRadius = speakButton.frame.height / 2
        speechRecognitionManager.delegate = self
        generativeAIResultLabel.text = flowType.getInitialDialog(userName)
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
        OpenAPIManager.shared.getResponse(input: input) { result in
            switch result {
            case .success(let text):
                 let updatedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                DispatchQueue.main.async {
                    self.convertToAudio(updatedText)
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
        if isUserTalking {
            speakButton.setTitle("STOP", for: .normal)
            lottieView.isHidden = true
            generativeAIResultLabel.isHidden = true
            generativeAIResultLabel.text = ""
            userInputLabel.isHidden = false
            waveformView.isHidden = false
        } else {
            speakButton.setTitle("SPEAK", for: .normal)
            lottieView.isHidden = false
            generativeAIResultLabel.isHidden = false
            userInputLabel.isHidden = true
            userInputLabel.text = ""
            waveformView.isHidden = true
        }
        
    }
}

// MARK: - SpeechRecognitionServiceDelegate

extension ViewController: SpeechRecognitionServiceDelegate {
    func didReceiveTranscribedText(_ text: String) {
        userInputLabel.text = text
        globalText = text
    }
    
    func processAudioBuffer(_ buffer: AVAudioPCMBuffer) {
        waveformView.processAudioBuffer(buffer)
    }
}
