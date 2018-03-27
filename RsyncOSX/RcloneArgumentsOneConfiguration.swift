//
//  RcloneArgumentsOneConfiguration.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 23.03.2018.
//  Copyright © 2018 Thomas Evensen. All rights reserved.
//

import Foundation
struct RcloneArgumentsOneConfiguration {

    var config: ConfigurationRclone?
    var arg: [String]?

    init(config: ConfigurationRclone) {
        self.config = config
        self.arg = RcloneRsyncProcessArguments().argumentsRsync(config)
    }
}
