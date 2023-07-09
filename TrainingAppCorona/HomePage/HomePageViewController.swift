//
//  ViewController.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 01/07/2023.
//

import Cocoa

// FIXME: - Fix all linter warning
// FIXME: - should fix spacing by doing contorl + I

class HomePageViewController: NSViewController {
  
    // FIXME: make sure to do correct padding
  
  // MARK: - Public properties
    // FIXME: by default every property should be private, unless it's explicitly needed to public, also can use private(set)
  var timer: Timer?
  var homePageViewModel = HomePageViewModel()
    
  var refreshInterval = 5 {
    didSet {
        // FIXME: - should be moved into it's own function and call the function from here
      timer?.invalidate()
      timer = Timer.scheduledTimer(timeInterval: TimeInterval(refreshInterval), target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
    }
  }
  var selectedRow: Int? {
    didSet {
        // FIXME: - long logic should be moved to its own functions
      if selectedRow != nil {
          // FIXME: - should create a function to Enable/Disable views
        // Enable Delete button in segement
        segmentControllView.setEnabled(true, forSegment: 1)
        
        // Enable Details button
        detailsButton.isEnabled = true
        
        // Current selected patient
        // FIXME: - !!!!!NEVER!!!!! use force unwrap
          // FIXME: - always validate using a guard or an iflet
        let selectedPatient = homePageViewModel.patientList[selectedRow!]
        
        // Configure progress stack view data
        recoveryNameLabel.stringValue = "\(selectedPatient.name)'s Recovery Progress"
        progressStack.isHidden = selectedPatient.testResultStatus == .positive ? false : true
          // FIXME: -  create function to that takes date and returns a formated string
          // FIXME: - better for code seperation and maintability
          // FIXME: - can also be put an extension of Calender to be used by anyone in the future
        let calendar = Calendar.current
          // FIXME: - should use the selectedPatient variable and re read the item from the array
        let dateComponents = calendar.dateComponents([.day], from: homePageViewModel.patientList[selectedRow!].testDate, to: Date())
        let daysElapsed = dateComponents.day ?? 0
        progresBarView.doubleValue = min(Double(daysElapsed), 14)
      }
    }
  }
  
  // MARK: - IBOutlets
  @IBOutlet private weak var refreshDataTypeButton: NSPopUpButton!
  @IBOutlet private weak var refreshIntervalView: NSStackView!
  @IBOutlet private weak var refreshIntervalStepper: NSStepper!
  @IBOutlet private weak var refreshIntervalTextField: NSTextField!
  @IBOutlet private weak var testTypesStack: NSStackView!
    // FIXME: - should use name tableView, since there is one table
  @IBOutlet private weak var patientTableView: NSTableView!
  @IBOutlet private weak var showNegativeResultSwitch: NSSwitch!
  @IBOutlet private weak var segmentControllView: NSSegmentedControl!
  @IBOutlet private weak var progressStack: NSStackView!
  @IBOutlet private weak var recoveryNameLabel: NSTextField!
  @IBOutlet private weak var progresBarView: NSProgressIndicator!
  @IBOutlet private weak var detailsButton: NSButton!
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
      // FIXME: - comments should not be on every line
      // FIXME: - code should expreess itSelf throw clear flow and function naming
      // FIXME: - what can be done here is use seperate functions for setup of each component and then one general function that calls each subFunction
    // Add items in refresh data pop up.
    fillRefreshTypePopUp()
    // Fill Test Types filter
    fillTestTypesFilterCheckBoxes()
    // set Switch default state
    showNegativeResultSwitch.state = .on
    // Create Initial Patients
    homePageViewModel.createInitialPatient()
    // Disable Delete button as no row is selected
    segmentControllView.setEnabled(false, forSegment: 1)
    // Assign delegate to tableview
    patientTableView.delegate = self
    // Configure progress Stack
    configureProgressStack()
    // Configure the automatic refresh timer
    configureAutomaticRefresh()
    // Disable Details Button
    detailsButton.isEnabled = false
      
      // FIXME: -
  }
  
    // FIXME: - unused functions should be removed
  override func viewDidAppear() {
    super.viewDidAppear()
  }
  
    // FIXME: - this is needed, but should it be on each dissappear or maybe each time when the viewController is gone
  override func viewWillDisappear() {
    super.viewWillDisappear()
    // Do we need this since it is one page ?
    timer?.invalidate()
  }
  
