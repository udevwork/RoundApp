//
//  CardsViewer.swift
//  round
//
//  Created by Denis Kotelnikov on 02.02.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

protocol PostViewerDelegate {
    func postViewer (selectedCard : CardView)
    func postViewerGetNextCard () -> CardViewModel
    func postViewer (currentCard : CardViewModel)
    func postViewer (loadedCardsCount : Int)
}


class CardsViewer: UIView {
    public var delegate : PostViewerDelegate?
    fileprivate let cardsVisibleCount = 2
    fileprivate var cards : [CardView] = []
    fileprivate var templatesCards : [UIView] = []

    
    override init(frame: CGRect) {
        super.init(frame : frame)
        createTemplateCards()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   fileprivate func createTemplateCards() {
        for i in 0...cardsVisibleCount {
            let card : UIView = CardViewTemplate(frame: CGRect(origin: .zero, size: CGSize(width: frame.width, height: frame.height)))
            templatesCards.append(card)
            addSubview(card)
            
            
            let mult : CGFloat = i == 0 ? 1 : CGFloat(1) / CGFloat(i+1)
            let pos : CGPoint = CGPoint(x: self.frame.width/2 + CGFloat(i * 90), y: self.frame.height/2)
            card.center = pos
            card.transform = CGAffineTransform(scaleX: mult, y: mult)
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                card.alpha = mult
            })
            sendSubviewToBack(card)
        }
    }

    fileprivate func removTemplateCardse() {
        templatesCards.forEach { card in
            card.removeFromSuperview()
        }
    }
    
    
    func reloadCards(){
        removTemplateCardse()
        guard let delegate = delegate else { return }
        
        for i in 0...cardsVisibleCount+4 {
            let nextCard = delegate.postViewerGetNextCard()
            let card : CardView = CardView(viewModel: nextCard, frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
            cards.append(card)
            setupGestureRecognizer(card)
            addSubview(card)
            if i > cardsVisibleCount-1 {card.isHidden = true}
            card.onCardPress = { [weak self] cv, vm in
                self?.delegate?.postViewer(selectedCard: cv)
            }
        }
        AppearanceTransition(startIndex: 0,lastIndex: cardsVisibleCount,offset: 90)
    }
    
    fileprivate func setupGestureRecognizer(_ card : CardView){
        let panRecognizer = UIPanGestureRecognizer()
        let swipeRecognizer = UISwipeGestureRecognizer()
        swipeRecognizer.direction = .left
        panRecognizer.addTarget(self, action: #selector(PanGesture(_:)))
        card.addGestureRecognizer(panRecognizer)
    }
    
    fileprivate func culculateCardsPositions(startIndex : Int, lastIndex : Int, offset : Int) {
        for i in (startIndex...lastIndex) {
            let mult : CGFloat = i == 0 ? 1 : CGFloat(1) / CGFloat(i+1)
            let pos : CGPoint = CGPoint(x: self.frame.width/2 + CGFloat(i * offset), y: self.frame.height/2)
            UIView.animate( withDuration: 0.1, animations: { [weak self] () -> Void in
                self?.cards[i].center = pos
                self?.cards[i].transform = CGAffineTransform(scaleX: mult, y: mult)
                self?.cards[i].transparent = mult
                self?.cards[i].alpha = mult
            })
            sendSubviewToBack(cards[i])
        }
    }
    
    @objc fileprivate func PanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let card = recognizer.view as? CardView else {return}
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: self)
            let location = recognizer.location(in: self)
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                let x = card.center.x + translation.x
                card.center =  CGPoint(x: x, y: card.center.y)
                
            })
            recognizer.setTranslation(.zero, in: self)
            if card.center.x < 50  {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    card.transparent = 0.4
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    card.transparent = 1
                    card.alpha = 1
                })
                backgroundCardsMovementTransition(startIndex: 1,lastIndex: cardsVisibleCount,offset: Int(location.x))
            }
        case .ended :
            cardScaleTransition(card: card, scale: 1)
            if card.center.x < 50  {
                self.cards[self.cardsVisibleCount].isHidden = false
                cardRemoveTransition(card: card)
                culculateCardsPositions(startIndex: 0,lastIndex: cardsVisibleCount,offset: 90)
            } else {
                culculateCardsPositions(startIndex: 0,lastIndex: cardsVisibleCount-1,offset: 90)
            }
        case.began :
            cardScaleTransition(card: card, scale: 1.1)
        default:
            break
        }
    }
    
    fileprivate func AppearanceTransition(startIndex : Int, lastIndex : Int, offset : Int) {
        for i in (startIndex...lastIndex) {
            let mult : CGFloat = i == 0 ? 1 : CGFloat(1) / CGFloat(i+1)
            let pos : CGPoint = CGPoint(x: self.frame.width/2 + CGFloat(i * offset), y: self.frame.height/2)
            self.cards[i].center = pos
            self.cards[i].transform = CGAffineTransform(scaleX: mult, y: mult)
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.cards[i].transparent = mult
            })
            sendSubviewToBack(cards[i])
        }
    }
    
    fileprivate func cardRemoveTransition(card : CardView){
        let savecard = self.cards.removeFirst()
        self.cards.append(savecard)
        UIView.animate(withDuration: 0.3, animations: {
            card.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            card.center = CGPoint(x: -card.bounds.width , y: self.center.y)
            card.transparent = 0
            card.alpha = 0
        }) { [weak self] ok in
            guard let nextCard = self?.delegate?.postViewerGetNextCard() else {
                Debug.log("MainViewController.nextCard =", "nil")
                return
            }
            card.isHidden = true
            self?.cards.last?.setupData(nextCard)
            self?.cards.last?.center = CGPoint(x: (self?.frame.width)! + card.bounds.width, y: (self?.cards.first?.center.y)!)
        }
    }
    
    fileprivate func cardScaleTransition(card : CardView, scale : CGFloat){
        UIView.animate(withDuration: 0.2, animations: {
            card.transform = CGAffineTransform(scaleX: scale, y: scale)
        })
    }
    
    fileprivate func backgroundCardsMovementTransition(startIndex : Int, lastIndex : Int, offset : Int){
        for i in (startIndex...lastIndex) {
            let index = i - 1
            let max = frame.width
            let normalize = (CGFloat(offset) - 0.0) / (max - 0.0) * 1.0
            let mult : CGFloat = CGFloat( 1 - normalize + 0.2) / CGFloat(index+1)
            let pos : CGPoint = CGPoint(x: self.frame.width/2 + CGFloat(i * offset), y: self.frame.height/2)
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.cards[i].center = pos
                self.cards[i].transform = CGAffineTransform(scaleX: mult, y: mult)
                self.cards[i].transparent = mult
                self.cards[i].alpha = mult
            })
        }
    }
    
}
