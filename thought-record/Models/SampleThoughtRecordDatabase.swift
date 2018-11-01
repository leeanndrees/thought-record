//
//  SampleThoughtRecordDatabase.swift
//  thought-record
//
//  Created by DetroitLabs on 10/10/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import Foundation

class ThoughtRecordDatabase {
    
    let thoughts = [
        ThoughtRecord(date: Date(),
                      thought: "Sample: presenting this app at work",
                      situation: "work presentation",
                      feelingsStart: [Feeling(name: "nervous", rating: 8)],
                      unhelpfulThoughts: "I'll probably throw up and die.",
                      factsSupporting: "Public speaking can make me nervous.",
                      factsAgainst: "I have done public speaking in the past, without throwing up or dying. Sometimes it's even been fun and rewarding.",
                      balancedPerspective: "I've worked hard to present this well, and I'm proud of the project as a whole. If it doesn't go well, I'll still be ok.",
                      feelingsEnd: [Feeling(name: "calmer", rating: 5)],
                      tags: [Tag(name: "work"), Tag(name: "public speaking")]
    )
    ]
}
