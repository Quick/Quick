//
//  GitHub.swift
//  Scenester
//
//  Created by Brian Ivan Gesiak on 6/10/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

struct Commit {
    let message: String
    let author: String
    
    var simpleDescription: String { get { return "\(author): '\(message)'" } }
    
    init(message: String, author: String) {
        self.message = message
        self.author = author
    }
}