  // MARK: - IBActions
  @IBAction func segmentedControlAction(_ sender: NSSegmentedControl) {
    if sender.indexOfSelectedItem == 0 {
      let addPatientViewController = AddPatientViewController.instanstiate()
      addPatientViewController.delegate = self
      self.presentAsSheet(addPatientViewController)
    } else {
      let deleteAlertResponse = runCustomAlert()
      if deleteAlertResponse == .alertFirstButtonReturn {
          // FIXME: - should validate selectedRow
        deletePatientFromRow(index: selectedRow)
      }
    }
  }
  
  @IBAction func refreshIntervalChange(_ sender: NSStepper) {
      // FIXME: - never use force unwrap
    refreshInterval = Int(sender.stringValue)!
    refreshIntervalTextField.stringValue = String(refreshInterval)
  }
  
  @IBAction func refreshData(_ sender: NSButton) {
      // FIXME: - why is not in the refresh table logic, should it be here or somewhere else?
    homePageViewModel.applyFilter(selectedTypes: getSelectedCheckBoxesEnums(), showNegativeResult: showNegativeResultSwitch.state == .on)
    refreshTableData()
  }
  
  @IBAction func refreshDataTypeChange(_ sender: NSPopUpButtonCell) {
    if let type = sender.selectedItem?.title,
       // FIXME: - that's not how we create an enum from string
       // FIXME: - 1. you can have the enum have a rawValue --> String or Int or what ever
        // FIXME: - 2. you can create custom init function
        // FIXME: - 3. you can use the Tag value in NSContol to send the rawValue of the actual type
        // FIXME: - 4. you can use the ObjectValue in NSControl to send the actual type
       let typeEnum = RefreshDataType.fromDescription(type) {
      switch typeEnum {
      case .auto:
        refreshIntervalView.isHidden = false
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(refreshInterval),
                                     target: self, selector: #selector(timerFired(_:)),
                                     userInfo: nil, repeats: true)
      case .manual:
        refreshIntervalView.isHidden = true
        timer?.invalidate()
      }
    }
  }
  
  @IBAction func detailsButtonPressed(_ sender: NSButton) {
      // FIXME: - action not working as it was not connected in storyBoard, how did you test this?
    let viewControllerDetails = NSViewController()
    let patientDetailsView = PatientDetails.createFromNib()
    viewControllerDetails.view = patientDetailsView
      // FIXME: - Need to validate selectedRow
      // FIXME: - need to validate the items in the viewModel exists or you'll get a crash
      // FIXME: - NEVER force unwrap
    patientDetailsView.patientName = homePageViewModel.patientList[selectedRow!].name
    self.presentAsSheet(viewControllerDetails)
  }
  
  // MARK: - Private functions
  private func getSelectedCheckBoxesEnums() -> [TestType] {
    var selectedEnums: [TestType] = []
    
    for checkBoxView in testTypesStack.arrangedSubviews {
      if let checkbox = checkBoxView as? NSButton, checkbox.state == .on {
          // FIXME: - Check comments above line on refresh data same idea
        selectedEnums.append(TestType.fromDescription(checkbox.title)!)
      }
    }
    
    return selectedEnums
  }
  
  private func deletePatientFromRow(index: Int?) {
      // FIXME: - should valid it's when the table range of rows, 0..<tableView.numberOfRows
    guard index != nil else {
      return
    }
    
      // FIXME: - always use ids to communicate with viewModel as it's more correct and can be synced always right, think of in a bigger picture when there is multi items modify the data in something like a manager
    homePageViewModel.deletePatient(index: index)
      // FIXME: - why not call the relaod function
    patientTableView.reloadData()
    
    // Set enabled false after delete
    // FIXME: - should be a centralized place to Enable/Disable items
    segmentControllView.setEnabled(false, forSegment: 1)
    detailsButton.isEnabled = false
  }
  
  private func refreshTableData() {
    patientTableView.reloadData()
  }
  
  private func fillRefreshTypePopUp() {
    refreshDataTypeButton.removeAllItems()
    for refreshType in RefreshDataType.allCases {
      refreshDataTypeButton.addItem(withTitle: refreshType.description)
    }
    
    // Set refresh interval data
    refreshIntervalStepper.maxValue = 30
      // FIXME: - can you selected a stepper value of 0 it doesn't make senese
    refreshIntervalStepper.minValue = 0
    refreshIntervalStepper.stringValue = String(refreshInterval)
    refreshIntervalTextField.stringValue = String(refreshInterval)
    refreshIntervalTextField.isEditable = false
  }
  
  private func fillTestTypesFilterCheckBoxes(){
    testTypesStack.subviews.removeAll()
      // FIXME: - this will create problems, use testTypesStack.arrangedSuvViews.forEach({ $0.removeFromSuperView() })
    
    for testType in TestType.allCases {
      let checkBoxButton = NSButton(checkboxWithTitle: testType.description, target: nil, action: nil)
      checkBoxButton.state = .on
        // FIXME: - when dealing with stack it's better to deal with arranged subViews
      testTypesStack.addView(checkBoxButton, in:  NSStackView.Gravity.bottom)
    }
  }
  
  private func configureProgressStack(){
    progressStack.isHidden = true
      // FIXME: - move values to config
    progresBarView.maxValue = 14
    progresBarView.minValue = 0
  }
  
  private func configureAutomaticRefresh(){
    timer = Timer.scheduledTimer(timeInterval: TimeInterval(refreshInterval), target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
  }
  
  @objc private func timerFired(_ timer: Timer) {
    // This method will be called every time the timer fires
    refreshTableData()
  }
  
  private func runCustomAlert() -> NSApplication.ModalResponse {
    let alert = NSAlert()
      // FIXME: - should validate selected row
    alert.messageText = "Are you sure you want to delete patient \(homePageViewModel.patientList[selectedRow!].name)"
    alert.informativeText = "This can't be undone"
    alert.alertStyle = .warning
    alert.addButton(withTitle: "Delete").bezelColor = .red
    alert.addButton(withTitle: "Cancel")
    return alert.runModal()
  }
}


