//
//  HomeCollectionViewCell.swift
//  simplecaller
//
//  Created by Bertay Yönel on 12.08.2023.
//

import UIKit
import SnapKit

// MARK: - HomeCollectionViewCellViewDelegate
protocol HomeCollectionViewCellViewDelegate: AnyObject {
}

final class HomeCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    static let identifier = "HomeCollectionViewCell"
    private var viewModel: HomeCollectionViewCellViewModel?
    weak var delegate: HomeCollectionViewCellViewDelegate?
    
    private lazy var externalIDLabel: UILabel = {
        let externalIDLabel = UILabel()
        externalIDLabel.textColor = .black
        return externalIDLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Helpers
    override func prepareForReuse() {
        externalIDLabel.text = nil
    }
    
    func configure(with viewModel: HomeCollectionViewCellViewModel) {
        self.viewModel = viewModel
        externalIDLabel.text = viewModel.external_id
    }
}

// MARK: - Helpers
private extension HomeCollectionViewCell {
    func setupView() {
        backgroundColor = .white
        addSubview(externalIDLabel)
        
        externalIDLabel.snp.makeConstraints() { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
    }
}
