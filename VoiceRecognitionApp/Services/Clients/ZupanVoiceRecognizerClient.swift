// 16.09.23 | VoiceRecognitionApp - ZupanVoiceRecognizerClient.swift | Tom Estelrich

import Foundation
import Combine

// MARK: VoiceRecognizerClientProtocol

protocol VoiceRecognizerClientProtocol {
    
    associatedtype Command: RawRepresentable where Command.RawValue: StringProtocol
    associatedtype Parameter: RawRepresentable where Parameter.RawValue: StringProtocol
    
    func applyConditions(to transcriptionMessage: String)
}

// MARK: ZupanVoiceRecognizerClient

final class ZupanVoiceRecognizerClient: ObservableObject {
    
    // MARK: Mode

    enum Mode: String {
        case waiting
        case code
        case count
    }
    
    // MARK: Lifecycle
    
    init(service: VoiceRecognizerService = VoiceRecognizerService()) {
        self.service = service
        self.service.startTranscribing()
        
        service.$transcriptions
            .sink(receiveValue: { [weak self] transcript in
                guard let self = self, let transcriptMessage = transcript.last?.message else { return }
                self.applyConditions(to: transcriptMessage)
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
    @Published var recognitionMode: Mode = .waiting
    @Published var rawSpeech: [String] = []
    @Published var dataOutputs: [DataOutput] = []
    @Published var parameters: String = ""
    
    var isRecognizerStateOn: Bool {
        recognizerState == .on
    }
    
    func toggleRecognizerState() {
        service.toggleState()
    }
        
    func applyConditions(to transcriptionMessage: String) {
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
    
    // MARK: Private

    private var service: VoiceRecognizerService
    private var subscriptions: Set<AnyCancellable> = []

    private func setCommand(with transcriptionMessage: String) {
        guard let recognizedCommand = Command.allCases.first(where: { $0.rawValue == transcriptionMessage.lowercased() }) else { return }
        
        switch recognizedCommand.rawValue {
        case Command.code.rawValue, Command.count.rawValue:
            self.recognitionMode = Mode(rawValue: recognizedCommand.rawValue) ?? .waiting
        default:
            break
        }
    }
    
    private func setParameter(with transcriptionMessage: String) {
        guard let recognizedParameter = Parameter.allCases.first(where: { $0.rawValue == transcriptionMessage.lowercased() }) else { return }
        
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
        service.resetTranscribing()
    }
}

// MARK: VoiceRecognizerClientProtocol

extension ZupanVoiceRecognizerClient: VoiceRecognizerClientProtocol {
    
    // MARK: Command
    
    enum Command: String, CaseIterable {
        case code = "code"
        case count = "count"
        case back = "back"
        case reset = "reset"
        case done = "done"
        
        var transcription: String {
            switch self {
            case .code: "Code"
            case .count: "Count"
            case .back: "Back"
            case .reset: "Reset"
            case .done: "Done"
            }
        }
    }
    
    // MARK: Parameter
    
    enum Parameter: String, CaseIterable {
        case zero = "zero"
        case _0 = "0"
        case one = "one"
        case _1 = "1"
        case two = "two"
        case _2 = "2"
        case three = "three"
        case _3 = "3"
        case four = "four"
        case _4 = "4"
        case five = "five"
        case _5 = "5"
        case six = "six"
        case _6 = "6"
        case seven = "seven"
        case _7 = "7"
        case eight = "eight"
        case _8 = "8"
        case nine = "nine"
        case _9 = "9"
        
        var transcription: String {
            switch self {
            case .zero: "0"
            case ._0: "0"
            case .one: "1"
            case ._1: "1"
            case .two: "2"
            case ._2: "2"
            case .three: "3"
            case ._3: "3"
            case .four: "4"
            case ._4: "4"
            case .five: "5"
            case ._5: "5"
            case .six: "6"
            case ._6: "6"
            case .seven: "7"
            case ._7: "7"
            case .eight: "8"
            case ._8: "8"
            case .nine: "9"
            case ._9: "9"
            }
        }
    }
    
}
