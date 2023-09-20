// 16.09.23 | VoiceRecognitionApp - DataOutput.swift | Tom Estelrich

import Foundation

// MARK: DataRecognitionProtocol

protocol DataRecognitionProtocol {
    
    var recognizableCommands: [DataRecognition] { get }
    var recognizableParameters: [DataRecognition] { get }
    
}

// MARK: DataRecognition

struct DataRecognition: Identifiable {
    
    let id: UUID = UUID()
    let value: String
    let transcription: String
    
}
