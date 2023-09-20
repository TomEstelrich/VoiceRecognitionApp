// 16.09.23 | VoiceRecognitionApp - VoiceRecognizerView.swift | Tom Estelrich

import SwiftUI

// MARK: VoiceRecognizerView

struct VoiceRecognizerView: View {
    
    // MARK: Internal
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(viewModel.currentStatusTitle)
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 6) {
                    if let errorText = viewModel.errorText {
                        Label(errorText, systemImage: viewModel.errorIcon)
                            .fontWeight(.bold)
                            .lineLimit(3)
                    } else {
                        Label(viewModel.statusText, systemImage: viewModel.statusIcon)
                            .fontWeight(.bold)
                            .lineLimit(3)
                        
                        Label(viewModel.parameterText, systemImage: viewModel.parameterIcon)
                            .fontWeight(.bold)
                            .truncationMode(.head)
                            .lineLimit(3)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(viewModel.currentStateBackgroundColor)
                        .animation(.easeInOut, value: viewModel.currentStateBackgroundColor)
                        .lineLimit(3)
                )
                .padding(.bottom)
                
                Text(viewModel.currentSpeechTitle)
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack {
                    Label(viewModel.speechText, systemImage: viewModel.speechIcon)
                        .fontWeight(.bold)
                        .truncationMode(.head)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(viewModel.speechBackgroundColor)
                        .animation(.easeInOut, value: viewModel.speechBackgroundColor)
                )
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            VStack {
                Text(viewModel.dataOutputsTitle)
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                if viewModel.dataOutputs.isEmpty {
                    Label(viewModel.emptyDataOutputText, systemImage: viewModel.commandDataOutputIcon)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(uiColor: .secondarySystemBackground))
                } else {
                    List {
                        ForEach(viewModel.dataOutputs) { dataOutput in
                            VStack(alignment: .leading, spacing: 6) {
                                Label(dataOutput.command.uppercased(), systemImage: viewModel.commandDataOutputIcon)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Label(dataOutput.parameters, systemImage: viewModel.valueDataOutputIcon)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 8)
                        }
                        .onDelete { indexSet in
                            viewModel.removeDataOutput(from: indexSet)
                        }
                        .listRowBackground(Color(uiColor: .secondarySystemBackground))
                    }
                    .listStyle(.plain)
                }

            }
            .navigationTitle(viewModel.navigationTitle)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        viewModel.toggleRecognizerState()
                    } label: {
                        Image(systemName: viewModel.recognizerStateToggleIcon)
                            .font(.title3)
                            .foregroundColor(viewModel.recognizerStateToggleIconColor)
                    }
                }
            }
        }
    }
    
    // MARK: Private
    
    @StateObject private var viewModel: VoiceRecognizerViewModel = VoiceRecognizerViewModel()
    
}

// MARK: VoiceRecognizerView Preview

#Preview {
    VoiceRecognizerView()
}
