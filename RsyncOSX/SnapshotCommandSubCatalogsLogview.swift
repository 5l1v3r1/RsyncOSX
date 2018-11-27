//
//  SnapshotCommandSubCatalogsLogview.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 27/11/2018.
//  Copyright © 2018 Thomas Evensen. All rights reserved.
//

import Foundation

final class SnapshotCommandSubCatalogsLogview: ProcessCmd {
    override init (command: String?, arguments: [String]?) {
        super.init(command: command, arguments: arguments)
        self.updateDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vcloggdata) as? ViewControllerLoggData
    }
}
