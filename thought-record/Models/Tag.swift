//
//  Tag.swift
//  thought-record
//
//  Created by DetroitLabs on 10/10/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import Foundation

class Tag: Codable {
    var name: String
    var useCount: Int
    
    init(name: String, useCount: Int) {
        self.name = name
        self.useCount = useCount
    }
    
    func updateUseCount() {
        self.useCount = self.useCount + 1
    }
}
