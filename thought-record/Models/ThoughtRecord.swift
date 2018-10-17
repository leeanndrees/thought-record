//
//  ThoughtRecord.swift
//  thought-record
//
//  Created by DetroitLabs on 10/10/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import Foundation

class ThoughtRecord: Codable {
    
    var date: Date
    var thought: String
    var situation: String
    
    var feelingsStart: [Feeling]
    var unhelpfulThoughts: String
    var factsSupporting: String
    var factsAgainst: String
    var balancedPerspective: String
    var feelingsEnd: [Feeling]
    
    var tags: [Tag]
    
    init(date: Date, thought: String, situation: String, feelingsStart: [Feeling], unhelpfulThoughts: String, factsSupporting: String, factsAgainst:String, balancedPerspective: String, feelingsEnd: [Feeling], tags: [Tag]) {
        self.date = date
        self.thought = thought
        self.situation = situation
        self.feelingsStart = feelingsStart
        self.unhelpfulThoughts = unhelpfulThoughts
        self.factsSupporting = factsSupporting
        self.factsAgainst = factsAgainst
        self.balancedPerspective = balancedPerspective
        self.feelingsEnd = feelingsEnd
        self.tags = tags
    }
    
    var shortDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let dateString = dateFormatter.string(from: date)
        let formattedDate = dateFormatter.date(from: dateString)
        
        return dateFormatter.string(from: formattedDate!)
    }
    
    var longDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let dateString = dateFormatter.string(from: date)
        let formattedDate = dateFormatter.date(from: dateString)
        
        return dateFormatter.string(from: formattedDate!)
    }
}
