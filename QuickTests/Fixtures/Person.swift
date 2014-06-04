//
//  Person.swift
//  Quick
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

class Person {
	var isHappy = true
	var greeting: String {
		get {
			if isHappy {
				return "Hello!"
			} else {
				return "Oh, hi."
			}
		}
	}
}
