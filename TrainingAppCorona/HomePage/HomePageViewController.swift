//
//  ViewController.swift
//  TrainingAppCorona
//
//  Created by Ahmed Ibrahim on 01/07/2023.
//

import Cocoa

class HomePageViewController: NSViewController {
  
  
  // MARK: - Public properties
  var timer: Timer?
  var homePageViewModel = HomePageViewModel()
  var refreshInterval = 5 {
    didSet{
      timer?.invalidate()
      timer = Timer.scheduledTimer(timeInterval: TimeInterval(refreshInterval), target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
    }
  }
  var selectedRow: Int? {
    didSet{
      if selectedRow != nil {
        // Enable Delete button in segement
        segmentControllView.setEnabled(true, forSegment: 1)
        
        // Enable Details button
        detailsButton.isEnabled = true
        
        // Current selected patient
        let selectedPatient = homePageViewModel.patientList[selectedRow!]
        
        // Configure progress stack view data
        recoveryNameLabel.stringValue = "\(selectedPatient.name)'s Recovery Progress"
        progressStack.isHidden = selectedPatient.testResultStatus == .positive ? false : true
        let calendar = Calendar.current
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
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
  }
  
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
        deletePatientFromRow(index: selectedRow)
      }
    }
  }
  
  @IBAction func refreshIntervalChange(_ sender: NSStepper) {
    refreshInterval = Int(sender.stringValue)!
    refreshIntervalTextField.stringValue = String(refreshInterval)
  }
  
  @IBAction func refreshData(_ sender: NSButton) {
    refreshTableData()
  }
  
  @IBAction func refreshDataTypeChange(_ sender: NSPopUpButtonCell) {
    if let type = sender.selectedItem?.title,
       let typeEnum = RefreshDataType.fromDescription(type) {
      switch typeEnum {
      case .auto:
        refreshIntervalView.isHidden = false
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(refreshInterval),
                                     target: self, selector: #selector(timerFired(_:)),
                                     userInfo: nil, repeats:true)
      case .manual:
        refreshIntervalView.isHidden = true
        timer?.invalidate()
      }
    }
  }
  
  @IBAction func DetailsButtonPressed(_ sender: NSButton) {
    var viewControllerDetails = NSViewController()
    var patientDetailsView = PatientDetails.createFromNib()
    viewControllerDetails.view = patientDetailsView
    patientDetailsView.patientName = homePageViewModel.patientList[selectedRow!].name
    self.presentAsSheet(viewControllerDetails)
  }
  
  
  // MARK: - Private functions
  private func getSelectedCheckBoxesEnums() -> [TestType] {
    var selectedEnums: [TestType] = []
    
    for checkBoxView in testTypesStack.arrangedSubviews {
      if let checkbox = checkBoxView as? NSButton, checkbox.state == .on {
        selectedEnums.append(TestType.fromDescription(checkbox.title)!)
      }
    }
    
    return selectedEnums
  }
  
  private func deletePatientFromRow(index: Int?){
    
    guard index != nil else {
      return
    }
    
    homePageViewModel.deletePatient(index: index)
    patientTableView.reloadData()
    
    // Set enabled false after delete
    segmentControllView.setEnabled(false, forSegment: 1)
    detailsButton.isEnabled = false
  }
  
  private func refreshTableData(){
    homePageViewModel.applyFilter(selectedTypes: getSelectedCheckBoxesEnums(),
                                  showNegativeResult: showNegativeResultSwitch.state == .off)
    patientTableView.reloadData()
  }
  
  private func fillRefreshTypePopUp(){
    refreshDataTypeButton.removeAllItems()
    for refreshType in RefreshDataType.allCases {
      refreshDataTypeButton.addItem(withTitle: refreshType.description)
    }
    
    // Set refresh interval data
    refreshIntervalStepper.maxValue = 30
    refreshIntervalStepper.minValue = 0
    refreshIntervalStepper.stringValue = String(refreshInterval)
    refreshIntervalTextField.stringValue = String(refreshInterval)
    refreshIntervalTextField.isEditable = false
  }
  
  private func fillTestTypesFilterCheckBoxes(){
    testTypesStack.subviews.removeAll()
    
    for testType in TestType.allCases {
      let checkBoxButton = NSButton(checkboxWithTitle: testType.description, target: nil, action: nil)
      checkBoxButton.state = .on
      testTypesStack.addView(checkBoxButton, in:  NSStackView.Gravity.bottom)
    }
  }
  
  private func configureProgressStack(){
    progressStack.isHidden = true
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
    return homePageViewModel.patientList.count
  }
}


extension HomePageViewController: NSTableViewDelegate {
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    
    var image: NSImage?
    var text: String = ""
    
    let patient = homePageViewModel.patientList[row]
    
    if tableColumn == tableView.tableColumns[0] {
      image = patient.statusIcon
      text = patient.name
    } else if tableColumn == tableView.tableColumns[1] {
      text = patient.testType.appreviation
    }else if tableColumn == tableView.tableColumns[2] {
      text = patient.testResultStatus.rawValue
    }
    
    
    
    if let cell = TableCellView.instanstiate(tableView) {
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
    selectedRow = row
    return true
  }
  
  // Notification to handel unselection of row
  func tableViewSelectionDidChange(_ notification: Notification) {
    guard let tableView = notification.object as? NSTableView else {
      return
    }
    
    // Get the selected row indexes
    let selectedRowIndexes = tableView.selectedRowIndexes.count
    
    
    // Disable delete button when no row is selected.
    if selectedRowIndexes == 0 {
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
    self.dismiss(sender)
  }
}

extension HomePageViewController: TabelCellViewDelegate {
  func labelEditFinished(newValue: String) {
    if selectedRow != nil {
      homePageViewModel.editPatientName(patientIndex: selectedRow!, newValue: newValue)
    }
  }
}
