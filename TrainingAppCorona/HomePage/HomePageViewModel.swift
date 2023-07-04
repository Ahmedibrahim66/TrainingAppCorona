//
//  HomePageViewModel.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 03/07/2023.
//

import Foundation

class HomePageViewModel {
  
  // MARK: - Public properties
  var patientList: [Patient] = []
  
  // MARK: - Private properties
  private var originalPatientList: [Patient] = []
  
  // MARK: - Public functions
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
  
  func addPatient(patient: Patient){
    originalPatientList.append(patient)
  }
  
  func editPatientName(patientIndex: Int, newValue: String){
    if let originalIndex = originalPatientList.firstIndex(where: {(value) -> Bool in
      return value == patientList[patientIndex]}){
      originalPatientList[originalIndex].name = newValue
    }
  }
  
  func deletePatient(index: Int?){
    if let originalIndex = originalPatientList.firstIndex(where: { (value) -> Bool in
      return value.name == patientList[index!].name
    }) {
      originalPatientList.remove(at: originalIndex)
    }
    patientList.remove(at: index!)
  }
  
  func applyFilter(selectedTypes: [TestType], showNegativeResult: Bool) {
    
    patientList = originalPatientList.filter { patient in
      selectedTypes.contains(patient.testType)
    }
    
    if  showNegativeResult {
      patientList = patientList.filter { patient in
        patient.testResultStatus == .positive
      }
    }
  }
  
}
