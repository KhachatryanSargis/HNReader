//
//  ReaderView.swift
//  HNReaderSwiftUI
//
//  Created by Sargis Khachatryan on 07.09.24.
//

import SwiftUI

struct ReaderView: View {
    var model: ReaderViewModel
    @State var presentingSettingsSheet = false
    
    var currentDate = Date()
    
    init(model: ReaderViewModel) {
        self.model = model
    }
    
    var body: some View {
        let filter = "Showing all stories"
        
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
                            .foregroundColor(Color.blue)
                            .padding(.top, 6)
                        }
                        .padding()
                    }
                    // Add timer here
                }.padding()
            }
            .listStyle(PlainListStyle())
            .sheet(isPresented: $presentingSettingsSheet, content: {
                SettingsView()
            })
            // Display errors here
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
