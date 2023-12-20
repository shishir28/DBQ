//
//  ConsentView.swift
//  DBQ
//
//  Created by Shishir Mishra on 22/12/2023.
//

import SwiftUI
import ResearchKit

struct ConsentView: View {
    
    @State private var results: [ORKStepResult] = []
    @State private var isPresentingSurvey = false
    
    var body: some View {
            Button("Conset Questionnaire") {
                isPresentingSurvey.toggle()
            }
            .sheet(isPresented: $isPresentingSurvey, onDismiss: processSurveyResults) {
                ConsentResearchKitView(isPresented: $isPresentingSurvey, results: $results)
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

struct ConsentResearchKitView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var results: [ORKStepResult]
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
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
        var parent: ConsentResearchKitView
        
        init(parent: ConsentResearchKitView) {
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
    
}

#Preview {
    ConsentView()
}
