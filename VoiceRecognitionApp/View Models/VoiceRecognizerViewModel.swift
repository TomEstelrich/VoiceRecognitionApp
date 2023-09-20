// 16.09.23 | VoiceRecognitionApp - VoiceRecognizerViewModel.swift | Tom Estelrich

import SwiftUI

// MARK: VoiceRecognizerViewModel

final class VoiceRecognizerViewModel: ObservableObject {

    // MARK: Lifecycle
    
    init(service: ZupanVoiceRecognizerClient) {
        self.voiceRecognizerClient = service
    }
    
    // MARK: Internal
    
    var errorIcon: String {
        Symbol.errorIcon
    }
    
    var errorText: String? {
        guard let error = voiceRecognizerClient.recognizerErrorMessage else { return nil }
        return "Error: \(error)"
    }

    var statusIcon: String {
        voiceRecognizerClient.isRecognizerStateOn ? Symbol.statusIconOn : Symbol.statusIconOff
    }
    
    var currentStatusTitle: String {
        "CURRENT STATUS"
    }
    
    var statusText: String {
        guard voiceRecognizerClient.isRecognizerStateOn else { return "State: OFF" }
        return "State: \(voiceRecognizerClient.recognitionMode.rawValue.uppercased())"
    }
    
    var parameterIcon: String {
        Symbol.parameterIcon
    }
    
    var parameterText: String {
        "Parameters: \(voiceRecognizerClient.parameters)"
    }
    
    var currentStateBackgroundColor: Color {
        guard let error = voiceRecognizerClient.recognizerErrorMessage else {
            return voiceRecognizerClient.isRecognizerStateOn ? Color.green : Color.red
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
        voiceRecognizerClient.rawSpeech.joined(separator: " ")
    }
    
    var speechBackgroundColor: Color {        
        guard voiceRecognizerClient.isRecognizerStateOn,
              !voiceRecognizerClient.rawSpeech.isEmpty else { return Color(uiColor: .secondarySystemBackground) }
        
        return Color.mint
    }
    
    var dataOutputsTitle: String {
        "DATA OUTPUTS"
    }
    
    var dataOutputs: [DataOutput] {
        voiceRecognizerClient.dataOutputs
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
    
    var isVoiceRecognizerListening: Bool {
        voiceRecognizerClient.isRecognizerStateOn
    }
    
    var navigationTitle: String {
        "Voice Recognizer"
    }
    
    func toggleRecognizerState() {
        voiceRecognizerClient.toggleRecognizerState()
    }
    
    func removeDataOutput(from indexSet: IndexSet) {
        voiceRecognizerClient.dataOutputs.remove(atOffsets: indexSet)
    }
        
    // MARK: Private
    
    @Republished private var voiceRecognizerClient: ZupanVoiceRecognizerClient

}
