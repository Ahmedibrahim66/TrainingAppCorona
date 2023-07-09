//
//  refreshDataType.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 02/07/2023.
//

import Cocoa

enum RefreshDataType: CaseIterable {
    // FIXME: - should be a new line for each case
  case auto, manual
  
  var description: String {
    switch self {
    case .auto:
      return "Automatic Refresh"
    case .manual:
      return "Manual Refresh"
    }
  }
  
    // FIXME: - should create from init check other comments in viewController for other details
  static func fromDescription(_ description: String) -> RefreshDataType? {
    for caseValue in RefreshDataType.allCases {
      if caseValue.description == description {
        return caseValue
      }
    }
    return nil
  }
  
}
