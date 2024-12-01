//
//  DepositViewModel.swift
//  Bank Deposit
//
//  Created by Aisha Karzhauova on 29.11.2024.
//

import Foundation

class DepositViewModel {
    public var model = DepositModel()
    
    // Callback to notify view of calculations
    var onDepositCalculation: ((Double, Double) -> Void)?
    
    // Computed properties for summary
    var totalAmount: Double = 0.0
    var ownFunds: Double = 0.0
    var interest: Double = 0.0
    
    var currencyIndex: Int = 0
    var termIndex: Int = 1

    func updateCurrency(_ currency: String) {
        model.currency = currency
        currencyIndex = ["KZT", "USD", "EUR"].firstIndex(of: currency) ?? 0
        calculateSummary()
    }

    func updateLeaveInterest(_ isEnabled: Bool) {
        model.leaveInterestOnDeposit = isEnabled
        calculateSummary()
    }

    func updateDepositAmount(_ amount: Double) {
        model.depositAmount = amount
        calculateSummary()
    }

    func updateMonthlyTopUp(_ amount: Double) {
        model.monthlyTopUp = amount
        calculateSummary()
    }

    func updateTerm(_ months: Int) {
        model.termInMonths = months
        termIndex = (months == 6) ? 0 : 1
        calculateSummary()
    }
    

    private func calculateSummary() {
        let principal = model.depositAmount
        let monthlyTopUp = model.monthlyTopUp
        let rate = model.leaveInterestOnDeposit ? 0.138 : 0.128
        let term = Double(model.termInMonths)
        
        interest = (principal + (monthlyTopUp * term)) * rate
        totalAmount = principal + (monthlyTopUp * term) + interest
        ownFunds = principal + (monthlyTopUp * term)

        // Notify view of updated calculations
        onDepositCalculation?(totalAmount, interest)
    }
}
