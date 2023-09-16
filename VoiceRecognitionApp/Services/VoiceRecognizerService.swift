// 16.09.23 | VoiceRecognitionApp - VoiceRecognizerService.swift | Tom Estelrich

import Foundation

// MARK: VoiceRecognizerService

struct VoiceRecognizerService {
    
    // MARK: State
    
    enum State: String {
        case waiting = "Waiting"
        case listening = "Listening"
    }
    
    // MARK: Internal
    
    var state: State = .waiting
    
//    var dataOutputs: [DataOutput] = [
//        DataOutput(command: .count, parameters: [1, 2]),
//        DataOutput(command: .count, parameters: [1, 2]),
//        DataOutput(command: .count, parameters: [6, 0]),
//        DataOutput(command: .count, parameters: [6, 0]),
//        DataOutput(command: .count, parameters: [6, 0]),
//        DataOutput(command: .count, parameters: [6, 0]),
//        DataOutput(command: .count, parameters: [6, 0])
//    ]
    
    var dataOutputs: [DataOutput] = []
    
    mutating func updateState() {
        state = state == .waiting ? .listening : .waiting
    }
}
