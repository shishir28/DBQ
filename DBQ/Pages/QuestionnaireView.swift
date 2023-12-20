//
//  QuestionnaireView.swift
//  DBQ
//
//  Created by Shishir Mishra on 21/12/2023.
//

import SwiftUI
import ResearchKit


struct QuestionnaireView: View {
    
    @State private var results: [ORKStepResult] = []
    @State private var isPresentingSurvey = false
    
    var body: some View {
            Button("Start Questionnaire") {
                isPresentingSurvey.toggle()
            }
            .sheet(isPresented: $isPresentingSurvey, onDismiss: processSurveyResults) {
                ResearchKitView(isPresented: $isPresentingSurvey, results: $results)
            }
        }
    func processSurveyResults() {
          // Process the results obtained from the questionnaire
          for result in results {
              if let questionResult = result.results?.first as? ORKQuestionResult,
                 let answer = questionResult.answer {
                  print("Question: \(questionResult.identifier), Answer: \(answer)")
              }
          }
      }
}

struct ResearchKitView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var results: [ORKStepResult]
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let taskViewController = ORKTaskViewController(task: createQuestionnaire(), taskRun: nil)
        taskViewController.delegate = context.coordinator
        return taskViewController
    }
    
    func updateUIViewController(_ uiViewController: ORKTaskViewController, context: Context) {
        // Update the view controller if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, ORKTaskViewControllerDelegate {
        var parent: ResearchKitView
        
        init(parent: ResearchKitView) {
            self.parent = parent
        }
        
        func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
            guard reason == .completed else {
                    parent.isPresented = false
                    return
                }
            
            if let taskResult = taskViewController.result as? ORKTaskResult {
                   let results = taskResult.results as? [ORKStepResult] ?? []
                   parent.results = results
               }
            parent.isPresented = false
        }
    }
    
    func createQuestionnaire() -> ORKOrderedTask {
        // Define the first question
        let question1 = ORKQuestionStep(identifier: "question1", title: "Question 1", question: "How often do you exercise?", answer: ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: [
            ORKTextChoice(text: "Rarely", value: "Rarely" as NSString),
            ORKTextChoice(text: "Sometimes", value: "Sometimes" as NSString),
            ORKTextChoice(text: "Frequently", value: "Frequently" as NSString)
        ]))
        
        // Define the second question
        let question2 = ORKQuestionStep(identifier: "question2", title: "Question 2", question: "Do you get enough sleep?", answer: ORKAnswerFormat.booleanAnswerFormat())
        
        // Create an ordered task with the defined questions
        let task = ORKOrderedTask(identifier: "QuestionnaireTask", steps: [question1, question2])
        
        return task
    }

}

#Preview {
    QuestionnaireView()
}
