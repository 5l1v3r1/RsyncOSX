//
//  RsyncClosure.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 14/09/2020.
//  Copyright © 2020 Thomas Evensen. All rights reserved.
//

final class RsyncClosure: ProcessCmdClosure {
    override init(arguments: [String]?, config: Configuration?,
                  processtermination: @escaping () -> Void,
                  filehandler: @escaping () -> Void)
    {
        super.init(arguments: arguments, config: config,
                   processtermination: processtermination,
                   filehandler: filehandler)
    }
}
