//
//  Commit+Network.swift
//  Scenester
//
//  Created by Brian Ivan Gesiak on 6/10/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Foundation

extension Commit {
    static func latestCommit(repo: String,
        success: (commit: Commit) -> (), failure: (error: NSError) -> ()) {

            let endpoint = "https://api.github.com/repos/\(repo)/commits"
            let request = NSURLRequest(URL: NSURL(string: endpoint))

            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
                completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) in
                    if error {
                        failure(error: error)
                        return
                    }

                    var jsonError : NSError?
                    let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data,
                        options: NSJSONReadingOptions.fromRaw(0)!, error: &jsonError)
                    if jsonError {
                        failure(error: jsonError!)
                        return
                    }

                    if let commits = json as? NSDictionary[] {
                        if commits.count == 0 {
                            failure(error: self.commitError(CommitErrorCode.NoCommits))
                        } else {
                            let latest = commits[0]
                            if let message = latest["commit"]?["message"] as? String {
                                if let author = latest["author"]?["login"] as? String {
                                    let commit = Commit(message: message, author: author)
                                    success(commit: commit)
                                    return
                                }
                            }

                            failure(error: self.commitError(CommitErrorCode.InvalidCommit))
                        }
                    } else {
                        failure(error: self.commitError(CommitErrorCode.InvalidResponse))
                    }
                })
    }
}