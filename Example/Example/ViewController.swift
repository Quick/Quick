//
//  ViewController.swift
//  Example
//
//  Created by Brian Ivan Gesiak on 6/8/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var thankYouField : NSTextField

    @IBAction func onViewOnGitHubButton(button : NSButton) {
        let url = NSURL(string: "https://github.com/modocache/Quick")
        NSWorkspace.sharedWorkspace().openURL(url)
    }
}

