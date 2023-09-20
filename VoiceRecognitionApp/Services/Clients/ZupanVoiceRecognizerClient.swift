// 16.09.23 | VoiceRecognitionApp - VoiceRecognizerService.swift | Tom Estelrich

import Foundation
import Combine

// MARK: ZupanVoiceRecognizerClient

final class ZupanVoiceRecognizerClient: ObservableObject {
    
    // MARK: RecognitionMode

    enum RecognitionMode: String {
        case waiting = "waiting"
        case code = "code"
        case count = "count"
    }
    
    // MARK: Command
    
    enum Command: String {
        case code = "code"
        case count = "count"
        case back = "back"
        case reset = "reset"
        case done = "done"
    }
    
    // MARK: Lifecycle
    
    init(service: VoiceRecognizerService = VoiceRecognizerService()) {
        self.service = service
        self.service.startTranscribing()
        
        service.$transcriptions
            .sink(receiveValue: { [weak self] transcript in
                guard let self = self, let transcriptMessage = transcript.last?.message else { return }
                self.executeClientRecognizerRules(with: transcriptMessage)
                self.rawSpeech.append(transcriptMessage)
            })
            .store(in: &subscriptions)
        
        service.$state
            .sink(receiveValue: { [weak self] state in
                guard let self = self else { return }
                self.recognizerState = state
            })
            .store(in: &subscriptions)
        
        service.$errorMessage
            .sink(receiveValue: { [weak self] errorMessage in
                guard let self = self else { return }
                self.recognizerErrorMessage = errorMessage
            })
            .store(in: &subscriptions)
    }
    
    deinit {
        subscriptions.removeAll()
    }
    
    // MARK: Internal
    
    @Published var recognizerState: VoiceRecognizerService.State?
    @Published var recognizerErrorMessage: String?
    @Published var recognitionMode: RecognitionMode = .waiting
    @Published var rawSpeech: [String] = []
    @Published var dataOutputs: [DataOutput] = []
    @Published var parameters: String = ""
    
    var isRecognizerStateOn: Bool {
        recognizerState == .on
    }
    
    func toggleRecognizerState() {
        service.toggleState()
    }
        
    // MARK: Private

    private var service: VoiceRecognizerService
    private var subscriptions: Set<AnyCancellable> = []

    private func executeClientRecognizerRules(with transcriptionMessage: String) {
        if recognitionMode == .waiting {
            setCommand(with: transcriptionMessage)
        } else {
            switch transcriptionMessage {
            case Command.back.rawValue:
                back()
            case Command.reset.rawValue:
                reset()
            case Command.done.rawValue:
                done()
                reset()
            default:
                setParameter(with: transcriptionMessage)
            }
        }
    }
    
    private func setCommand(with transcriptionMessage: String) {
        guard let recognizedCommand = recognizableCommands.first(where: { $0.value == transcriptionMessage.lowercased() }) else { return }
        
        switch recognizedCommand.value {
        case Command.code.rawValue, Command.count.rawValue:
            self.recognitionMode = RecognitionMode(rawValue: recognizedCommand.value) ?? .waiting
        default:
            break
        }
    }
    
    private func setParameter(with transcriptionMessage: String) {
        guard let recognizedParameter = recognizableParameters.first(where: { $0.value == transcriptionMessage.lowercased() }) else { return }
        
        switch self.recognitionMode {
        case .waiting:
            break
        case .code:
            self.parameters += recognizedParameter.transcription
        case .count:
            self.parameters += "\(recognizedParameter.transcription), "
        }
    }
    
    private func reset() {
        self.recognitionMode = .waiting
        self.parameters = ""
    }
    
    private func back() {
        parameters = ""
    }
    
    private func done() {
        let dataOutput = DataOutput(command: recognitionMode.rawValue, parameters: parameters)
        dataOutputs.append(dataOutput)
    }
}

// MARK: DataRecognitionProtocol

extension ZupanVoiceRecognizerClient: DataRecognitionProtocol {
    
    var recognizableCommands: [DataRecognition] {
        [
            DataRecognition(value: "code", transcription: "Code"),
            DataRecognition(value: "count", transcription: "Count"),
            DataRecognition(value: "back", transcription: "Back"),
            DataRecognition(value: "reset", transcription: "Reset"),
            DataRecognition(value: "done", transcription: "Done")
        ]
    }
    
    var recognizableParameters: [DataRecognition] {
        [
            DataRecognition(value: "zero", transcription: "0"),
            DataRecognition(value: "0", transcription: "0"),
            DataRecognition(value: "one", transcription: "1"),
            DataRecognition(value: "1", transcription: "1"),
            DataRecognition(value: "two", transcription: "2"),
            DataRecognition(value: "2", transcription: "2"),
            DataRecognition(value: "three", transcription: "3"),
            DataRecognition(value: "3", transcription: "3"),
            DataRecognition(value: "four", transcription: "4"),
            DataRecognition(value: "4", transcription: "4"),
            DataRecognition(value: "five", transcription: "5"),
            DataRecognition(value: "5", transcription: "5"),
            DataRecognition(value: "six", transcription: "6"),
            DataRecognition(value: "6", transcription: "6"),
            DataRecognition(value: "seven", transcription: "7"),
            DataRecognition(value: "7", transcription: "7"),
            DataRecognition(value: "eight", transcription: "8"),
            DataRecognition(value: "8", transcription: "8"),
            DataRecognition(value: "nine", transcription: "9"),
            DataRecognition(value: "9", transcription: "9")
        ]
    }
    
}
