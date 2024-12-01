//
//  InputCell.swift
//  Bank Deposit
//
//  Created by Aisha Karzhauova on 29.11.2024.
//
import UIKit
import SnapKit

class InputFieldCell: UITableViewCell, ConfigurableCell, UITextFieldDelegate {
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private var onValueChange: ((Double) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)

        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .darkGray

        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    func configure(with data: Any) {
        guard let data = data as? InputFieldData else {
            fatalError("Invalid data for InputFieldCell")
        }
        titleLabel.text = data.title
        textField.placeholder = data.placeholder
        textField.text = data.value > 0 ? String(format: "%.2f", data.value) : ""
        onValueChange = data.onValueChange
        print("Configured InputFieldCell with value: \(textField.text ?? "")")
    }


    @objc private func textFieldDidChange() {
        print("TextField Value Changed: \(textField.text ?? "")")
        guard let text = textField.text, let value = Double(text) else {
            return
        }
        onValueChange?(value)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        let characterSet = CharacterSet(charactersIn: string)
        let result = allowedCharacters.isSuperset(of: characterSet)
        print("Should Change Characters: \(result), Input: \(string)")
        return result
    }
}

struct InputFieldData {
    let title: String
    let placeholder: String
    var value: Double // Initialize with an initial value
    let onValueChange: (Double) -> Void
}
