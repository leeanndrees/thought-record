//
//  Settings.swift
//  thought-record
//
//  Created by DetroitLabs on 10/17/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import Foundation

class Settings: Codable {
    var allowTextAnalysis: Bool
    
    init (allowTextAnalysis: Bool) {
        self.allowTextAnalysis = allowTextAnalysis
    }
}

var userSettings = Settings(allowTextAnalysis: true)
