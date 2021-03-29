//
//  ContentView.swift
//  LearningApp
//
//  Created by James Lebeau on 3/23/21.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView {
            
            LazyHStack {
                
                ForEach(model.modules) { module in

                    HomeViewRow(image: module.content.image, title: "Learn\(module.category))", description: module.category.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                    
                    HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions) Questions", time: module.test.time)
                    
                }
            }
            .padding()

        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
