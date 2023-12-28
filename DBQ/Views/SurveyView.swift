//
//  SurveyView.swift
//  DBQ
//
//  Created by Shishir Mishra on 24/12/2023.
//

import SwiftUI
import ResearchKit

struct SurveyView: View {
    @State private var results: [ORKStepResult] = []
    @State private var isPresentingSurvey = false
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            if (isPresentingSurvey) {
                SurveyKitView(isPresented: $isPresentingSurvey, results: $results).onDisappear(perform: processSurveyResults)
            }else {
                VStack {
                    Button(action: startSurvey) {
                        Text("Start Survey")
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(Color.blue)
                            .cornerRadius(10)
                        .shadow(radius: 5)}
                }
            }
        }
    }
    
    func startSurvey() {
        isPresentingSurvey.toggle()
    }
    func processSurveyResults() {
        // Process the results obtained from the questionnaire
        var questionnaireResult = QuestionnaireResult()
        questionnaireResult.sessionId = sessionStore.sessionId
        
        for result in results {
            if let questionResult = result.results?.first as? ORKQuestionResult,
               let answer = questionResult.answer {
                questionnaireResult.setValue(answer.description, forKey:String(questionResult.identifier))
            }
        }
        sessionStore.saveQuestionnaireResult(questionnaireResult)
    }
}
    

struct SurveyKitView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var results: [ORKStepResult]
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let surveyTask = SurveyBuilder().createSurveyTask()
        
        let taskViewController = ORKTaskViewController(task: surveyTask, taskRun: nil)
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
        var parent: SurveyKitView
        
        init(parent: SurveyKitView) {
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
                print(results)
            }
            parent.isPresented = false
        }
    }
}
