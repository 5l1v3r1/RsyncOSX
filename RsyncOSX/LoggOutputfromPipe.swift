//
//  OutputfromPipe.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 14/07/2020.
//  Copyright © 2020 Thomas Evensen. All rights reserved.
//

import Foundation
struct LoggOutputfromPipe {
    var messages: [String]?
    init(pipe: Pipe?) {
        self.messages = [String]()
        if let outHandle = pipe?.fileHandleForReading {
            let capturedData = outHandle.readDataToEndOfFile()
            self.messages?.append(String(data: capturedData, encoding: .utf8) ?? "")
        }
        guard self.messages?.count ?? 0 > 0 else { return }
        let outputprocess = OutputProcess()
        outputprocess.addlinefromoutput(str: "Output from ShellOut")
        for i in 0 ..< (self.messages?.count ?? 0) {
            outputprocess.addlinefromoutput(str: self.messages?[i] ?? "")
        }
        _ = Logging(outputprocess, true)
    }
}
