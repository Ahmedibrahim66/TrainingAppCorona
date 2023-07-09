//
//  HomePageViewModel.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 03/07/2023.
//

import Foundation

// FIXME: - should be a struct

class HomePageViewModel {
  
  // MARK: - Public properties
    // FIXME: - should have a centeral class to general and store data not in an indivual VM
  var patientList: [Patient] = []
  
  // MARK: - Private properties
  private var originalPatientList: [Patient] = []
  
  // MARK: - Public functions
    // FIXME: - should be move to a helper class since this code is just for testing and will not be in fully functional app
    // FIXME: - app should be private in this context and called from init
  func createInitialPatient() {
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.year = 2023
    dateComponents.month = 6
    dateComponents.day = 25
    originalPatientList.append(Patient(name: "Ramu", testType: .LFTS, testResultStatus: .negative, testDate: calendar.date(from: dateComponents)!))
    originalPatientList.append(Patient(name: "Steve", testType: .serology, testResultStatus: .positive, testDate: calendar.date(from: dateComponents)!))
    dateComponents.month = 7
    dateComponents.day = 1
    originalPatientList.append(Patient(name: "Yaseen", testType: .PCR, testResultStatus: .positive, testDate: calendar.date(from: dateComponents)!))
    originalPatientList.append(Patient(name: "Ahmed", testType: .serology, testResultStatus: .negative, testDate: calendar.date(from: dateComponents)!))
    dateComponents.day = 3
    originalPatientList.append(Patient(name: "Mohammad", testType: .serology,  testResultStatus: .positive, testDate: calendar.date(from: dateComponents)!))
    originalPatientList.append(Patient(name: "Ayham", testType: .LFTS, testResultStatus: .negative, testDate: calendar.date(from: dateComponents)!))
    patientList = originalPatientList
  }
  
  func addPatient(patient: Patient) {
    originalPatientList.append(patient)
    patientList.append(patient)
  }
  
  func editPatientName(patientIndex: Int, newValue: String) {
      // FIXME: - can use first better
      // FIXME: - should use guard its cleaner
      // FIXME: - use implicit variable "$0"
    if let originalIndex = originalPatientList.firstIndex(where: {(value) -> Bool in
      return value == patientList[patientIndex]}) {
        // FIXME: - this sync here is working becuase it's a class not a model
      originalPatientList[originalIndex].name = newValue
    }
  }
  
  func deletePatient(index: Int?) {
      // FIXME: - should validate index and make sure it's withen range
      // FIXME: - better to use guard
      // FIXME: - use "$0" as its cleaner
    if let originalIndex = originalPatientList.firstIndex(where: { (value) -> Bool in
      return value.name == patientList[index!].name
    }) {
      originalPatientList.remove(at: originalIndex)
    }
      // FIXME: - never force unwrap
    patientList.remove(at: index!)
  }
  
  func applyFilter(selectedTypes: [TestType], showNegativeResult: Bool) {
    
      // FIXME: - should use one loop to enhance performance
    patientList = originalPatientList.filter { patient in
      selectedTypes.contains(patient.testType)
    }
    
    if  !showNegativeResult {
      patientList = patientList.filter { patient in
        patient.testResultStatus == .positive
      }
    }
  }
  
}
