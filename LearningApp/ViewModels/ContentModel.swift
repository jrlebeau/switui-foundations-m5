//
//  ContentModel.swift
//  LearningApp
//
//  Created by James Lebeau on 3/23/21.
//

import Foundation
class ContentModel: ObservableObject {
    
    @Published var modules = [Module]()
    
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    
    init() {
        
        getLocalData()
        
        getRemoteData()
    }
    
    
    // MARK: - Data Methods
    func getLocalData()  {
        
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: jsonUrl)
            
            let jsonDecoder = JSONDecoder()
            
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
                        
            self.modules = modules
            
        }
        catch {
            // TODO log error
            print("Could not parse local data")
        }
        
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")!
        do {
            let styleData = try Data(contentsOf: styleUrl)
            
            self.styleData = styleData
        }
        catch {
            print("Could not parse style data")
        }
    }
    
    func getRemoteData() {
        
        let urlString = "https://jrlebeau.github.io/learningapp-data/data2.json"
        
        let url = URL(string: urlString)
        guard url != nil else {
            return
        }
        
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let modules = try decoder.decode([Module].self, from: data!)
                self.modules += modules

            }
            catch {
                
            }
            
        }
        
        dataTask.resume()
    }
    
    //MARK: Module navigation methods
    
    func beginModule(_ moduleid:Int) {
        
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                currentModuleIndex = index
                break
            }
        }
        
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex:Int) {
        
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func hasNextLesson() -> Bool {
        if currentLessonIndex + 1 < currentModule!.content.lessons.count {
            return true
        } else {
            return false
        }
    }
    
    func nextLesson() {
        
        currentLessonIndex += 1
        
        if currentLessonIndex < currentModule!.content.lessons.count {
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        } else {
            currentLesson = nil
            currentLessonIndex = 0
            
        }
    }
    
    func nextQuestion() {
        
        currentQuestionIndex += 1
        if currentQuestionIndex < currentModule!.test.questions.count {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
            
        } else {
            currentQuestion = nil
            currentQuestionIndex = 0
        }
    }
    
    func beginTest(_ moduleId:Int) {
        
        beginModule(moduleId)
        
        currentQuestionIndex = 0
        
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        if styleData != nil {
            data.append(self.styleData!)

        }
        
        data.append(Data(htmlString.utf8))
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
 
            resultString = attributedString

        }
        
        return resultString
        
    }
    
        func buttonText(_ submitted:Bool) -> String {
            if submitted == true {
                if currentQuestionIndex + 1 == currentQuestion?.content.count {
                    return "Finish"
                } else {
                    return "Next"
                }
            } else {
                return "Submit"
            }
        }
    
}
