//
//  SpeechRecognitionManager.swift
//  NewWorldOrder
//
//  Created by Rahul Umap on 01/06/23.
//

import Foundation

class SpeechRecognitionManager: SpeechRecognitionServiceLogic {
    var speechRecognizerService: SpeechRecognitionService = SpeechRecognitionService()
    weak var delegate: SpeechRecognitionServiceDelegate?
    
    static let shared: SpeechRecognitionManager = SpeechRecognitionManager()
        
    private init() {
        speechRecognizerService.delegate = self
    }
    
    func start() {
        speechRecognizerService.start()
    }
    
    func stop() {
        speechRecognizerService.stop()
    }
}

extension SpeechRecognitionManager: SpeechRecognitionServiceDelegate {
    func didReceiveTranscribedText(_ text: String) {
        delegate?.didReceiveTranscribedText(text)
    }
}
