//
//  SurveyTask.swift
//  DBQ
//
//  Created by Shishir Mishra on 24/12/2023.
//

import Foundation
import ResearchKit
import SwiftyJSON

struct SurveyBuilder {
    func createSurveyTask () ->ORKOrderedTask? {
        let jsonResult =  returnJSON(jsonFileName:"Questions_en")
        let createdTasks = buildSurveyWithJSON(surveyJSON:jsonResult);
        return createdTasks
    }
    
    func returnJSON(jsonFileName: String) -> JSON? {
        var json: JSON?
        if let jsonFile = Bundle.main.url(forResource: jsonFileName, withExtension: "json") {
            if let jsonData = try? Data(contentsOf: jsonFile) {
                do {
                    json = try JSON(data: jsonData)
                } catch {
                    // need to log the exception and may be report user
                }
            }
        }
        return json
    }
    
    func buildSurveyWithJSON(surveyJSON:JSON?) -> ORKOrderedTask? {
        var questionnaire = (title: "", text: "", identifier: "", steps: [ORKStep]())
        var steps = [ORKStep]()
        
        if let surveyJSONData = surveyJSON {
            // Accessing the subscript safely after unwrapping
            questionnaire.title =  surveyJSONData["title"].string ?? "No Title"
            questionnaire.text = surveyJSONData["text"].string ?? "No Text"
            questionnaire.identifier = surveyJSONData["identifier"].string ?? "No Identifier"
            if let unwrappedJSON = surveyJSON {
                
                //add instructions step
                let instructionStep = buildIntroductionWithJson(unwrappedJSON["introduction"])
                steps += [instructionStep!]
                
                //add name question
                let questionSteps = QuestionBuilder().createQuestionStep(unwrappedJSON["questions"])
                steps.append(contentsOf: questionSteps)
                
                //add summary step
                let summaryStep = buildSummaryWithJson(unwrappedJSON["summary"])
                steps += [summaryStep!]
            }
            return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
            
        } else {
            print("JSON object is nil")
            return nil
        }
    }
    
    func buildIntroductionWithJson(_ introductionSummary:JSON?) -> ORKInstructionStep? {
        if let unwrappedJSON = introductionSummary {
            let introductionStep = ORKInstructionStep(identifier: unwrappedJSON["identifier"].string!)
            introductionStep.title = unwrappedJSON["title"].string!
            introductionStep.text = unwrappedJSON["text"].string!
            return introductionStep
        }
        return nil
    }
    
    func buildSummaryWithJson(_ summaryJSON:JSON?) -> ORKCompletionStep? {
        if let unwrappedJSON = summaryJSON {
            let summaryStep = ORKCompletionStep(identifier: unwrappedJSON["identifier"].string!)
            summaryStep.title = unwrappedJSON["title"].string!
            summaryStep.text = unwrappedJSON["text"].string!
            return summaryStep
        }
        return nil
    }
}
