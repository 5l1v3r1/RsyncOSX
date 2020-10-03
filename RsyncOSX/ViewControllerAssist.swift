//
//  ViewControllerAssist.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 01/10/2020.
//  Copyright © 2020 Thomas Evensen. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity

import Cocoa
import Foundation

class ViewControllerAssit: NSViewController, Delay {
    var remotecomputers: Set<String>?
    var remoteusers: Set<String>?
    var remotehome: Set<String>?
    var catalogs: Set<String>?
    var localhome: Set<String>?
    var numberofsets: Int = 5
    var nameandpaths: NamesandPaths?
    var assist: [Set<String>]?

    @IBOutlet var comboremoteusers: NSComboBox!
    @IBOutlet var addremoteusers: NSTextField!

    @IBOutlet var comboremotehome: NSComboBox!
    @IBOutlet var addremotehome: NSTextField!

    @IBOutlet var comboremotecomputers: NSComboBox!
    @IBOutlet var addremotecomputers: NSTextField!

    @IBOutlet var combocatalogs: NSComboBox!
    @IBOutlet var addcatalogs: NSTextField!

    @IBOutlet var combolocalhome: NSComboBox!
    @IBOutlet var addlocalhome: NSTextField!

    @IBAction func closeview(_: NSButton) {
        self.view.window?.close()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameandpaths = NamesandPaths(profileorsshrootpath: .profileroot)
        self.addremotecomputers.delegate = self
        self.addremoteusers.delegate = self
        self.addremotehome.delegate = self
        self.addcatalogs.delegate = self
        self.addlocalhome.delegate = self
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        self.read()
        // Initialize comboboxes
        self.initcomboxes(combobox: self.comboremotecomputers, values: self.remotecomputers)
        self.initcomboxes(combobox: self.comboremoteusers, values: self.remoteusers)
        self.initcomboxes(combobox: self.comboremotehome, values: self.remotehome)
        self.initcomboxes(combobox: self.combocatalogs, values: self.catalogs)
        self.initcomboxes(combobox: self.combolocalhome, values: self.localhome)
    }

    @IBAction func witeassist(_: NSButton) {
        self.write()
    }

    private func write() {
        guard self.remotecomputers != nil,
            self.remoteusers != nil,
            self.remotehome != nil,
            self.catalogs != nil,
            self.localhome != nil
        else {
            return
        }
        if self.assist == nil {
            self.assist = [Set<String>]()
        }
        for i in 0 ..< self.numberofsets {
            switch i {
            case 0:
                if self.remotecomputers != nil {
                    self.assist?.append(self.remotecomputers ?? [])
                }
            case 1:
                if self.remoteusers != nil {
                    self.assist?.append(self.remoteusers ?? [])
                }
            case 2:
                if self.remotehome != nil {
                    self.assist?.append(self.remotehome ?? [])
                }
            case 3:
                if self.catalogs != nil {
                    self.assist?.append(self.catalogs ?? [])
                }
            case 4:
                if self.localhome != nil {
                    self.assist?.append(self.localhome ?? [])
                }
            default:
                return
            }
        }
        PersistentStorageAssist(assistassets: self.assist).saveassist()
    }

    @IBAction func readassist(_: NSButton) {
        self.read()
    }

    private func read() {
        self.assist = Assist(assist: PersistentStorageAssist(assistassets: nil).readassist()).assist
        for i in 0 ..< self.numberofsets {
            switch i {
            case 0:
                self.remotecomputers = self.assist?[0]
            case 1:
                self.remoteusers = self.assist?[1]
            case 2:
                self.remotehome = self.assist?[2]
            case 3:
                self.catalogs = self.assist?[3]
            case 4:
                self.localhome = self.assist?[4]
            default:
                return
            }
        }
        self.assist = nil
    }

    private func initcomboxes(combobox: NSComboBox, values: Set<String>?) {
        combobox.removeAllItems()
        combobox.addItems(withObjectValues: Array(values ?? []))
        combobox.selectItem(at: 0)
    }
}

extension ViewControllerAssit: NSTextFieldDelegate {
    func controlTextDidChange(_: Notification) {
        delayWithSeconds(0.5) {}
    }
}
