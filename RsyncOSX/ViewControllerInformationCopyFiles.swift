//
//  ViewControllerInformationCopyFiles.swift
//  RsyncOSX
//
//  Created by Thomas Evensen on 14/09/2016.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//

import Cocoa

class ViewControllerInformationCopyFiles: NSViewController {

    // TableView
    @IBOutlet weak var detailsTable: NSTableView!
    // output from Rsync
    var output: [String]?
    weak var informationDelegate: Information?
    weak var dismissDelegate: DismissViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTable.delegate = self
        detailsTable.dataSource = self
        // Setting the source for delegate function
        self.informationDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vccopyfiles)
            as? ViewControllerCopyFiles
        // Dismisser is root controller
        self.dismissDelegate = ViewControllerReference.shared.getvcref(viewcontroller: .vccopyfiles)
            as? ViewControllerCopyFiles
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        self.output = self.informationDelegate?.getInformation()
        detailsTable.reloadData()
    }

    @IBAction func close(_ sender: NSButton) {
        self.dismissDelegate?.dismiss_view(viewcontroller: self)
    }

}

extension ViewControllerInformationCopyFiles : NSTableViewDataSource {

    func numberOfRows(in aTableView: NSTableView) -> Int {
        if self.output != nil {
            return self.output!.count
        } else {
            return 0
        }
    }

}

extension ViewControllerInformationCopyFiles : NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        if tableColumn == tableView.tableColumns[0] {
            text = self.output![row]
            cellIdentifier = "outputID"
        }
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier),
                     owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }

}
