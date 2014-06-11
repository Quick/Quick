//
//  Person.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

var _dbConnectionEstablished = false

class Person: NSObject {
    var isHappy = true
    var isHungry = false
    var isSatisfied = false
    var hopes = ["winning the lottery", "going on a blimp ride"]

    var greeting: String {
        get {
            if isHappy {
                return "Hello!"
            } else {
                return "Oh, hi."
            }
        }
    }

    func eatChineseFood() {
        let after = dispatch_time(DISPATCH_TIME_NOW, 500000000)
        dispatch_after(after, dispatch_get_main_queue()) {
            self.isHungry = true
        }
    }
  
    // Pretend to connect to a database. Return false if the connection is already established
    class func establishDbConnection() -> Bool {
        if dbConnectionEstablished() {
            return false
        } else {
            _dbConnectionEstablished = true
            return true
        }
    }

    // Pretend to disconnect from the database. Return false on failure
    class func relinquishDbConnection() -> Bool {
        if dbConnectionEstablished() {
            _dbConnectionEstablished = false
            return true
        } else {
            return false
        }
    }
    
    class func dbConnectionEstablished() -> Bool {
        return _dbConnectionEstablished
    }
}
