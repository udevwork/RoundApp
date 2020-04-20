//
//  PostEditorSimpleTextCell.swift
//  round
//
//  Created by Denis Kotelnikov on 12.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

import UIKit
import EasyPeasy

class PostEditorSimpleTextCellModel {
    let onTextChange: (String)->()
    var text: String = ""
    init(text: String, onTextChange: @escaping (String)->()){
        self.onTextChange = onTextChange
        self.text = text
    }
}

class PostEditorSimpleTextCell: UITableViewCell, UITextViewDelegate {
    
    var modelLink : PostEditorSimpleTextCellModel?

    let placeholderLabel : Text = Text(.article)
    let textInputField: UITextView = UITextView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        backgroundColor = .systemGray6
        addSubview(textInputField)
        textInputField.backgroundColor = .systemGray6
        textInputField.font = FontNames.Bold.uiFont(18)
        textInputField.easy.layout(Edges(19))
        textInputField.delegate = self
        textInputField.isScrollEnabled = false
        textInputField.sizeToFit()
        placeholderLabel.text = "Yout article here"
        placeholderLabel.textColor = .systemGray3
        placeholderLabel.isUserInteractionEnabled = false
        placeholderLabel.font = FontNames.Bold.uiFont(18)
        addSubview(placeholderLabel)
        placeholderLabel.easy.layout(Edges(20))
    }
        
    public func setupWith(model: PostEditorSimpleTextCellModel) {
        
        modelLink = model

        textInputField.text = model.text
        if textInputField.text != "" {
            placeholderLabel.isHidden = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        modelLink?.text = textInputField.text
        expandTextConstraints()
    }
    
    private func expandTextConstraints(){
        textInputField.sizeToFit()
        textInputField.easy.reload()
        modelLink?.onTextChange("!@#") /// it reload tableview to expand cell
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
              placeholderLabel.isHidden = false
        }
        
    }
}
