//
//  Tone.swift
//  thought-record
//
//  Created by DetroitLabs on 10/17/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import Foundation

enum Tone: String {
    case anger = "anger"
    case fear = "fear"
    case joy = "joy"
    case sadness = "sadness"
    case analytical = "analytical"
    case confident = "confident"
    case tentative = "tentative"
    
    func getExpandedTones() -> [String] {
        switch self {
        case .anger: return ["frustrated", "annoyed", "angry"]
        case .fear: return ["concerned", "alarmed", "afraid"]
        case .joy: return ["happy", "joyful", "content"]
        case .sadness: return ["sad", "gloomy", "glum"]
        case .analytical: return ["analytical", "thoughtful"]
        case .confident: return ["confident", "strong", "sure"]
        case .tentative: return ["uncertain", "confused", "tentative"]
        }
    }
}

