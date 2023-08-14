//
//  Section.swift
//  simplecaller
//
//  Created by Bertay Yönel on 12.08.2023.
//

import Foundation

final class Section: Hashable {
    // MARK: Properties
    let userCellViewModel: HomeCollectionViewCellViewModel
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.userCellViewModel.external_id == rhs.userCellViewModel.external_id
    }
    // MARK: init
    public init(userCellViewModel: HomeCollectionViewCellViewModel) {
        self.userCellViewModel = userCellViewModel
    }
    // MARK: Helpers
    func hash(into hasher: inout Hasher) {
        hasher.combine(userCellViewModel.external_id)
    }
}
