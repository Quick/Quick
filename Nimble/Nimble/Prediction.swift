//
//  Prediction.swift
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/11/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

@objc class Prediction {
    let callsite: Callsite
    let negative: Bool

    init(callsite: Callsite, negative: Bool) {
        self.callsite = callsite
        self.negative = negative
    }

    func evaluate(matcher: Matcher) {
        NSException(name: NSInternalInconsistencyException,
            reason: "Subclasses must override this method", userInfo: nil).raise()
    }

    func fail(message: String, callsite: Callsite) {
        let userInfo = [
            "SenTestFilenameKey": callsite.file,
            "SenTestLineNumberKey": callsite.line
        ]
        NSException(name: "PredictionUnmetException", reason: message, userInfo: userInfo).raise()
    }
}
