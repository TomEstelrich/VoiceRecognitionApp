// 16.09.23 | VoiceRecognitionApp - VoiceRecognizerViewModel.swift | Tom Estelrich

import Foundation

// MARK: VoiceRecognizerViewModel

final class VoiceRecognizerViewModel: ObservableObject {

    // MARK: Lifecycle
    
    init(service: VoiceRecognizerService) {
        self.service = service
    }
    
    // MARK: Internal

    var stateText: String {
        service.state.rawValue.uppercased()
    }
    
    var stateIcon: String {
        service.state == .listening ? "mic.fill" : "mic.slash"
    }
    
    var parameterIcon: String {
        "number"
    }
    
    var parameterText: String {
        "12".uppercased()
    }
    
    var speechIcon: String {
        "waveform"
    }
    
    var speechText: String {
        "count one two...".uppercased()
    }
    
    var commandIcon: String {
        "bubble.left.and.exclamationmark.bubble.right"
    }
    
    var valueIcon: String {
        "number"
    }
    
    var valueText: String {
        "1234"
    }
    
    var dataOutputs: [DataOutput] {
        service.dataOutputs
    }
    
    // MARK: Private
    
    @Published private var service: VoiceRecognizerService

}
