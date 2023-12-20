//
//  SurveyTask.swift
//  DBQ
//
//  Created by Shishir Mishra on 24/12/2023.
//

import Foundation
import ResearchKit

public var SurveyTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    //add instructions step
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "The Questions Three"
    instructionStep.text = "Who would cross the Bridge of Death must answer me these questions three, ere the other side they see."
    steps += [instructionStep]
    
    //add name question
    let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
    nameAnswerFormat.multipleLines = false
    let nameQuestionStepTitle = "What is your name?"
    let nameQuestionStep = ORKQuestionStep(identifier: "QuestionStep", title: nameQuestionStepTitle, answer: nameAnswerFormat)
    steps += [nameQuestionStep]
    
    
    //add 'what is your quest' question
    let questQuestionStepTitle = "What is your quest?"
    let textChoices = [
      ORKTextChoice(text: "Create a ResearchKit App", value: 0 as NSNumber),
      ORKTextChoice(text: "Seek the Holy Grail", value: 1 as NSNumber),
      ORKTextChoice(text: "Find a shrubbery", value: 2  as NSNumber)
    ]
    //'choiceAnswerFormatWithStyle(_:textChoices:)' has been renamed to 'choiceAnswerFormat(with:textChoices:)'
    let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let questQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: questQuestionStepTitle, answer: questAnswerFormat)
    steps += [questQuestionStep]

    
    //TODO: add color question step
    
    //add summary step
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Right. Off you go!"
    summaryStep.text = "That was easy!"
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
