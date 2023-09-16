// 16.09.23 | VoiceRecognitionApp - DataOutput.swift | Tom Estelrich

import Foundation

// MARK: DataOutput

struct DataOutput: Identifiable {
    
    // MARK: Command
    
    enum Command: String {
        case reset  = "Reset"
        case back = "Back"
        case code = "Code"
        case count = "Count"
    }
    
    // MARK: Internal
    
    let id: UUID = UUID()
    let command: Command
    let parameters: [Int]
    
}
