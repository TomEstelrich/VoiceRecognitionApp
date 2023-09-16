// 16.09.23 | VoiceRecognitionApp - VoiceRecognizerView.swift | Tom Estelrich

import SwiftUI

// MARK: VoiceRecognizerView

struct VoiceRecognizerView: View {
    
    // MARK: Internal
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("CURRENT STATE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 6) {
                    Label("Status: **\(voiceRecognizerViewModel.stateText)**", systemImage: voiceRecognizerViewModel.stateIcon)
                        .font(.subheadline)
                    
                    Label("Parameters: **\(voiceRecognizerViewModel.parameterText)**", systemImage: voiceRecognizerViewModel.parameterIcon)
                        .font(.subheadline)
                        .lineLimit(3)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.green)
                        .lineLimit(3)
                )
                .padding(.bottom)
                
                Text("CURRENT SPEECH")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Label("**\(voiceRecognizerViewModel.speechText)**", systemImage: voiceRecognizerViewModel.speechIcon)
                        .font(.subheadline)
                        .lineLimit(3)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.cyan)
                )
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            Section {
                Text("VALUES")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                if voiceRecognizerViewModel.dataOutputs.isEmpty {
                    Label("No values", systemImage: voiceRecognizerViewModel.commandIcon)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(uiColor: .secondarySystemBackground))
                } else {
                    List {
                        ForEach(voiceRecognizerViewModel.dataOutputs) { dataOutput in
                            VStack(alignment: .leading) {
                                Label("Command: **\(dataOutput.command.rawValue.uppercased())**", systemImage: voiceRecognizerViewModel.commandIcon)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                
                                Label("Value: **\(dataOutput.parameters.description)**", systemImage: voiceRecognizerViewModel.valueIcon)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                        .listRowBackground(Color.gray.opacity(0.25))
                    }
                    .listStyle(.plain)
                }

            }
            .navigationTitle("Voice Recognizer")
        }
    }
    
    // MARK: Private
    
    @StateObject private var voiceRecognizerViewModel: VoiceRecognizerViewModel = VoiceRecognizerViewModel(service: VoiceRecognizerService())
    
}

// MARK: VoiceRecognizerView Preview

#Preview {
    VoiceRecognizerView()
}
