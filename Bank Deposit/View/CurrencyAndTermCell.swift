//
//  CurrencyCell.swift
//  Bank Deposit
//
//  Created by Aisha Karzhauova on 29.11.2024.
//

import UIKit
import SnapKit

class CurrencyAndTermCell: UITableViewCell, ConfigurableCell {
    private var currentData: CurrencyAndTermData?

    private let currencySegmentControl = UISegmentedControl()
    private let termSegmentControl = UISegmentedControl()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [currencySegmentControl, termSegmentControl])
        stackView.axis = .vertical
        stackView.spacing = 10
        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        // Add targets for segmented controls
        currencySegmentControl.addTarget(self, action: #selector(currencyChanged), for: .valueChanged)
        termSegmentControl.addTarget(self, action: #selector(termChanged), for: .valueChanged)
    }

    func configure(with data: Any) {
        guard let data = data as? CurrencyAndTermData else {
            fatalError("Invalid data for CurrencyAndTermCell")
        }
        currentData = data

        // Update Currency Selector
        currencySegmentControl.removeAllSegments()
        data.currencies.enumerated().forEach { index, currency in
            currencySegmentControl.insertSegment(withTitle: currency, at: index, animated: false)
        }
        currencySegmentControl.selectedSegmentIndex = data.selectedCurrencyIndex
        print("Currency Segment Control Updated to Index: \(currencySegmentControl.selectedSegmentIndex)")

        // Update Term Selector
        termSegmentControl.removeAllSegments()
        data.terms.enumerated().forEach { index, term in
            termSegmentControl.insertSegment(withTitle: term, at: index, animated: false)
        }
        termSegmentControl.selectedSegmentIndex = data.selectedTermIndex
        print("Term Segment Control Updated to Index: \(termSegmentControl.selectedSegmentIndex)")
    }



    @objc private func currencyChanged() {
        print("Currency changed to index: \(currencySegmentControl.selectedSegmentIndex)")
        guard let currentData = currentData else { return }
        currentData.onCurrencyChanged(currencySegmentControl.selectedSegmentIndex)
    }

    @objc private func termChanged() {
        print("Term changed to index: \(termSegmentControl.selectedSegmentIndex)")
        guard let currentData = currentData else { return }
        currentData.onTermChanged(termSegmentControl.selectedSegmentIndex)
    }
}

struct CurrencyAndTermData {
    let currencies: [String]
    let selectedCurrencyIndex: Int
    let terms: [String]
    let selectedTermIndex: Int
    let onCurrencyChanged: (Int) -> Void
    let onTermChanged: (Int) -> Void
}
