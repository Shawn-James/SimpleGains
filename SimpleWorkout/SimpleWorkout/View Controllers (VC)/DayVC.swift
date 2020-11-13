// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// DayVC.swift

import CoreData
import UIKit

final class DayVC: SWViewController {
    // MARK: - Typealias

    typealias AutoCompleteData = UITableViewDiffableDataSource<Int, Exercise>
    typealias AutoCompleteSnapshot = NSDiffableDataSourceSnapshot<Int, Exercise>

    typealias ACOFetchRequest = NSFetchRequest<AutoCompleteOption>

    // MARK: - Models

    private var autoCompleteMC = AutoCompleteMC()

    // MARK: - Dependencies

    var weekday: Weekday?
    var controller: ExerciseMC? {
        didSet {
            if let fetchedResultsController = controller?.fetchedResultsController {
                exerciseFRC = fetchedResultsController
            }
        }
    }

    var exerciseFRC: NSFetchedResultsController<Exercise>? {
        didSet {
            if let exerciseFRC = exerciseFRC {
                exerciseFRC.delegate = self
            }
        }
    }

    // MARK: - Properties

    @IBOutlet var reOrderButton: UIBarButtonItem!

    @IBOutlet private var autoCompleteTextField: UITextField!
    @IBOutlet private var autoCompleteDropdown: AutoCompleteTableView!

    @IBOutlet private var addedExercisesTableView: UITableView!
    @IBOutlet private var emptyDataSetView: UIView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        autoCompleteTextField.delegate = autoCompleteDropdown
        addedExercisesTableView.dataSource = self
        addedExercisesTableView.delegate = self
        autoCompleteDropdown.actionsDelegate = self
        
        configurationForEmptyDataSet()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

//        CoreData.shared.saveViewChanges()
    }

    // MARK: - Private Methods

    @IBAction func reOrderButtonPressed(_ sender: UIBarButtonItem) {
        addedExercisesTableView.isEditing.toggle()
    }

    /// Adds exercises to the tableView and updates their occurrence count for auto-complete sorting purposes
    /// - Parameter sender: The add button itself
    @IBAction private func addButtonPressed(_ sender: SWButton) {
        guard
            let exerciseName = autoCompleteTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !exerciseName.isEmpty,
            let weekday = weekday
        else { return }

        autoCompleteTextField.text?.removeAll(keepingCapacity: false)

        autoCompleteMC.incrementAutoCompleteOccurrenceCount(for: exerciseName)

        controller?.createNewExercise(named: exerciseName, for: weekday, completion: {
            if addedExercisesTableView.backgroundView != .none {
                navigationItem.largeTitleDisplayMode = .never
                addedExercisesTableView.backgroundView = .none
                addedExercisesTableView.separatorStyle = .singleLine
                addedExercisesTableView.isScrollEnabled = true
            }
        })
    }

    /// Configures the tableView's appearance based on whether or not it is empty.
    private func configurationForEmptyDataSet() {
        switch exerciseFRC?.fetchedObjects?.count ?? 0 == 0 {
        case true:
            navigationItem.largeTitleDisplayMode = .always
            addedExercisesTableView.backgroundView = emptyDataSetView
            addedExercisesTableView.separatorStyle = .none
            addedExercisesTableView.isScrollEnabled = false

        case false:
            navigationItem.largeTitleDisplayMode = .never
            addedExercisesTableView.backgroundView = .none
            addedExercisesTableView.separatorStyle = .singleLine
            addedExercisesTableView.isScrollEnabled = true
        }

        addedExercisesTableView.reloadData()
    }
}

// MARK: - TableView

extension DayVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exerciseFRC?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let exercise = exerciseFRC?.object(at: indexPath) else { return UITableViewCell() }

        let cell: AddedExercisesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configureCell(withExercise: exercise)

        print("\(exercise.name!) has order: \(exercise.order)")
        // Save index
//        if let privateExercise = CoreData.shared.privateContext.object(with: exercise.objectID) as? Exercise {
//            privateExercise.order = Int16(indexPath.row)
//        }

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
            let privateMovedObject = CoreData.shared.privateContext.object(with: sourceObjectID) as? Exercise,
            let exercises = exerciseFRC?.fetchedObjects // Why does this have zero values??
        else { return }

        // Map to private
        var privateExercises = exercises.map {
            CoreData.shared.privateContext.object(with: $0.objectID) as? Exercise
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

        CoreData.shared.savePrivateChanges()
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reset = UIContextualAction(style: .normal, title: "Reset") { _, _, completion in
            let cell = tableView.cellForRow(at: indexPath) as? AddedExercisesTableViewCell
            cell?.resetButtonValues()

            completion(true)
        }

        reset.image = UIImage(systemName: "gobackward")
        //        reset.backgroundColor = .primary

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
            CoreData.shared.viewContext.delete(exerciseFRC.object(at: indexPath))
            exercises.remove(at: indexPath.row)

            // 1st action
            DispatchQueue.main.async {
                // Map to private
                let privateExercises = exercises.map {
                    CoreData.shared.privateContext.object(with: $0.objectID) as? Exercise
                }

                // Update order
                var row: Int16 = 0
                privateExercises.forEach {
                    $0?.order = row
                    row += 1
                }

                CoreData.shared.savePrivateChanges()

                group.leave()
            }

            // 2nd action
            group.notify(queue: .main) {
                CoreData.shared.saveViewChanges()
                CoreData.shared.savePrivateChanges()

                if self?.exerciseFRC?.fetchedObjects?.count ?? 0 == 0 {
                    self?.configurationForEmptyDataSet()
                }
            }

            completion(true)
        }
        delete.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [delete])
    }
}

// MARK: - Auto-Complete TableView Actions Delegate

extension DayVC: AutoCompleteTableViewActionsDelegate {
    /// Auto-fills the textField with the given text
    /// - Parameter autoFill: The text used to replace the UITextfield's text
    internal func replaceTextFieldText(with autoFill: String) {
        autoCompleteTextField.endEditing(true)
        autoCompleteTextField.text = autoFill

        autoCompleteDropdown.hideDropDown()
    }
}

// MARK: - FetchedResultsController Delegate Methods

extension DayVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        addedExercisesTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                addedExercisesTableView.insertRows(at: [newIndexPath], with: .top)
            }
        case .update:
            if let indexPath = indexPath {
                addedExercisesTableView.reloadRows(at: [indexPath], with: .none)
            }
        case .move:
            if let oldIndexPath = indexPath, let newIndexPath = newIndexPath {
                addedExercisesTableView.deleteRows(at: [oldIndexPath], with: .none)
                addedExercisesTableView.insertRows(at: [newIndexPath], with: .none)
            }
        case .delete:
            if let indexPath = indexPath {
                addedExercisesTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            @unknown default: break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        addedExercisesTableView.endUpdates()
    }

    // MARK: - Helper Methods

//    Save positions in table view
//    func updateExerciseOrder() {
//        guard
//            let exerciseFRC = exerciseFRC,
//            let exercises = exerciseFRC.fetchedObjects
//        else { return }
//
//        var index: Int16 = 0
//
//        exercises
//            .map {
//                CoreData.shared.privateContext.object(with: $0.objectID) as? Exercise
//            }.forEach {
//                $0.order = exerciseFRC.indexPath(forObject: )
//            }
//
    ////            .forEach {
    ////                if let exercise = CoreData.shared.privateContext.object(with: $0) as? Exercise {
    ////                    exercise.order = addedExercisesTableView.
    ////                        index += 1
    ////                }
    ////            }
//
//        CoreData.shared.savePrivateChanges()
//    }
}
