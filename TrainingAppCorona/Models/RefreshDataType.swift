//
//  refreshDataType.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 02/07/2023.
//

import Cocoa

enum RefreshDataType: CaseIterable {
  case auto, manual
  
  var description: String {
    switch self {
    case .auto:
      return "Automatic Refresh"
    case .manual:
      return "Manual Refresh"
    }
  }
  
  static func fromDescription(_ description: String) -> RefreshDataType? {
    for caseValue in RefreshDataType.allCases {
      if caseValue.description == description {
        return caseValue
      }
    }
    return nil
  }
  
}
