//
//  ConvertUserconfiguration.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 26/04/2019.
//  Copyright © 2019 Thomas Evensen. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity function_body_length trailing_comma

import Foundation

struct ConvertUserconfiguration {
    var userconfiguration: [NSMutableDictionary]?

    init() {
        var version3Rsync: Int?
        var detailedlogging: Int?
        var minimumlogging: Int?
        var fulllogging: Int?
        var marknumberofdayssince: String?
        var automaticexecutelocalvolumes: Int?
        var haltonerror: Int?
        var array = [NSMutableDictionary]()

        if ViewControllerReference.shared.rsyncversion3 {
            version3Rsync = 1
        } else {
            version3Rsync = 0
        }
        if ViewControllerReference.shared.detailedlogging {
            detailedlogging = 1
        } else {
            detailedlogging = 0
        }
        if ViewControllerReference.shared.minimumlogging {
            minimumlogging = 1
        } else {
            minimumlogging = 0
        }
        if ViewControllerReference.shared.fulllogging {
            fulllogging = 1
        } else {
            fulllogging = 0
        }
        if ViewControllerReference.shared.automaticexecutelocalvolumes {
            automaticexecutelocalvolumes = 1
        } else {
            automaticexecutelocalvolumes = 0
        }
        if ViewControllerReference.shared.haltonerror == true {
            haltonerror = 1
        } else {
            haltonerror = 0
        }
        marknumberofdayssince = String(ViewControllerReference.shared.marknumberofdayssince)
        let dict: NSMutableDictionary = [
            "version3Rsync": version3Rsync ?? 0 as Int,
            "detailedlogging": detailedlogging ?? 0 as Int,
            "minimumlogging": minimumlogging! as Int,
            "fulllogging": fulllogging! as Int,
            "marknumberofdayssince": marknumberofdayssince ?? "5.0",
            "automaticexecutelocalvolumes": automaticexecutelocalvolumes! as Int,
            "haltonerror": haltonerror ?? 0 as Int,
        ]
        if let rsyncpath = ViewControllerReference.shared.localrsyncpath {
            dict.setObject(rsyncpath, forKey: "rsyncPath" as NSCopying)
        }
        if let restorepath = ViewControllerReference.shared.restorePath {
            dict.setObject(restorepath, forKey: "restorePath" as NSCopying)
        } else {
            dict.setObject("", forKey: "restorePath" as NSCopying)
        }
        if let pathrsyncosx = ViewControllerReference.shared.pathrsyncosx {
            if pathrsyncosx.isEmpty == false {
                dict.setObject(pathrsyncosx, forKey: "pathrsyncosx" as NSCopying)
            }
        }
        if let pathrsyncosxsched = ViewControllerReference.shared.pathrsyncosxsched {
            if pathrsyncosxsched.isEmpty == false {
                dict.setObject(pathrsyncosxsched, forKey: "pathrsyncosxsched" as NSCopying)
            }
        }
        if let environment = ViewControllerReference.shared.environment {
            dict.setObject(environment, forKey: "environment" as NSCopying)
        }
        if let environmentvalue = ViewControllerReference.shared.environmentvalue {
            dict.setObject(environmentvalue, forKey: "environmentvalue" as NSCopying)
        }
        array.append(dict)
        self.userconfiguration = array
    }
}
