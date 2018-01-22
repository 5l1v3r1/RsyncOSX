//
//  SnapshotCurrent.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 16.01.2018.
//  Copyright © 2018 Thomas Evensen. All rights reserved.
//
// swiftlint:disable syntactic_sugar

import Foundation

final class SnapshotCurrent: ProcessCmd {
    override init (command: String?, arguments: Array<String>?) {
        super.init(command: command, arguments: arguments)
        self.updateDelegate = nil
    }
}
