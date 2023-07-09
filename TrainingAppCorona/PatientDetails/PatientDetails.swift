//
//  PatientDetails.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 05/07/2023.
//

import Cocoa
import AppCommonComponents

class PatientDetails: NSView, NibLoadable {
  
    // FIXME: - better to use a setup function
    // FIXME: - better to send all of the model since the view can be upgraded to display other values
  var patientName: String = "" {
    didSet{
      patientNameLabel.stringValue = patientName
    }
  }
    // FIXME: - should use marks

  @IBOutlet private weak var patientNameLabel: NSTextField!

  @IBAction func backButtonPressed(_ sender: NSButton) {
    guard let window = self.window else {
      return
    }
    window.close()
  }
    
    // FIXME: - not used functions should be removed
  override func awakeFromNib() {
    super.awakeFromNib()
  }
    
}
