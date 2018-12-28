//
//  ViewController.swift
//  Concentration
//
//  Created by Simone Smith on 27/12/2018.
//  Copyright © 2018 Simone Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRandomTheme()
    }
    
    private var emojiChoices = [String]()
    private var emoji = [Card:String]()

    private func setRandomTheme() {
        var themes = [
            "halloween": ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"],
            "breakfast": ["🥑", "🍳", "🥐", "🥓", "🍌", "🍞", "🥞", "☕️", "🥛"],
            "sport": ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🎱", "🏓"],
            "vehicles": ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒"],
            "hearts": ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "💔", "💖"],
            "clothes": ["👚", "👕", "👖", "👔", "👗", "👙", "👘", "👠", "👡"]
        ]
        
        let themeKeys = Array(themes.keys)
        let themeIndex = Int(arc4random_uniform(UInt32(themeKeys.count)))
        emojiChoices = Array(themes.values)[themeIndex]
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons")
        }
        scoreLabel.text = "Score: \(game.score)"
        updateFlipCountLabel()
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
    
    @IBAction private func startNewGame(_ sender: UIButton) {
        game.flipCount = 0
        game.score = 0
        scoreLabel.text = "Score: 0"
        flipCountLabel.text = "Flips: 0"
        emojiChoices += emoji.values
        emoji = [Card:String]()
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.setTitle("", for: .normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        }
        game.newGame()
        setRandomTheme()
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
