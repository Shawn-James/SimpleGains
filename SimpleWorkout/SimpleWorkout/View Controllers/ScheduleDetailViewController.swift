// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// ScheduleDetailViewController.swift

import CoreData
import UIKit

final class ScheduleDetailViewController: CustomViewController, UITableViewDataSource, UITableViewDelegate, AutoCompleteTableViewMyDelegate, NSFetchedResultsControllerDelegate {
    typealias AutoCompleteData = UITableViewDiffableDataSource<Int, Exercise>
    typealias AutoCompleteSnapshot = NSDiffableDataSourceSnapshot<Int, Exercise>

    // MARK: - Public Properties

    var weekday: Weekday? {
        didSet {
            title = weekday?.name
        }
    }

    var exerciseModel: ExerciseModel? {
        didSet {
            exerciseFRC = exerciseModel?.fetchedResultsController
        }
    }

    // MARK: - Private Properties

    @IBOutlet private var sortButton: UIBarButtonItem!

    @IBOutlet private var autoCompleteTextField: AutoCompleteTextField!

    @IBOutlet private var autoCompleteTableView: AutoCompleteTableView!

    @IBOutlet private var scheduledExercisesTableView: CustomTableView!

    @IBOutlet private var emptyDatasetView: UIView!

    private var exerciseFRC: NSFetchedResultsController<Exercise>? {
        didSet {
            exerciseFRC?.delegate = self
        }
    }

    private var autoCompleteModel = ExercisePermanentRecordModel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        autoCompleteTextField.delegate = autoCompleteTableView
        scheduledExercisesTableView.dataSource = self
        scheduledExercisesTableView.delegate = self
        autoCompleteTableView.myDelegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = exerciseFRC?.fetchedObjects?.count ?? 0
        configurationForEmptyDataSet(numberOfRowsInSection)
        return numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScheduleDetailCell = tableView.dequeueReusableCell(for: indexPath)
        cell.exercise = exerciseFRC?.object(at: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard
            sourceIndexPath != destinationIndexPath, // Verify something was moved
            let sourceObjectID = exerciseFRC?.object(at: sourceIndexPath).objectID,
            let privateMovedObject = CoreDataManager.shared.privateContext.object(with: sourceObjectID) as? Exercise,
            let exercises = exerciseFRC?.fetchedObjects // Why does this have zero values??
        else { return }

        // Map to private
        var privateExercises = exercises.map {
            CoreDataManager.shared.privateContext.object(with: $0.objectID) as? Exercise
        }

        // Perform move
        privateExercises.remove(at: sourceIndexPath.row)
        privateExercises.insert(privateMovedObject, at: destinationIndexPath.row)

        // Update order
        var row: Int16 = 0
        privateExercises.forEach {
            $0?.order = row
            row += 1
        }

        CoreDataManager.shared.savePrivateChanges()
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reset = UIContextualAction(style: .normal, title: "Reset") { _, _, completion in
            let cell = tableView.cellForRow(at: indexPath) as? ScheduleDetailCell
            cell?.resetButtonValues()

            completion(true)
        }

        reset.image = UIImage(systemName: "gobackward")

        return UISwipeActionsConfiguration(actions: [reset])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, completion in
            guard
                let exerciseFRC = self?.exerciseFRC,
                var exercises = exerciseFRC.fetchedObjects
            else { completion(false); return } // FIXME: - completion false??

            let group = DispatchGroup()
            group.enter()

            // Delete object
            CoreDataManager.shared.viewContext.delete(exerciseFRC.object(at: indexPath))
            exercises.remove(at: indexPath.row)

            // 1st action
            DispatchQueue.main.async {
                // Map to private
                let privateExercises = exercises.map {
                    CoreDataManager.shared.privateContext.object(with: $0.objectID) as? Exercise
                }

                // Update order
                var row: Int16 = 0
                privateExercises.forEach {
                    $0?.order = row
                    row += 1
                }

                CoreDataManager.shared.savePrivateChanges()

                group.leave()
            }

            // 2nd action
            group.notify(queue: .main) {
                CoreDataManager.shared.saveViewChanges()
                CoreDataManager.shared.savePrivateChanges()
            }

            completion(true)
        }
        delete.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [delete])
    }

    // MARK: - AutoCompleteTableView MyDelegate

    /// Auto-fills the textField with the given text
    /// - Parameter autoFill: The text used to replace the UITextfield's text
    func replaceTextFieldText(with autoFill: String) {
        autoCompleteTextField.endEditing(true)
        autoCompleteTextField.text = autoFill

        autoCompleteTableView.hideDropDown()
    }

    // MARK: - FetchedResultsController Delegate Methods

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        scheduledExercisesTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                scheduledExercisesTableView.insertRows(at: [newIndexPath], with: .top)
            }
        case .update:
            if let indexPath = indexPath {
                scheduledExercisesTableView.reloadRows(at: [indexPath], with: .none)
            }
        case .move:
            if let oldIndexPath = indexPath, let newIndexPath = newIndexPath {
                scheduledExercisesTableView.deleteRows(at: [oldIndexPath], with: .none)
                scheduledExercisesTableView.insertRows(at: [newIndexPath], with: .none)
            }
        case .delete:
            if let indexPath = indexPath {
                scheduledExercisesTableView.deleteRows(at: [indexPath], with: .automatic)
            }
                @unknown default: break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        scheduledExercisesTableView.endUpdates()
    }

    // MARK: - Private Methods

    @IBAction private func sortButtonPressed(_ sender: UIBarButtonItem) {
        scheduledExercisesTableView.isEditing.toggle()
    }

    /// Adds exercises to the tableView and updates their occurrence count for auto-complete sorting purposes
    /// - Parameter sender: The add button itself
    @IBAction private func addButtonPressed(_ sender: StandardButton) {
        guard
            let exerciseName = autoCompleteTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !exerciseName.isEmpty,
            let weekday = weekday
        else { return }

        autoCompleteTextField.text?.removeAll(keepingCapacity: false)

        autoCompleteModel.incrementAutoCompleteOccurrenceCount(for: exerciseName)

        exerciseModel?.createNewExercise(named: exerciseName, for: weekday)
    }

    /// Configures the tableView's appearance based on whether or not it is empty.
    private func configurationForEmptyDataSet(_ numberOfRowsInSection: Int) {
        if numberOfRowsInSection == 0 {
            scheduledExercisesTableView.backgroundView = emptyDatasetView
        } else if numberOfRowsInSection == 1 {
            scheduledExercisesTableView.backgroundView = nil
        }
    }
}
