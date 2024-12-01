//
//  ConfigurableCell.swift
//  Bank Deposit
//
//  Created by Aisha Karzhauova on 29.11.2024.
//

import UIKit

protocol ConfigurableCell: AnyObject {
    static var reuseIdentifier: String { get }
    func configure(with data: Any)
}

extension ConfigurableCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}


protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView)
}

class TableCellConfigurator<CellType: ConfigurableCell>: CellConfigurator where CellType: UITableViewCell {
    static var reuseId: String {
        return CellType.reuseIdentifier
    }

    private let item: Any

    init(item: Any) {
        self.item = item
    }

    func configure(cell: UIView) {
        guard let cell = cell as? CellType else {
            fatalError("Failed to cast cell to \(CellType.self)")
        }
        cell.configure(with: item)
    }
}
