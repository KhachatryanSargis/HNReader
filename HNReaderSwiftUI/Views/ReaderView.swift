//
//  ReaderView.swift
//  HNReaderSwiftUI
//
//  Created by Sargis Khachatryan on 07.09.24.
//

import SwiftUI
import Combine

struct ReaderView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var settings: Settings
    @ObservedObject var model: ReaderViewModel
    @State var presentingSettingsSheet = false
    @State var currentDate = Date()
    
    private let timer = Timer
        .publish(
            every: 10,
            on: .main,
            in: .common
        )
        .autoconnect()
        .eraseToAnyPublisher()
    
    init(model: ReaderViewModel) {
        self.model = model
    }
    
    var body: some View {
        let keywords = settings.keywords
            .map { $0.value }
            .joined(separator: ", ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let filter = keywords.isEmpty ? "Showing all stories" : "Filter: \(keywords)"
        
        return NavigationView {
            List {
                Section(header: Text(filter).padding(.leading, -10)) {
                    ForEach(self.model.stories) { story in
                        VStack(alignment: .leading, spacing: 10) {
                            TimeBadge(time: story.time)
                            
                            Text(story.title)
                                .frame(minHeight: 0, maxHeight: 100)
                                .font(.title)
                            
                            PostedBy(time: story.time, user: story.by, currentDate: self.currentDate)
                            
                            Button(story.url) {
                                print(story)
                            }
                            .font(.subheadline)
                            .foregroundColor(colorScheme == .light ? .blue : .orange)
                            .padding(.top, 6)
                        }
                        .padding()
                    }
                    .onReceive(timer) {
                        currentDate = $0
                    }
                }.padding()
            }
            .listStyle(PlainListStyle())
            .sheet(isPresented: $presentingSettingsSheet, content: {
                SettingsView()
                    .environmentObject(self.settings)
            })
            .alert(item: self.$model.error) { error in
                Alert(
                    title: Text("Network error"),
                    message: Text(error.localizedDescription),
                    dismissButton: .cancel()
                )
            }
            .navigationBarTitle(Text("\(self.model.stories.count) Stories"))
            .navigationBarItems(trailing: Button("Settings") {
                presentingSettingsSheet = true
            })
        }
    }
}

#Preview {
    ReaderView(model: ReaderViewModel())
}
