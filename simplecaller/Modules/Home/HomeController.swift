//
//  HomeController.swift
//  simplecaller
//
//  Created by Bertay Yönel on 12.08.2023.
//

import UIKit
import SnapKit

class HomeController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeCollectionViewCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomeCollectionViewCellViewModel>
    
    private var viewModel: HomeViewModelInput
    private lazy var dataSource = generateDatasource()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, HomeCollectionViewCellViewModel>()
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton()
        let image = UIImage(systemName: "plus.circle")
        addButton.setImage(image, for: .normal)
        addButton.imageView?.contentMode = .scaleAspectFill
        addButton.imageView?.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(60)
        }
        addButton.addTarget(self, action: #selector(addContactPressed), for: .touchUpInside)
        return addButton
    }()
    
    override func viewDidLoad() {
        setupViews()
        viewModel.initializeAgoraEngine()
        viewModel.requestMicAccess()
        viewModel.getContacts()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.cleanUp()
    }
    
    init(viewModel: HomeViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .main)
        self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeController {
    func setupViews() {
        self.title = "Home"
        view.backgroundColor = .black
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        view.addSubview(addButton)
        
        collectionView.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
        
        addButton.snp.makeConstraints() { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    @objc func addContactPressed() {
        let alertController = UIAlertController(title: "Enter Contact Name", message: nil, preferredStyle: .alert)
                alertController.addTextField { textField in
                    textField.placeholder = "Enter contact name here"
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
                    if let textField = alertController.textFields?.first {
                        if let enteredText = textField.text {
                            self.viewModel.checkAndAddExternalID(with: enteredText)
                        }
                    }
                }
                alertController.addAction(cancelAction)
                alertController.addAction(confirmAction)
                present(alertController, animated: true, completion: nil)
    }
    
    func showMessage(title: String, text: String, delay: Int = 5) -> Void {
        let deadlineTime = DispatchTime.now() + .seconds(delay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
            self.present(alert, animated: true)
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(viewModel.getSections())
        viewModel.getSections().forEach { section in
            snapshot.appendItems([section.userCellViewModel], toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func generateDatasource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, cellViewModel) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
                    return .init(frame: .zero)
                }
                cell.delegate = self
                cell.configure(with: cellViewModel)
                return cell
            })
        return dataSource
    }
}

extension HomeController: HomeViewModelOutput {
    func home(isRegistered: Bool) {
        if isRegistered == false {
        }
    }
    
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad list: [Section]) {
        DispatchQueue.main.async {
            viewModel.updateSections(list)
            self.applySnapshot(animatingDifferences: false)
        }
    }
    
    func home(_ userExistsWith: String) {
    }
    
    func home(state: CallStateVM) {
    }
    
    func home(title: String, text: String) {
        showMessage(title: title, text: text)
    }
}

extension HomeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let section = viewModel.getSections()[indexPath.section]
            let cellViewModel = section.userCellViewModel
            viewModel.startCall(with: cellViewModel.external_id)
    }
}

extension HomeController: HomeCollectionViewCellViewDelegate {
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 25
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
}
