//
//  ConsentTask.swift
//  DBQ
//
//  Created by Shishir Mishra on 22/12/2023.
//

import Foundation
import ResearchKit

public var ConsentTask: ORKOrderedTask {
  
  var steps = [ORKStep]()
  
  //Add VisualConsentStep
    var consentDocument = ConsentDocument
  
//    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
//    steps += [visualConsentStep]
  
  //: Add ConsentReviewStep
    
    let signature = consentDocument.signatures!.first as! ORKConsentSignature

    let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
//'init(identifier:signature:inDocument:)' has been renamed to 'init(identifier:signature:in:)'
    reviewConsentStep.text = "Review Consent!"
    reviewConsentStep.reasonForConsent = "Consent to join study"

    steps += [reviewConsentStep]
  
  return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}
