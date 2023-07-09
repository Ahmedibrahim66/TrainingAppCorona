//
//  TestStatus.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 02/07/2023.
//

import Cocoa

enum TestResultStatus: String {
  case negative = "Negative"
  case positive = "Positive"
}

extension TestResultStatus: CaseIterable {
    // FIXME: - if it's empty do it as extension yyyy : xxx {}
}
