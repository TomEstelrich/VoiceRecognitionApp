// 20.09.23 | VoiceRecognitionApp - Transcription.swift | Tom Estelrich

import Foundation

// MARK: Transcription

struct Transcription: Identifiable {
    
    let id: UUID = UUID()
    let timestamp: Double
    let message: String
    
}
