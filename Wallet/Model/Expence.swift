//
//  Expence.swift
//  Wallet
//
//  Created by MacBook Air on 12.03.22.
//

import SwiftUI

struct Expence: Identifiable{
    var id = UUID().uuidString
    var amountSpend: String
    var product: String
    var productIcon: String
    var spendType: String
    
}

var expences: [Expence] = [

    Expence(amountSpend: "$10", product: "Amazon", productIcon: "Amazon", spendType: "Groceries"),
    Expence(amountSpend: "$20", product: "Youtube", productIcon: "Youtube", spendType: "Streaming"),
    Expence(amountSpend: "$30", product: "Meta", productIcon: "Meta", spendType: "Membership"),
    Expence(amountSpend: "$40", product: "Apple", productIcon: "Facebook", spendType: "Apple Pay"),
    Expence(amountSpend: "$50", product: "Microsoft", productIcon: "Microfoft", spendType: "Office"),
    Expence(amountSpend: "$60", product: "Payonix", productIcon: "Payonix", spendType: "Membership"),
    Expence(amountSpend: "$70", product: "Instagram", productIcon: "Instagram", spendType: "Ad Publish")


]
