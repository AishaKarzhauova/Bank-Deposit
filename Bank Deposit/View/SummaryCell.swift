//
//  SummaryCell.swift
//  Bank Deposit
//
//  Created by Aisha Karzhauova on 29.11.2024.
//

import UIKit

class SummaryCell: UITableViewCell, ConfigurableCell {
    private let totalLabel = UILabel()
    private let ownFundsLabel = UILabel()
    private let interestLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [totalLabel, ownFundsLabel, interestLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        totalLabel.font = UIFont.boldSystemFont(ofSize: 24)
        totalLabel.textColor = .systemGreen

        ownFundsLabel.font = UIFont.systemFont(ofSize: 18)
        interestLabel.font = UIFont.systemFont(ofSize: 18)
    }

    func configure(with data: Any) {
        guard let data = data as? SummaryCellData else {
            fatalError("Invalid data for SummaryCell")
        }
        totalLabel.text = data.total
        ownFundsLabel.text = data.ownFunds
        interestLabel.text = data.interest
    }
    
}

struct SummaryCellData {
    let total: String
    let ownFunds: String
    let interest: String
}