extension HomePageViewController: NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
      // FIXME: - should use a computed variable
    return homePageViewModel.patientList.count
  }
}


extension HomePageViewController: NSTableViewDelegate {
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
      // FIXME: - should first create cell before preparing data
    var image: NSImage?
    var text: String = ""
    
    let patient = homePageViewModel.patientList[row]
    
      // FIXME: - should use table identifier to match, try to reoder columns and this code will fail
    if tableColumn == tableView.tableColumns[0] {
      image = patient.statusIcon
      text = patient.name
    } else if tableColumn == tableView.tableColumns[1] {
      text = patient.testType.appreviation
    }else if tableColumn == tableView.tableColumns[2] {
      text = patient.testResultStatus.rawValue
    }
    
    
      // FIXME: - cell creation should be here no in cell
    if let cell = TableCellView.instanstiate(tableView) {
        // FIXME: - should set delegate for editable cells
        // FIXME: - should use column IDs
        // FIXME: - might be better to have two cell types, one that can be edited and one that can't since the other values can't be changed and will create a distenct differnce
      cell.delegate = self
      if tableColumn == tableView.tableColumns[0] {
        cell.textField?.isEditable = true
      }
      cell.textField?.stringValue = text
      cell.imageView?.image = image
      return cell
    }
    
    return nil
  }
  
  func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
      // FIXME: - call function in didset dircrtly no need to set it in a variable
      // FIXME: - 1. this simplifices solution by always reading the info from table.selectedRow
      // FIXME: - 2. this makes it to have 1 single source of truth and will eliminate any sync errors between local variable and actual table value
      // FIXME: - 3. should use the correct delegate for the correct purpose, this one here is to make sure if the row is allowed to be selected or not,
      // FIXME: - it's not meant to return the same value should use the function below
    selectedRow = row
    return true
  }
  
  // Notification to handel unselection of row
  func tableViewSelectionDidChange(_ notification: Notification) {
    guard let tableView = notification.object as? NSTableView else {
      return
    }
    
    // Get the selected row indexes
    // FIXME: - this value is used if there is multiple rows selected, should disable that option and only use table.selectedRow
    let selectedRowIndexes = tableView.selectedRowIndexes.count
    
    
    // Disable delete button when no row is selected.
    // FIXME: - with the new variable should check if there is selected row, read doc to see what will the value return
    if selectedRowIndexes == 0 {
        // FIXME: - should create function that takes a bool to Enable/Disable Views and setups the correct values
      segmentControllView.setEnabled(false, forSegment: 1)
      recoveryNameLabel.stringValue = ""
      progressStack.isHidden = true
      detailsButton.isEnabled = false
    }
  }
}


extension HomePageViewController: AddPatientViewControllerDelegate {
  func savePatientClicked(_ sender: AddPatientViewController, patient: Patient) {
    homePageViewModel.addPatient(patient: patient)
    refreshTableData()
      // FIXME: - try to make the presented view dismiss itself
    self.dismiss(sender)
  }
}

extension HomePageViewController: TabelCellViewDelegate {
  func labelEditFinished(newValue: String) {
    if selectedRow != nil {
        // FIXME: - shoudl use guard, and not force unwrap
      homePageViewModel.editPatientName(patientIndex: selectedRow!, newValue: newValue)
    }
  }
}
