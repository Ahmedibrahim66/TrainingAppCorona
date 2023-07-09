//
//  tableCellView.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 04/07/2023.
//

import Cocoa

// MARK: - Delegate protocol
protocol TabelCellViewDelegate: AnyObject {
  func labelEditFinished(newValue: String)
}

class TableCellView: NSTableCellView, NSTextFieldDelegate {
  
  // MARK: - Public properties
  weak var delegate: TabelCellViewDelegate?
  
  // MARK: - IBOutlets
  @IBOutlet weak var cellViewLabel: NSTextField!

  // MARK: - IBActions
  @IBAction func labelValueChanged(_ sender: NSTextField) {
    delegate?.labelEditFinished(newValue: sender.stringValue)
  }
  
  // MARK: - Public functions
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
  }
}

extension TableCellView {
  // MARK: - Instanstiate Method
  static func instanstiate(_ tableView: NSTableView) -> TableCellView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("tableColumn"), owner: nil) as? TableCellView
    return cell
  }
}
