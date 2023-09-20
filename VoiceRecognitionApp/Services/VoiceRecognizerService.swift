// 18.09.23 | VoiceRecognitionApp - VoiceRecognizerService.swift | Tom Estelrich

import AVFoundation
import Speech
import SwiftUI

// MARK: VoiceRecognizerService
/// A helper for transcribing speech to text using SFSpeechRecognizer and AVAudioEngine.
class VoiceRecognizerService: ObservableObject {
    
    // MARK: State
    
    enum State: String {
        case on = "on"
        case off = "off"
    }
    
    // MARK: RecognizerError
    
    enum RecognizerError: Error {
        case notRequested
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message: String {
            switch self {
            case .notRequested: return "Waiting for authorizations."
            case .nilRecognizer: return "Can't initialize speech recognizer."
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech."
            case .notPermittedToRecord: return "Not permitted to record audio."
            case .recognizerIsUnavailable: return "Recognizer is unavailable."
            }
        }
    }
    
    // MARK: Lifecycle
    
    init() {
        speechRecognizer = SFSpeechRecognizer()
        verifyUserPermissions()
    }
    
    deinit {
        stopTranscribing()
    }
    
    // MARK: Internal
    
    @Published var state: State = .on
    @Published var errorMessage: String?
    @Published var transcriptions: [Transcription] = []
    
    /// Begin transcribing audio. Creates a `SFSpeechRecognitionTask` that transcribes speech to text until it completes or finds an error.
    /// The resulting transcription is continuously being updated through the @Published `transcriptions` property.
    func startTranscribing() {
        state = .on
        
        guard let recognizer = self.speechRecognizer,
              recognizer.isAvailable else
        {
            state = .off
            self.transcribe(error: RecognizerError.recognizerIsUnavailable)
            return
        }
        
        do {
            let (audioEngine, request) = try self.prepareEngine()
            self.audioEngine = audioEngine
            self.recognitionRequest = request
            
            self.speechRecognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error  in
                let receivedFinalResult = result?.isFinal ?? false
                
                if receivedFinalResult || error != nil {
                    self?.stopTranscribing()
                }
                
                if let result = result, let bestTranscription = result.bestTranscription.segments.last {
                    self?.transcribe(result: bestTranscription)
                }
            }
        } catch {
            self.stopTranscribing()
            self.transcribe(error: error)
        }
    }
    
    /// Stop transcribing audio.
    func stopTranscribing() {
        state = .off
        speechRecognitionTask?.cancel()
        speechRecognitionTask = nil
        audioEngine?.stop()
        audioEngine = nil
        recognitionRequest = nil
        transcriptions = []
    }
    
    /// Toogle voice's reconizer power state.
    func toggleState() {
        state == .on ? stopTranscribing() : startTranscribing()
    }
    
    // MARK: Private
    
    private var speechRecognizer: SFSpeechRecognizer?
    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    
    private func verifyUserPermissions() {
        Task(priority: .background) {
            do {
                errorMessage = RecognizerError.notRequested.message
                
                guard speechRecognizer != nil else {
                    transcribe(error: RecognizerError.nilRecognizer)
                    throw RecognizerError.nilRecognizer
                }
                
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    transcribe(error: RecognizerError.notAuthorizedToRecognize)
                    throw RecognizerError.notAuthorizedToRecognize
                }
                
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    transcribe(error: RecognizerError.notPermittedToRecord)
                    throw RecognizerError.notPermittedToRecord
                }
                
                errorMessage = nil
            } catch {
                transcribe(error: error)
            }
        }
    }
    
    private func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    private func transcribe(result: SFTranscriptionSegment) {
        guard !transcriptions.contains(where: { $0.timestamp == result.timestamp }), result.timestamp != 0.0 else { return }
        let transcription = Transcription(timestamp: result.timestamp, message: result.substring)
        transcriptions.append(transcription)
    }
    
    private func transcribe(error: Error) {
        guard let error = error as? RecognizerError else {
            errorMessage = error.localizedDescription
            return
        }
        
        errorMessage = error.message
    }
}

// MARK: SFSpeechRecognizer extension

extension SFSpeechRecognizer {
    
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

// MARK: AVAudioSession extension

extension AVAudioSession {
    
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
