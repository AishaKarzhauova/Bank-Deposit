//
//  ViewController.swift
//  Bank Deposit
//
//  Created by Aisha Karzhauova on 29.11.2024.
//
import UIKit

class ViewController: UIViewController {
    private let viewModel = DepositViewModel()
    private let tableView = UITableView()
    
    private var cellConfigurators: [CellConfigurator] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        configureCells()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.register(CurrencyAndTermCell.self, forCellReuseIdentifier: CurrencyAndTermCell.reuseIdentifier)
        tableView.register(InputFieldCell.self, forCellReuseIdentifier: InputFieldCell.reuseIdentifier)
        tableView.register(TextCell.self, forCellReuseIdentifier: TextCell.reuseIdentifier)
        tableView.register(SummaryCell.self, forCellReuseIdentifier: SummaryCell.reuseIdentifier)
    }
    
    private func setupBindings() {
        viewModel.onDepositCalculation = { [weak self] total, interest in
            guard let self = self else { return }
            self.configureCells()
            self.reloadSummaryRow()
        }
    }
    
    
    
    private func reloadSummaryRow() {
        let summaryRowIndex = cellConfigurators.count - 1 // Assuming the summary cell is the last row
        let indexPath = IndexPath(row: summaryRowIndex, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    func updateCurrencyAndTermCell() {
        let indexPath = IndexPath(row: 0, section: 0) // Assuming it's the first cell
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    private func configureCells() {
        cellConfigurators = [
            TableCellConfigurator<CurrencyAndTermCell>(item: CurrencyAndTermData(
                currencies: ["KZT", "USD", "EUR"],
                selectedCurrencyIndex: 0,
                terms: ["6 мес.", "12 мес."],
                selectedTermIndex: 1,
                onCurrencyChanged: { [weak self] index in
                    let selectedCurrency = ["KZT", "USD", "EUR"][index]
                    self?.viewModel.updateCurrency(selectedCurrency)
                    self?.updateCurrencyAndTermCell()
                },

                onTermChanged: { [weak self] index in
                    let selectedTerm = index == 0 ? 6 : 12
                    self?.viewModel.updateTerm(selectedTerm)
                    self?.updateCurrencyAndTermCell()
                }
            )),

            // Deposit Amount Input Field Cell
            TableCellConfigurator<InputFieldCell>(item: InputFieldData(
                title: "Сумма депозита",
                placeholder: "Введите сумму",
                value: viewModel.model.depositAmount, // Initialize with the current deposit amount
                onValueChange: { [weak self] value in
                    self?.viewModel.updateDepositAmount(value)
                    self?.reloadSummaryRow()
                }
            )),

            // Monthly Top-Up Input Field Cell
            TableCellConfigurator<InputFieldCell>(item: InputFieldData(
                title: "Ежемесячно буду пополнять",
                placeholder: "Введите сумму",
                value: viewModel.model.monthlyTopUp, // Initialize with the current monthly top-up value
                onValueChange: { [weak self] value in
                    self?.viewModel.updateMonthlyTopUp(value)
                    self?.reloadSummaryRow()
                }
            )),

            
            // Effective and Nominal Rate Text Cells
            TableCellConfigurator<TextCell>(item: TextCellData(
                text: "Эффективная ставка: 13.8%",
                fontSize: 16
            )),

            // Nominal Rate Text Cell
            TableCellConfigurator<TextCell>(item: TextCellData(
                text: "Номинальная ставка: 12.8%",
                fontSize: 16
            )),

            // Summary Cell
            TableCellConfigurator<SummaryCell>(item: SummaryCellData(
                total: "Итоговая сумма: \(String(format: "%.2f", viewModel.totalAmount))",
                ownFunds: "Собственные средства: \(String(format: "%.2f", viewModel.ownFunds))",
                interest: "Проценты от банка: \(String(format: "%.2f", viewModel.interest))"
            ))
        ]
    }
}


extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellConfigurators.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configurator = cellConfigurators[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: configurator).reuseId, for: indexPath)
        configurator.configure(cell: cell)
        print("Configuring cell at row \(indexPath.row)")
        return cell
    }
}
