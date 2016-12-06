//
//  NSString+C99ExtendedIdentifier.swift
//  Quick
//
//  Created by Alex Manzella on 06/12/16.
//  Copyright © 2016 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

public extension NSString {

    private static var invalidCharacters: CharacterSet = {
        var invalidCharacters = CharacterSet()

        let invalidCharacterSets = [
            CharacterSet.whitespaces,
            CharacterSet.newlines,
            CharacterSet.illegalCharacters,
            CharacterSet.controlCharacters,
            CharacterSet.punctuationCharacters,
            CharacterSet.nonBaseCharacters,
            CharacterSet.symbols,
        ]

        for invalidSet in invalidCharacterSets {
            invalidCharacters.formUnion(invalidSet)
        }

        return invalidCharacters
    }()

    @objc(qck_c99ExtendedIdentifier)
    var c99ExtendedIdentifier: String {
        let validComponents = components(separatedBy: NSString.invalidCharacters) as NSArray
        let result = validComponents.componentsJoined(by: "_")

        return result.characters.count == 0 ? "_" : result
    }
}
