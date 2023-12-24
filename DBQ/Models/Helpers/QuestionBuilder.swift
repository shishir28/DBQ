//
//  SurveyTask.swift
//  DBQ
//
//  Created by Shishir Mishra on 24/12/2023.
//

import Foundation
import ResearchKit
import SwiftyJSON

struct QuestionBuilder {
    func createQuestionStep (_ questionArray: JSON) ->[ORKStep]{
        var steps = [ORKStep]()
        
        if let unwrappedArray = questionArray.array {
            for questionJON in unwrappedArray {
                // Access 'identifier' value from each JSON object
                guard questionJON["identifier"].string != nil,
                      let type = questionJON["type"].string else {break}
                
                if let identifier = questionJON["identifier"].string {
                    switch type {
                    case "sc":
                        let currentQuestionStep = buildSingleChoiceQuestion(questionJON)
                        steps.append(currentQuestionStep)
                    default:
                        print("Default")
                    }
                }
            }
            
        } else {
            print("jsonArray is nil")
        }
        
        return steps
    }
    
    func buildSingleChoiceQuestion (_ questionJON : JSON) -> ORKStep {
        var textChoices = [ORKTextChoice]()
        
        if let choiceArray = questionJON["choices"].array  {
            // Iterate through the unwrappedArray safely
            for choice in choiceArray {
                let currentChoice = ORKTextChoice(text: choice["text"].string!, value: choice["value"].int! as  NSNumber)
                textChoices.append(currentChoice)
            }
        }
        
        let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        let questQuestionStep = ORKQuestionStep(identifier: questionJON["identifier"].string!,
                                                title:  questionJON["title"].string!,
                                                question: questionJON["text"].string!,
                                                answer: questAnswerFormat)
        return questQuestionStep
    }
}
