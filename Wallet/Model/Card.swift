//
//  Card.swift
//  Wallet
//
//  Created by MacBook Air on 12.03.22.
//

import SwiftUI


// Sample Card Model and Data

struct Card: Identifiable {
    var id = UUID().uuidString
    var name: String
    var CardNumber: String
    var CardImage: String
}

var cards: [Card] = [

Card(name: "Rustam Manafli", CardNumber: "1234 5678 1234 5678", CardImage: "Card1"),
Card(name: "Rustam Manafli", CardNumber: "1234 5678 1234 5678", CardImage: "Card2"),
Card(name: "Rustam Manafli", CardNumber: "1234 5678 1234 5678", CardImage: "Card3")

]

