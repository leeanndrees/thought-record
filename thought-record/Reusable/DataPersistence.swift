//
//  DataPersistence.swift
//  thought-record
//
//  Created by DetroitLabs on 10/24/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import Foundation

class DataPersistence {
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
