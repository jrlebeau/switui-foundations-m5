//
//  ContentViewRow.swift
//  LearningApp
//
//  Created by James Lebeau on 3/30/21.
//

import SwiftUI

struct ContentViewRow: View {

    @EnvironmentObject var module: ContentModel
    var index: Int
    
    
    var body: some View {
        
        let lesson = module.currentModule!.content.lessons[index]
        
        ZStack (alignment: .leading){
            
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66)
            
            HStack ( spacing: 30){
                
                Text(String(index + 1))
                    .bold()
                
                VStack (alignment: .leading) {
                    
                    Text(lesson.title)
                        .bold()
                    Text(lesson.duration)
                }
            }
            .padding()
        }
        .padding(.bottom, 5)

    }
}

