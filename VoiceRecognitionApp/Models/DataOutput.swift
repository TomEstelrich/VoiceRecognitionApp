// 19.09.23 | VoiceRecognitionApp - DataOutput.swift | Tom Estelrich

import Foundation

// MARK: DataOutput

struct DataOutput: Identifiable {
    
    let id: UUID = UUID()
    let command: String
    let parameters: String
    
}
