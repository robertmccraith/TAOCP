//
//  Cards.swift
//  TAOCP
//
//  Created by Robert McCraith on 18/07/2015.
//  Copyright © 2015 Robert McCraith. All rights reserved.
//

import Foundation




class Card{
	var tag:Bool = false
	enum Suit:Int {
		case clubs
		case diamonds
		case hearts
		case spades
	}
	var suit:Suit!
	
	var rank:Int = 0
	var next:Card? = nil
	var title:String!
	
	init(suit: Suit, rank: Int, next: Card?){
		self.suit = suit
		self.rank = rank
		self.next = next
		if rank == 11 {
			self.title = "Jack"
		}else if rank == 12 {
			self.title = "Queen"
		}else if rank == 13 {
			self.title = "King"
		}else if rank == 1{
			self.title = "Ace"
		}else {
			self.title = "\(rank)"
		}
		
		switch suit{
		case .clubs:
			self.title = self.title.stringByAppendingString(" Clubs")
		case .diamonds:
			self.title = self.title.stringByAppendingString(" Diamonds")
		case .hearts:
			self.title = self.title.stringByAppendingString(" Hearts")
		case .spades:
			self.title = self.title.stringByAppendingString(" Spades")
		}
		
		
	}
}


class Linked {
	var top:Card!
	
	
	func createList(){
		var card = Card(suit: Card.Suit.clubs, rank: 5, next: nil)
		card = Card(suit: Card.Suit.spades, rank: 4, next: card)
		card = Card(suit: Card.Suit.hearts, rank: 3, next: card)
		card = Card(suit: Card.Suit.diamonds, rank: 2, next: card)
		card = Card(suit: Card.Suit.clubs, rank: 1, next: card)
		top = card
		print(top)
	}
	
	func newTop(newCard: Card){
		newCard.next = top
		top = newCard
		top.tag = true
	}

	//ex 3 - remove top card
	func rmtop()->Card?{
		if let card = top {
			top = card.next
			return card
		}
		return nil
		
	}

	//ex 4 - new card at bottom, faced down(tag = false)
	func newBottom(newCard : Card){
		newCard.tag = false
		var card = top
		if card == nil {
			top = newCard
			return
		}
		while card.next != nil {
			card = card.next
		}
		card.next = newCard
	}
	
	//ex 5 - undo 4 assuming pile not empty
	func rmBottom()->Card{
		var card = top
		while card.next?.next != nil {
			card = card.next
		}
		let last = card.next
		card.next = nil
		return last!
	}
	
	//ex 9 - print cards in deck starting at top, one line per card, in brackets if faced down
	func printDeck(){
		var card = top
		while card != nil {
			if card.tag {
				print("\(card.title)", appendNewline: true)
			}else{
				print("{\(card.title)}", appendNewline: true)
			}
			card = card.next
		}
	}
}