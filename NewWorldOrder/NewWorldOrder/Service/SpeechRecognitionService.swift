//
//  SpeechRecognitionService.swift
//  NewWorldOrder
//
//  Created by Rahul Umap on 01/06/23.
//

import Foundation
import Speech

protocol SpeechRecognitionServiceDelegate: AnyObject {
    func didReceiveTranscribedText(_ text: String)
    func processAudioBuffer(_ buffer: AVAudioPCMBuffer)
}

protocol SpeechRecognitionServiceLogic: AnyObject {
    var delegate: SpeechRecognitionServiceDelegate? { get set }
    
    func start()
    func stop()
}

class SpeechRecognitionService: NSObject, SpeechRecognitionServiceLogic, SFSpeechRecognizerDelegate {
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    let audioEngine = AVAudioEngine()
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    weak var delegate: SpeechRecognitionServiceDelegate?
    
    override init() {
        super.init()
        speechRecognizer?.delegate = self
    }
    
    func start() {
        SFSpeechRecognizer.requestAuthorization { [weak self] (authStatus) in
            guard authStatus == .authorized else {
                // Handle authorization error
                return
            }
            
            do {
                try self?.startRecording()
            } catch {
                // Handle error
            }
        }
    }
    
    func startRecording() throws {
        
        // Cancel any ongoing recognition task
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        // Set up the audio session
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .default, options: .mixWithOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // Check if audio input is available
        
        let inputNode = audioEngine.inputNode
        
        // Assign the recognition request to the input node's output
        let recordingFormat = inputNode.inputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, time) in
            self.recognitionRequest?.append(buffer)
            self.delegate?.processAudioBuffer(buffer)
        }
        
        // Prepare the audio engine and start recording
        audioEngine.prepare()
        try audioEngine.start()
        
        // Start speech recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!) { [weak self] (result, error) in
            if let result = result {
                let transcribedText = result.bestTranscription.formattedString
                // Process the transcribed text and extract the required parameters
                self?.delegate?.didReceiveTranscribedText(transcribedText)
            }
        }
    }
    
    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
    }
    
    func getText() -> String? {
        return "" //recognitionTask?.result?.bestTranscription.formattedString
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        // Handle availability changes if needed
    }
}
