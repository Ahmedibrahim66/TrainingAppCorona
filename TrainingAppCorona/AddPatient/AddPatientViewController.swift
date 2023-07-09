//
//  addPatientViewController.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 03/07/2023.
//

import Cocoa

protocol AddPatientViewControllerDelegate: AnyObject {
    // FIXME: - should use better name func addPatientViewController(_ sender: AddPatientViewController, didCreatePatient patient: Patient)
  func savePatientClicked(_ sender: AddPatientViewController, patient: Patient)
}

class AddPatientViewController: NSViewController {
  
  
  // MARK: - Public properties
    
    // FIXME: - no need to save buttos can be read from stack directly stack.arrangedSubViews
    // FIXME: - should be private
  var testTypesButtons: [NSButton] = []
  var testResultButtons: [NSButton] = []
  weak var delegate: AddPatientViewControllerDelegate?

  // MARK: - IBOutlets
    // FIXME: - should be private
  @IBOutlet weak var patientNameTextField: NSTextField!
  @IBOutlet weak var testTypesStackView: NSStackView!
  @IBOutlet weak var testResultTypesStackView: NSStackView!
  
    // FIXME: - if its empty no need for it
  // MARK: - Private properties
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
      // FIXME: - make sure to write correct comments
    //self.view.isre
    // FIXME: - use a seperate function to setup buttons
      // FIXME: - better to use stack.arrangedSubView.forEach({ $0.removeFromSuperView() })
    // Fill Test types radio buttons
    testTypesStackView.subviews.removeAll()
    for testType in TestType.allCases {
      let radioButton = NSButton(radioButtonWithTitle: testType.description, target: nil, action: #selector(testTypesButtonPressed(_:)))
      radioButton.state = .off
      testTypesButtons.append(radioButton)
        // FIXME: - better use addArrangedSubViews
      testTypesStackView.addView(radioButton, in:  NSStackView.Gravity.bottom)
    }
    patientNameTextField.layer?.borderColor = NSColor.red.cgColor

    
    testResultTypesStackView.subviews.removeAll()
    
    // Fill test result radio buttons
    for testResult in TestResultStatus.allCases {
        // FIXME: - can create function to create the button and be used here and above by sending name and selector
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
      // FIXME: 1. Linter was not working
      // 2. fixed to allowed to work
      // 3. not allowed to force cast
      guard let viewController = storyboard.instantiateController(withIdentifier: "addPatientId") as? AddPatientViewController else {
          return AddPatientViewController()
      }
    return viewController
  }
}
