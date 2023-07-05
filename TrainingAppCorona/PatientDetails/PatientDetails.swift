//
//  PatientDetails.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 05/07/2023.
//

import Cocoa
import AppCommonComponents

class PatientDetails: NSView, NibLoadable {
  
  var patientName: String = "" {
    didSet{
      patientNameLabel.stringValue = patientName
    }
  }

  @IBOutlet private weak var patientNameLabel: NSTextField!

  @IBAction func backButtonPressed(_ sender: NSButton) {
    guard let window = self.window else {
      return
    }
    window.close()
  }
  override func awakeFromNib() {
    super.awakeFromNib()
  }
    
}
