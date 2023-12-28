//
//  QuestionnaireResult.swift
//  DBQ
//
//  Created by Shishir Mishra on 27/12/2023.
//

import Foundation

struct QuestionnaireResult : Codable {
    var sessionId: String = ""
    var resultDisctionary: [String: String]
    
    init() {
        self.resultDisctionary = [String: String]()
    }
    mutating func setValue(_ value: String, forKey key: String) {
        resultDisctionary[key] = value
    }
    
    // Function to retrieve a value for a given key
    func getValue(forKey key: String) -> String? {
        return resultDisctionary[key]
    }
}
