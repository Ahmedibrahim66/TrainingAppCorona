//
//  Patient.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 02/07/2023.
//

import Cocoa

class Patient: NSObject {
  
  var name: String
  var testType: TestType
  var testResultStatus: TestResultStatus
  var testDate: Date
  var statusIcon: NSImage {
    if self.testResultStatus == TestResultStatus.positive {
      return NSImage(systemSymbolName: "square.and.arrow.up.circle.fill", accessibilityDescription: nil)!
    }else {
      return NSImage(systemSymbolName: "cross.fill", accessibilityDescription: nil)!
    }
  }
  
  
  init(name: String, testType: TestType, testResultStatus: TestResultStatus, testDate: Date) {
    self.name = name
    self.testType = testType
    self.testResultStatus = testResultStatus
    self.testDate = testDate
  }
  
  
}
