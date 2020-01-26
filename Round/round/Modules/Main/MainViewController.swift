//
//  MainViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 07.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class MainViewController: BaseViewController<MainViewModel> {
    
    fileprivate let cardsVisibleCount = 2
    fileprivate var cards : [CardView] = []
    override init(viewModel: MainViewModel) {
        super.init(viewModel: viewModel)
        title = "Round"
        controllerIcon = Icons.location
        viewModel.loadCards {
            DispatchQueue.main.async {
                self.setupCards()
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupCards(){
        
        for i in 0...cardsVisibleCount+4 {
            guard let nextCard = viewModel.getNextCard() else {
                print("nil, bro... nil")
                return
            }
            let card : CardView = CardView(viewModel: nextCard, frame: CGRect(x: 1000, y: view.frame.height/2, width: 250, height: 350))
            print(card.descriptionLabel.text ?? "fuck")
            cards.append(card)
            setupGestureRecognizer(card)
            view.addSubview(card)
            if i > cardsVisibleCount-1 {card.isHidden = true}
            card.onCardPress = { cv, vm in
                let vc = PostViewController(viewModel: PostViewModel(cardView: cv))
                self.present(vc, animated: true, completion: nil)
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
            let viewCenter = view.center
            let pos = CGPoint(x: viewCenter.x + CGFloat(i * offset), y: viewCenter.y)
            UIView.animate( withDuration: 0.1, animations: { () -> Void in
                self.cards[i].center = pos
                self.cards[i].transform = CGAffineTransform(scaleX: mult, y: mult)
                self.cards[i].transparent = mult
                self.cards[i].alpha = mult
            })
            view.sendSubviewToBack(cards[i])
        }
    }
    
    @objc fileprivate func PanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let card = recognizer.view as? CardView else {return}
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: self.view)
            let location = recognizer.location(in: self.view)
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                let x = card.center.x + translation.x
                card.center =  CGPoint(x: x, y: card.center.y)
                
            })
            recognizer.setTranslation(.zero, in: self.view)
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
            let viewCenter = view.center
            let pos = CGPoint(x: viewCenter.x + CGFloat(i * offset), y: viewCenter.y)
            self.cards[i].center = pos
            self.cards[i].transform = CGAffineTransform(scaleX: mult, y: mult)
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.cards[i].transparent = mult
            })
            view.sendSubviewToBack(cards[i])
        }
    }
    
    fileprivate func cardRemoveTransition(card : CardView){
        let savecard = self.cards.removeFirst()
        self.cards.append(savecard)
        UIView.animate(withDuration: 0.3, animations: {
            card.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            card.center = CGPoint(x: -card.bounds.width , y: self.view.center.y)
            card.transparent = 0
            card.alpha = 0
        }) { ok in
            guard let nextCard = self.viewModel.getNextCard() else {
                print("nil, bro... nil")
                return
            }
            card.isHidden = true
            self.cards.last?.setupData(nextCard)
            self.cards.last?.center = CGPoint(x: self.view.frame.width + card.bounds.width, y: (self.cards.first?.center.y)!)
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
            let max = view.frame.width
            let normalize = (CGFloat(offset) - 0.0) / (max - 0.0) * 1.0
            let mult : CGFloat = CGFloat( 1 - normalize + 0.2) / CGFloat(index+1)
            let viewCenter = view.center
            let pos = CGPoint(x: viewCenter.x + CGFloat(index * offset), y: viewCenter.y)
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.cards[i].center = pos
                self.cards[i].transform = CGAffineTransform(scaleX: mult, y: mult)
                self.cards[i].transparent = mult
                self.cards[i].alpha = mult
            })
        }
    }
}
