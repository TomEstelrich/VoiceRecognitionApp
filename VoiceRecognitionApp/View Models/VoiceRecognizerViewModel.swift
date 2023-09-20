// 16.09.23 | VoiceRecognitionApp - VoiceRecognizerViewModel.swift | Tom Estelrich

import SwiftUI

// MARK: VoiceRecognizerViewModel

final class VoiceRecognizerViewModel: ObservableObject {
    
    // MARK: Lifecycle
    
    init(client: ZupanVoiceRecognizerClient = ZupanVoiceRecognizerClient()) {
        self.client = client
    }
    
    // MARK: Internal
    
    var errorIcon: String {
        Symbol.errorIcon
    }
    
    var errorText: String? {
        guard let error = client.recognizerErrorMessage else { return nil }
        return "Error: \(error)"
    }
    
    var statusIcon: String {
        client.isRecognizerStateOn ? Symbol.statusIconOn : Symbol.statusIconOff
    }
    
    var currentStatusTitle: String {
        "CURRENT STATUS"
    }
    
    var statusText: String {
        guard client.isRecognizerStateOn else { return "State: OFF" }
        return "State: \(client.recognitionMode.rawValue.uppercased())"
    }
    
    var parameterIcon: String {
        Symbol.parameterIcon
    }
    
    var parameterText: String {
        "Parameters: \(client.parameters)"
    }
    
    var currentStateBackgroundColor: Color {
        guard let error = client.recognizerErrorMessage else {
            return client.isRecognizerStateOn ? Color.green : Color.red
        }
        
        return error != VoiceRecognizerService.RecognizerError.notRequested.message ? Color.red : Color(uiColor: .secondarySystemBackground)
    }
    
    var currentSpeechTitle: String {
        "CURRENT SPEECH"
    }
    
    var speechIcon: String {
        Symbol.speechIcon
    }
    
    var speechText: String {
        client.rawSpeech.joined(separator: " ")
    }
    
    var speechBackgroundColor: Color {
        guard client.isRecognizerStateOn,
              !client.rawSpeech.isEmpty else { return Color(uiColor: .secondarySystemBackground) }
        
        return Color.mint
    }
    
    var dataOutputsTitle: String {
        "DATA OUTPUTS"
    }
    
    var dataOutputs: [DataOutput] {
        client.dataOutputs
    }
    
    var commandDataOutputIcon: String {
        Symbol.commandDataOutputIcon
    }
    
    var emptyDataOutputText: String {
        "Empty"
    }
    
    var valueDataOutputIcon: String {
        Symbol.valueDataOutputIcon
    }
    
    var recognizerStateToggleIcon: String {
        Symbol.recognizerStateToggleIcon
    }
    
    var recognizerStateToggleIconColor: Color {
        isVoiceRecognizerListening ? Color.red : Color.gray
    }
    
    var isVoiceRecognizerListening: Bool {
        client.isRecognizerStateOn
    }
    
    var navigationTitle: String {
        "Voice Recognizer"
    }
    
    func toggleRecognizerState() {
        client.toggleRecognizerState()
    }
    
    func removeDataOutput(from indexSet: IndexSet) {
        client.dataOutputs.remove(atOffsets: indexSet)
    }
    
    // MARK: Private
    
    @Republished private var client: ZupanVoiceRecognizerClient
    
}
