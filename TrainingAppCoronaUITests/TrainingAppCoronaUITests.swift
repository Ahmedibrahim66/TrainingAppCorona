//
//  TrainingAppCoronaUITests.swift
//  TrainingAppCoronaUITests
//
//  Created by Ahmed Ibrahim on 06/07/2023.
//

import XCTest

final class TrainingAppCoronaUITests: XCTestCase {
  var app: XCUIApplication!
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launch()
  }
  
  func testExample() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()
  }
  
  func testAddPatientIsAddedToList() {
        
    var covidPatientAhmedIbrahimWindow = XCUIApplication().windows["Covid Patient – Ahmed Ibrahim"]

    // Initial Data
    var patientTable = covidPatientAhmedIbrahimWindow.tables.firstMatch
    let tableRowCountBefore = patientTable.tableRows.count
    
    // Add Patient
    covidPatientAhmedIbrahimWindow/*@START_MENU_TOKEN@*/.buttons["add"]/*[[".groups.buttons[\"add\"]",".buttons[\"add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
    let sheetsQuery = covidPatientAhmedIbrahimWindow.sheets
    sheetsQuery.children(matching: .textField).element.click()
    let table = XCUIApplication().windows["Covid Patient – Ahmed Ibrahim"]/*@START_MENU_TOKEN@*/.scrollViews.tables/*[[".scrollViews.tables",".tables"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
    let tablesQuery = covidPatientAhmedIbrahimWindow/*@START_MENU_TOKEN@*/.tables/*[[".scrollViews.tables",".tables"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    let cell = tablesQuery.children(matching: .tableRow).element(boundBy: 0).children(matching: .cell).element(boundBy: 0)
    cell.typeText("tes")
    cell.typeText("ting123")
    sheetsQuery.radioButtons["Lateral flow test (LFTs)"].click()
    sheetsQuery.radioButtons["Negative"].click()
    sheetsQuery.buttons["Save"].click()
    
    // Assert Data
    let tableColumnsCount = patientTable.tableColumns.count
    let tableRowCountAfter = patientTable.tableRows.count
    let test = patientTable.tableRows.count
    XCTAssertEqual(tableRowCountBefore+1, tableRowCountAfter, "Row was not added to the table")
  }
  
}
