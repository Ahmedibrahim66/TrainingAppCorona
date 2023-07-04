//
//  TestType.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 02/07/2023.
//

import Cocoa

enum TestType: CaseIterable {
  
  case serology
  case LFTS
  case PCR
  
  var description: String {
    switch self {
    case .serology:
      return "Anitbody (serology)"
    case .LFTS:
      return "Lateral flow test (LFTs)"
    case .PCR:
      return "Polumerase chain reaction (PCR)"
    }
  }
  
  var appreviation: String {
    switch self {
    case .serology:
      return "serology"
    case .LFTS:
      return "LFTs"
    case .PCR:
      return "PCR"
    }
  }
  
  static func fromDescription(_ description: String) -> TestType? {
    for caseValue in TestType.allCases {
      if caseValue.description == description {
        return caseValue
      }
    }
    return nil
  }
  
}
