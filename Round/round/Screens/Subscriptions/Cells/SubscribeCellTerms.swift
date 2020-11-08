//
//  SubscribeCellTerms.swift
//  round
//
//  Created by Denis Kotelnikov on 07.11.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//


import Foundation
import UIKit
import EasyPeasy

class SubscribeCellTerms: UITableViewCell {
    
    var data: SubscriptionsCellTermsModel? = nil
    
    
    private let terms: Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 100, height: 60)))
        .setStyle(.text)
        .setText(localized(.subscriptionTerms))
        .setTextColor(.label)
        .setColor(.clear)
        .build()
    
    private let privcy: Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 100, height: 60)))
        .setStyle(.text)
        .setText(localized(.policy))
        .setTextColor(.label)
        .setColor(.clear)
        .build()
    
    private let delimiter: UIView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 1, height: 17)))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDesign() {
        backgroundColor = .clear
        delimiter.backgroundColor = .systemGray2
    
        
        contentView.addSubview(terms)
        contentView.addSubview(delimiter)
        contentView.addSubview(privcy)
        
        terms.easy.layout(CenterX(),Top(20), Bottom(60))
        privcy.easy.layout(CenterX(),Bottom(20),  Top(60))
        
        delimiter.easy.layout(Center(),Height(1),Width(27))
        
        terms.setTarget { [weak self] in
            
            self?.data?.onTermspress()
        }
        privcy.setTarget { [weak self] in
            
            self?.data?.onPrivacypress()
        }
        selectionStyle = .none
    }
    
    public func setup(data: SubscriptionsCellTermsModel){
        self.data = data
    }
    
    
}
