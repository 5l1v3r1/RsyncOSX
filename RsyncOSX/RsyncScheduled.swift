//
//  RsyncScheduled.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 10.03.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//

import Foundation

import Foundation

final class RsyncScheduled: processCmd {

    init (arguments: Array<String>?) {
        super.init(command: nil, arguments: arguments, aScheduledOperation: true)
        self.delegate_update = nil
    }

}
