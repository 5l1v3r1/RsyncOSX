//
//  ViewControllerAllProfiles.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 07.03.2018.
//  Copyright © 2018 Thomas Evensen. All rights reserved.
//
// swiftlint:disable line_length

import Foundation
import Cocoa

class ViewControllerAllProfiles: NSViewController, Delay {

    // Main tableview
    @IBOutlet weak var mainTableView: NSTableView!
    @IBOutlet weak var search: NSSearchField!
    @IBOutlet weak var sortdirection: NSButton!
    @IBOutlet weak var numberOfprofiles: NSTextField!

    private var allprofiles: AllConfigurations?
    private var allschedules: Allschedules?
    private var allschedulessortedandexpanded: ScheduleSortedAndExpand?
    private var column: Int?
    private var filterby: Sortandfilter?
    private var sortedascendigdesending: Bool = true

    @IBAction func sortdirection(_ sender: NSButton) {
        if self.sortedascendigdesending == true {
            self.sortedascendigdesending = false
            self.sortdirection.image = #imageLiteral(resourceName: "down")
        } else {
            self.sortedascendigdesending = true
            self.sortdirection.image = #imageLiteral(resourceName: "up")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting delegates and datasource
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.search.delegate = self
        ViewControllerReference.shared.setvcref(viewcontroller: .vcallprofiles, nsviewcontroller: self)
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        self.allprofiles = AllConfigurations()
        self.allschedules = Allschedules(nolog: true)
        self.allschedulessortedandexpanded = ScheduleSortedAndExpand(allschedules: self.allschedules)
        self.sortdirection.image = #imageLiteral(resourceName: "up")
        self.sortedascendigdesending = true
        self.allprofiles?.allconfigurationsasdictionary = self.allprofiles!.sortbyrundate(notsorted: self.allprofiles?.allconfigurationsasdictionary, sortdirection: self.sortedascendigdesending)
        globalMainQueue.async(execute: { () -> Void in
            self.mainTableView.reloadData()
        })
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        self.allprofiles = nil
        self.allschedules = nil
        self.allschedulessortedandexpanded = nil
    }
}

extension ViewControllerAllProfiles: NSTableViewDataSource {
    // Delegate for size of table
    func numberOfRows(in tableView: NSTableView) -> Int {
        if self.allprofiles?.allconfigurationsasdictionary == nil {
            self.numberOfprofiles.stringValue = "Number of profiles:"
            return 0
        } else {
            self.numberOfprofiles.stringValue = "Number of profiles: " +
                String(self.allprofiles!.allconfigurationsasdictionary?.count ?? 0)
            return self.allprofiles!.allconfigurationsasdictionary?.count ?? 0
        }
    }
}

extension ViewControllerAllProfiles: NSTableViewDelegate, Attributedestring {

    // TableView delegates
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if row > self.allprofiles!.allconfigurationsasdictionary!.count - 1 { return nil }
        let object: NSDictionary = self.allprofiles!.allconfigurationsasdictionary![row]
        let hiddenID = object.value(forKey: "hiddenID") as? Int ?? -1
        let profilename = object.value(forKey: "profile") as? String ?? "Default profile"
        if tableColumn!.identifier.rawValue == "intime" {
            let taskintime: String? = self.allschedulessortedandexpanded!.sortandcountscheduledonetask(hiddenID, profilename: profilename, number: true)
            return taskintime ?? ""
        } else if tableColumn!.identifier.rawValue == "schedule" {
            let schedule: String? = self.allschedulessortedandexpanded!.sortandcountscheduledonetask(hiddenID, profilename: profilename, number: false)
            return schedule
        } else {
            return object[tableColumn!.identifier] as? String
        }
    }
    // setting which table row is selected
    func tableViewSelectionDidChange(_ notification: Notification) {
        let myTableViewFromNotification = (notification.object as? NSTableView)!
        let column = myTableViewFromNotification.selectedColumn
        var sortbystring = true
        self.column = column
        switch column {
        case 0:
            self.filterby = .profile
        case 3:
            self.filterby = .task
        case 4:
            self.filterby = .localcatalog
        case 5:
            self.filterby = .remotecatalog
        case 6:
            self.filterby = .remoteserver
        case 7:
            self.filterby = .backupid
        case 8, 9:
            sortbystring = false
            self.filterby = .executedate
        default:
            return
        }
        if sortbystring {
            self.allprofiles?.allconfigurationsasdictionary = self.allprofiles!.sortbystring(notsorted: self.allprofiles?.allconfigurationsasdictionary, sortby: self.filterby!, sortdirection: self.sortedascendigdesending)
        } else {
            self.allprofiles?.allconfigurationsasdictionary = self.allprofiles!.sortbyrundate(notsorted: self.allprofiles?.allconfigurationsasdictionary, sortdirection: self.sortedascendigdesending)
        }
        globalMainQueue.async(execute: { () -> Void in
            self.mainTableView.reloadData()
        })
    }
}

extension ViewControllerAllProfiles: NSSearchFieldDelegate {

    override func controlTextDidChange(_ obj: Notification) {
        self.delayWithSeconds(0.25) {
            guard self.column != nil else { return }
            let filterstring = self.search.stringValue
            if filterstring.isEmpty {
                globalMainQueue.async(execute: { () -> Void in
                    self.allprofiles = AllConfigurations()
                    self.mainTableView.reloadData()
                })
            } else {
                globalMainQueue.async(execute: { () -> Void in
                    self.allprofiles?.filter(search: filterstring, column: self.column!, filterby: self.filterby)
                    self.mainTableView.reloadData()
                })
            }
        }
    }

    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        globalMainQueue.async(execute: { () -> Void in
            self.allprofiles = AllConfigurations()
            self.mainTableView.reloadData()
        })
    }
}
