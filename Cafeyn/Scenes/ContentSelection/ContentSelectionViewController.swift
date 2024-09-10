//
//  ContentSelectionViewController.swift
//  Cafeyn
//
//  Created by Azat Goktas on 09/09/2024.
//

import UIKit
import SwiftUI

final class ContentSelectionViewController: UIViewController {
    var viewModel: ContentSelectionViewModelProtocol?
    private var presentation: ContentSelectionPresentation?

    private enum Constants {
        static let cancelButtonTitle = "cancel".localised
        static let saveButtonTitle = "save".localised
        static let headerHeight: CGFloat = 44
    }

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.registerCell(type: ContentItemCell.self)
        tableView.registerCell(type: UITableViewCell.self)
        return tableView
    }()

    private let activityIndicatorView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private enum Section: Int, CaseIterable {
        case selected
        case available

        var title: String {
            switch self {
            case .selected: return "organise-interest".localised
            case .available: return "spaces-headings".localised
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        viewModel?.load()
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Constants.cancelButtonTitle,
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Constants.saveButtonTitle,
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )
        navigationController?.view.backgroundColor = UIColor.white
    }

    private func setupTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
    }

    @objc private func cancelTapped() {
        // Handle cancel action
    }

    @objc private func saveTapped() {
        viewModel?.save()
    }
}

// MARK: - ContentSelectionViewModelDelegate

extension ContentSelectionViewController: ContentSelectionViewModelDelegate {
    func handleViewModelOutput(_ output: ContentSelectionViewModelOutput) {
        switch output {
        case .setLoading(let isLoading):
            isLoading ? showLoading() : stopLoading()
        case .showError(let error):
            showAlert(title: "error".localised, message: error)
        case .updateTitle(let title):
            self.title = title
        case .showTopics(let presentation):
            self.presentation = presentation
            tableView.reloadData()
        case .topicSelected(let presentation, let selectedIndex, let insertedIndex):
            self.presentation = presentation
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [IndexPath(row: selectedIndex, section: Section.available.rawValue)], with: .fade)
                if presentation.selectedTopics.count == 1 {
                    tableView.reloadRows(at: [IndexPath(row: 0, section: Section.selected.rawValue)], with: .fade)
                } else {
                    tableView.insertRows(at: [IndexPath(row: insertedIndex, section: Section.selected.rawValue)], with: .fade)
                }
            }, completion: nil)
        case .topicDeselected(let presentation, let deselectedIndex, let insertedIndex):
            self.presentation = presentation
            tableView.performBatchUpdates({
                if presentation.selectedTopics.isEmpty {
                    tableView.reloadRows(at: [IndexPath(row: 0, section: Section.selected.rawValue)], with: .fade)
                } else {
                    tableView.deleteRows(at: [IndexPath(row: deselectedIndex, section: Section.selected.rawValue)], with: .fade)
                }
                tableView.insertRows(at: [IndexPath(row: insertedIndex, section: Section.available.rawValue)], with: .fade)
            }, completion: nil)
        case .topicMoved(let presentation, let fromIndex, let toIndex):
            self.presentation = presentation
            tableView.moveRow(at: IndexPath(row: fromIndex, section: Section.selected.rawValue),
                              to: IndexPath(row: toIndex, section: Section.selected.rawValue))
        }
    }
}

// MARK: - Loading + Alert

extension ContentSelectionViewController {
    // This operations could be handled some where else but i'll keep it like this for the simplicity of the case
    private func showLoading() {
        view.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        activityIndicatorView.startAnimating()
    }

    private func stopLoading() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDragDelegate

extension ContentSelectionViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard indexPath.section == Section.selected.rawValue,
              let presentation
        else {
            return []
        }
        let item = presentation.selectedTopics[indexPath.row].name
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}


// MARK: - TableView Delegate

extension ContentSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }

        switch section {
        case .selected:
            viewModel?.deselectTopic(at: indexPath.row)
        case .available:
            viewModel?.selectTopic(at: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headerHeight
    }
}

// MARK: - Table View Data Source

extension ContentSelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section),
              let presentation = presentation else {
            return 0
        }

        switch section {
        case .selected:
            return presentation.selectedTopics.isEmpty ? 1 : presentation.selectedTopics.count
        case .available:
            return presentation.topics.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section),
              let presentation = presentation else {
            return UITableViewCell()
        }

        switch section {
        case .selected:
            if presentation.selectedTopics.isEmpty {
                guard let cell = tableView.dequeueCell(UITableViewCell.self, for: indexPath) else {
                    return UITableViewCell()
                }
                cell.contentConfiguration = UIHostingConfiguration(content: {
                    ContentSelectionEmptySelectCell()
                })
                return cell
            } else {
                guard let cell = tableView.dequeueCell(ContentItemCell.self, for: indexPath) else {
                    return UITableViewCell()
                }

                let item = presentation.selectedTopics[indexPath.row].name
                let presentation = ContentItemPresentation.forItem(item, isSelected: true)
                cell.configure(with: presentation)
                return cell
            }
        case .available:
            guard let cell = tableView.dequeueCell(ContentItemCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            let item = presentation.topics[indexPath.row].name
            let presentation = ContentItemPresentation.forItem(item, isSelected: false)
            cell.configure(with: presentation)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ContentSelectionSectionHeaderView(title: Section(rawValue: section)?.title ?? "")
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.section == Section.selected.rawValue,
              destinationIndexPath.section == Section.selected.rawValue else {
            return
        }

        viewModel?.moveTopic(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

// MARK: - UITableViewDropDelegate

extension ContentSelectionViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            if destinationIndexPath?.section == Section.selected.rawValue {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        }
        return UITableViewDropProposal(operation: .forbidden)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath,
              destinationIndexPath.section == Section.selected.rawValue else {
            return
        }

        coordinator.session.loadObjects(ofClass: NSString.self) { [weak self] items in
            guard let strings = items as? [String] else { return }

            for (index, _) in strings.enumerated() {
                let sourceIndex = destinationIndexPath.row
                let destinationIndex = destinationIndexPath.row + index
                self?.viewModel?.moveTopic(from: sourceIndex, to: destinationIndex)
            }
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == Section.selected.rawValue
    }
}
