//
//  TemporaryData.swift
//  thought-record
//
//  Created by DetroitLabs on 10/10/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import Foundation

class FeelingDatabase {
    
    var feelings = [
        Feeling(name: "excited", rating: 8),
        Feeling(name: "scared", rating: 6),
        Feeling(name: "relaxed", rating: 5),
        Feeling(name: "worried", rating: 3)
    ]
    
}

class TagDatabase {
    
    var tags = [
        Tag(name: "work", useCount: 0),
        Tag(name: "weather: cloudy", useCount: 0),
        Tag(name: "friends", useCount: 0),
        Tag(name: "activity level: low", useCount: 0),
        Tag(name: "mindful minutes: none", useCount: 0)
    ]
}

class ThoughtRecordDatabase {
    
    var thoughts = [
        ThoughtRecord(date: Date(),
                      thought: "I'm never going to finish my capstone! It's too much.",
                      situation: "Working on capstone",
                      feelingsStart: [FeelingDatabase().feelings[1], FeelingDatabase().feelings[3]],
                      unhelpfulThoughts: "Everyone else has a better idea than me and I've somehow forgotten everything I ever learned about iOS devlepment and I'm going to get fired omg.",
                      factsSupporting: "It's a difficult and ambitious project and program!",
                      factsAgainst: "I've done well on the projects so far, even when they were overwhelming. I can pare down this project to a reasonable MVP.",
                      balancedPerspective: "I will finish. Even if I don't get to every feature I want, I'll have something to show that will demonstrate how far I've come in just 12 weeks.",
                      feelingsEnd: [FeelingDatabase().feelings[0]],
                      tags: [TagDatabase().tags[0]]
    ),
        ThoughtRecord(date: Date(),
                      thought: "I'm out sick so I'm going to forget everything I ever learned about coding",
                      situation: "home sick from work",
                      feelingsStart: [FeelingDatabase().feelings[0]],
                      unhelpfulThoughts: "Everyone else is getting time to work",
                      factsSupporting: "I am missing some work time",
                      factsAgainst: "I will be able to make it up. We have a long time to work on these projects.",
                      balancedPerspective: "I need to rest up because I'm sick. I'll get back to work tomorrow & it'll be ok.",
                      feelingsEnd: [FeelingDatabase().feelings[2]],
                      tags: [TagDatabase().tags[0]])
    ]
}
