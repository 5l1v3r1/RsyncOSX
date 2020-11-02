//
//  ScheduleLoggData.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 23/09/2016.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//
//  Object for sorting and holding logg data about all tasks.
//  Detailed logging must be set on if logging data.
//
// swiftlint:disable trailing_comma line_length

import Foundation

enum Sortandfilter {
    case offsitecatalog
    case localcatalog
    case profile
    case offsiteserver
    case task
    case backupid
    case numberofdays
    case executedate
    case none
}

final class ScheduleLoggData: SetConfigurations, SetSchedules, Sorting {
    var loggdata: [NSMutableDictionary]?
    private var scheduleConfiguration: [ConfigurationSchedule]?

    func filter(search: String?, filterby: Sortandfilter?) {
        globalDefaultQueue.async { () -> Void in
            let valueforkey = self.filterbystring(filterby: filterby ?? Optional.none)
            self.loggdata = self.loggdata?.filter {
                ($0.value(forKey: valueforkey) as? String ?? "").contains(search ?? "")
            }
        }
    }

    private func readandsortallloggdata(hiddenID: Int?, sortascending: Bool) {
        var data = [NSMutableDictionary]()
        if let input: [ConfigurationSchedule] = self.schedules?.getSchedule() {
            for i in 0 ..< input.count {
                for j in 0 ..< (input[i].logrecords?.count ?? 0) {
                    if let hiddenID = self.schedules?.getSchedule()?[i].hiddenID {
                        var date: String?
                        if let stringdate = input[i].logrecords?[j].dateExecuted {
                            if stringdate.isEmpty == false {
                                date = stringdate.en_us_date_from_string().localized_string_from_date()
                            }
                        }
                        let logdetail: NSMutableDictionary = [
                            "localCatalog": self.configurations?.getResourceConfiguration(hiddenID, resource: .localCatalog) ?? "",
                            "remoteCatalog": self.configurations?.getResourceConfiguration(hiddenID, resource: .remoteCatalog) ?? "",
                            "offsiteServer": self.configurations?.getResourceConfiguration(hiddenID, resource: .offsiteServer) ?? "",
                            "task": self.configurations?.getResourceConfiguration(hiddenID, resource: .task) ?? "",
                            "backupID": self.configurations?.getResourceConfiguration(hiddenID, resource: .backupid) ?? "",
                            "dateExecuted": date ?? "",
                            "resultExecuted": input[i].logrecords?[j].resultExecuted ?? "",
                            "deleteCellID": self.loggdata?[j].value(forKey: "deleteCellID") as? Int ?? 0,
                            "hiddenID": hiddenID,
                            "snapCellID": 0,
                            "parent": i,
                            "sibling": j,
                        ]
                        data.append(logdetail)
                    }
                }
            }
        }
        if hiddenID != nil {
            data = data.filter { ($0.value(forKey: "hiddenID") as? Int) == hiddenID }
        }
        self.loggdata = self.sortbydate(notsortedlist: data, sortdirection: sortascending)
    }

    let compare: (NSMutableDictionary, NSMutableDictionary) -> Bool = { number1, number2 in
        if number1.value(forKey: "sibling") as? Int == number2.value(forKey: "sibling") as? Int,
           number1.value(forKey: "parent") as? Int == number2.value(forKey: "parent") as? Int
        {
            return true
        } else {
            return false
        }
    }

    func align(snapshotlogsandcatalogs: Snapshotlogsandcatalogs?) {
        guard snapshotlogsandcatalogs?.snapshotslogs != nil else { return }
        guard self.loggdata != nil else { return }
        for i in 0 ..< (self.loggdata?.count ?? 0) {
            for j in 0 ..< (snapshotlogsandcatalogs?.snapshotslogs?.count ?? 0) where
                self.compare(snapshotlogsandcatalogs!.snapshotslogs![j], self.loggdata![i])
            {
                self.loggdata![i].setValue(1, forKey: "snapCellID")
            }
            if self.loggdata![i].value(forKey: "snapCellID") as? Int == 1 {
                self.loggdata![i].setValue(0, forKey: "deleteCellID")
            } else {
                self.loggdata![i].setValue(1, forKey: "deleteCellID")
            }
        }
    }

    init(sortascending: Bool) {
        if self.loggdata == nil {
            self.readandsortallloggdata(hiddenID: nil, sortascending: sortascending)
        }
    }

    init(hiddenID: Int, sortascending: Bool) {
        if self.loggdata == nil {
            self.readandsortallloggdata(hiddenID: hiddenID, sortascending: sortascending)
        }
    }
}
