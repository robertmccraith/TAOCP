//
//  main.swift
//  TAOCP
//
//  Created by Robert McCraith on 05/07/2015.
//  Copyright © 2015 Robert McCraith. All rights reserved.
//

import Foundation

var perm = Permutations()
perm.run()


var link = Linked()
link.createList()
link.newTop(Card(suit: Card.Suit.spades, rank: 1, next: nil))
link.rmtop()
link.newBottom(Card(suit: Card.Suit.spades, rank: 1, next: nil))
link.printDeck()