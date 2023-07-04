//
//  addPatientViewController.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 03/07/2023.
//

import Cocoa

protocol AddPatientViewControllerDelegate: AnyObject {
  func savePatientClicked(_ sender: AddPatientViewController, patient: Patient)
}

class AddPatientViewController: NSViewController {
  
  
  // MARK: - Public properties
  var testTypesButtons: [NSButton] = []
  var testResultButtons: [NSButton] = []
  weak var delegate: AddPatientViewControllerDelegate?

  // MARK: - IBOutlets
  @IBOutlet weak var patientNameTextField: NSTextField!
  @IBOutlet weak var testTypesStackView: NSStackView!
  @IBOutlet weak var testResultTypesStackView: NSStackView!
  
  // MARK: - Private properties
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    //self.view.isre
    // Fill Test types radio buttons
    testTypesStackView.subviews.removeAll()
    for testType in TestType.allCases {
      let radioButton = NSButton(radioButtonWithTitle: testType.description, target: nil, action: #selector(testTypesButtonPressed(_:)))
      radioButton.state = .off
      testTypesButtons.append(radioButton)
      testTypesStackView.addView(radioButton, in:  NSStackView.Gravity.bottom)
    }
    patientNameTextField.layer?.borderColor = NSColor.red.cgColor

    
    testResultTypesStackView.subviews.removeAll()
    
    // Fill test result radio buttons
    for testResult in TestResultStatus.allCases {
      let radioButton = NSButton(radioButtonWithTitle: testResult.rawValue, target: self, action: #selector(testResultButtonClicked(_:)))
      radioButton.state = .off
      testResultButtons.append(radioButton)
      testResultTypesStackView.addView(radioButton, in:  NSStackView.Gravity.bottom)
    }
    
  }
  
  
  // MARK: - IBActions
  @IBAction func saveButtonPressed(_ sender: NSButton) {
    
    guard let testResult = getSelectedTestResult(), let testType = getSelectedTestType(), !patientNameTextField.stringValue.isEmpty else {
      return
    }
    
    let patient = Patient(name: patientNameTextField.stringValue, testType: testType, testResultStatus: testResult, testDate: Date.now)
    
    delegate?.savePatientClicked(self, patient: patient)
  }
  
  @IBAction func closeButtonPressed(_ sender: NSButton) {
    guard let window = view.window else {
      return
    }
    window.close()
  }
  
  // MARK: - Public functions
  @objc func testTypesButtonPressed(_ sender: NSButton) {
  }
  
  @objc func testResultButtonClicked(_ sender: NSButton) {
  }
  
  // MARK: - Private functions
  private func getSelectedTestType() -> TestType? {
    for button in testTypesButtons {
      if button.state == .on {
        return TestType.fromDescription(button.title)
      }
    }
    return nil
  }
  
  private func getSelectedTestResult() -> TestResultStatus? {
    for button in testResultButtons {
      if button.state == .on {
        return TestResultStatus(rawValue: button.title)
      }
    }
    return nil
  }
}

// MARK: Instansiate method
extension AddPatientViewController {
  static func instanstiate() -> AddPatientViewController {
    let storyboard = NSStoryboard(name: "AddPatientView", bundle: .main)
    let viewController = storyboard.instantiateController(withIdentifier: "addPatientId") as! AddPatientViewController
    return viewController
  }
}
