//
//  TextCell.swift
//  Bank Deposit
//
//  Created by Aisha Karzhauova on 01.12.2024.
//


import UIKit

class TextCell: UITableViewCell, ConfigurableCell {
    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        label.textAlignment = .center
        label.numberOfLines = 0
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }

    func configure(with data: Any) {
        guard let data = data as? TextCellData else {
            fatalError("Invalid data for TextCell")
        }
        label.text = data.text
        label.font = UIFont.systemFont(ofSize: data.fontSize)
    }
}

struct TextCellData {
    let text: String
    let fontSize: CGFloat
}
