//
//  TrainingAppCoronaTests.swift
//  TrainingAppCoronaTests
//
//  Created by Ahmed Ibrahim on 06/07/2023.
//

import XCTest
@testable import TrainingAppCorona

final class TrainingAppCoronaTests: XCTestCase {
  
  var sut: HomePageViewModel!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = HomePageViewModel()
  }
  
  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }

  func testAddPatient() {
    // Given
    let newPatient = Patient(name: "Ahmed", testType: .LFTS, testResultStatus: .positive, testDate: Date())
    
    // When
    sut.addPatient(patient: newPatient)
    
    // Then
    XCTAssertEqual(sut.patientList.count, 1)
  }
  
  func testDeletePatient() {
    // Given
    let newPatient = Patient(name: "Ahmed", testType: .LFTS, testResultStatus: .positive, testDate: Date())
    sut.addPatient(patient: newPatient)

    // When
    sut.deletePatient(index: 0)
    
    // Then
    XCTAssertEqual(sut.patientList.count, 0)
  }
  
  func testEditPatient() {
    // Given
    let newPatient = Patient(name: "Ahmed", testType: .LFTS, testResultStatus: .positive, testDate: Date())
    sut.addPatient(patient: newPatient)

    // When
    let newName = "Ayham"
    sut.editPatientName(patientIndex: 0, newValue: newName)
    
    // Then
    XCTAssertEqual(sut.patientList.first?.name, newName)
  }
  
  func testApplyFilterForShowNegativeResultTrue() {
    
    // Given
    sut.addPatient(patient: Patient(name: "Ahmed", testType: .LFTS, testResultStatus: .positive, testDate: Date()))
    sut.addPatient(patient: Patient(name: "Ayham", testType: .PCR, testResultStatus: .positive, testDate: Date()))
    sut.addPatient(patient: Patient(name: "Mohammad", testType: .serology, testResultStatus: .positive, testDate: Date()))
    sut.addPatient(patient: Patient(name: "Steve", testType: .PCR, testResultStatus: .negative, testDate: Date()))
    sut.addPatient(patient: Patient(name: "Yaseen", testType: .LFTS, testResultStatus: .negative, testDate: Date()))
    
    // When
    sut.applyFilter(selectedTypes: TestType.allCases, showNegativeResult: true)
    
    // Then
    XCTAssertEqual(sut.patientList.count, 5)
  }
  
  func testApplyFilterForShowNegativeResultFalse() {
    
    // Given
    sut.addPatient(patient: Patient(name: "Ahmed", testType: .LFTS, testResultStatus: .positive, testDate: Date()))
    sut.addPatient(patient: Patient(name: "Ayham", testType: .PCR, testResultStatus: .positive, testDate: Date()))
    sut.addPatient(patient: Patient(name: "Mohammad", testType: .serology, testResultStatus: .positive, testDate: Date()))
    sut.addPatient(patient: Patient(name: "Steve", testType: .PCR, testResultStatus: .negative, testDate: Date()))
    sut.addPatient(patient: Patient(name: "Yaseen", testType: .LFTS, testResultStatus: .negative, testDate: Date()))
    
    // When
    sut.applyFilter(selectedTypes: TestType.allCases, showNegativeResult: false)
    
    // Then
    XCTAssertEqual(sut.patientList.count, 3)
  }
  
  func testApplyFilterForSelectedTestTypes() {
    
    // Given
    sut.addPatient(patient: Patient(name: "Ahmed", testType: .LFTS, testResultStatus: .positive, testDate: Date()))
    sut.addPatient(patient: Patient(name: "Ayham", testType: .PCR, testResultStatus: .positive, testDate: Date()))
    sut.addPatient(patient: Patient(name: "Mohammad", testType: .serology, testResultStatus: .positive, testDate: Date()))
    sut.addPatient(patient: Patient(name: "Steve", testType: .PCR, testResultStatus: .negative, testDate: Date()))
    sut.addPatient(patient: Patient(name: "Yaseen", testType: .LFTS, testResultStatus: .negative, testDate: Date()))
    
    // When
    sut.applyFilter(selectedTypes: [.LFTS, .PCR], showNegativeResult: true)
    
    // Then
    XCTAssertEqual(sut.patientList.count, 4)
  }
}
