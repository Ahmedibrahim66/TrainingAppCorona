//
//  tableCellView.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 04/07/2023.
//

import Cocoa

// MARK: - Delegate protocol
protocol TabelCellViewDelegate: AnyObject {
    // FIXME: - use correct function names
    // FIXME: - func cellView(_ sender: TableCellView, didEditCell newValue: String)
  func labelEditFinished(newValue: String)
}

// FIXME: - class name should be clear
// FIXME: - delegate usage should be in extionsion
class TableCellView: NSTableCellView, NSTextFieldDelegate {
  
  // MARK: - Public properties
  weak var delegate: TabelCellViewDelegate?
  
  // MARK: - IBOutlets
    // FIXME: - should be private
  @IBOutlet weak var cellViewLabel: NSTextField!

  // MARK: - IBActions
    // FIXME: - actions should be private
    // FIXME: - actions should be after the Public functions mark
  @IBAction func labelValueChanged(_ sender: NSTextField) {
      // FIXME: - should use textField delegate
      // FIXME: - should validate value it's not empty
    delegate?.labelEditFinished(newValue: sender.stringValue)
  }
  
  // MARK: - Public functions
    // FIXME: - not used functions should be removed
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
  }
}

extension TableCellView {
  // MARK: - Instanstiate Method
  static func instanstiate(_ tableView: NSTableView) -> TableCellView? {
      // FIXME: - should use extension to fetch cell ID
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("tableColumn"), owner: nil) as? TableCellView
    return cell
  }
}
