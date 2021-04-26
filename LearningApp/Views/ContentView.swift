//
//  ContentView.swift
//  LearningApp
//
//  Created by James Lebeau on 3/30/21.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var module: ContentModel
    var body: some View {
        
        ScrollView {
            
            LazyVStack {
                
                if module.currentModule != nil {
                    ForEach(0..<module.currentModule!.content.lessons.count) { index in
                        
                        NavigationLink(
                            destination: ContentDetailView()
                                .onAppear(perform: {
                                    module.beginLesson(index)
                                }),
                            label: {
                                ContentViewRow(index: index)
                            })
                        
                    }
                }
            }
            .accentColor(.black)
            .padding()
            .navigationBarTitle("Learn \(module.currentModule?.category ?? "")")
        }
        
    }
}
