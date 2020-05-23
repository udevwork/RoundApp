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

class PostEditorSimpleTextCellModel: EditorBlockValidate {
    let onTextChange: (String)->()
    var text: String? = nil
    var isBold: Bool = true
    var textAligment: NSTextAlignment = NSTextAlignment.left
    init(text: String, onTextChange: @escaping (String)->()){
        self.onTextChange = onTextChange
        self.text = text
    }
    func validation() -> [String] {
        var requirements : [String] = []
        if text == nil || text == "" || text == " "  {
            requirements.append("Article block")
        }
        return requirements
    }
}

class PostEditorSimpleTextCell: UITableViewCell, UITextViewDelegate {
    
    var modelLink : PostEditorSimpleTextCellModel?
    let backGround: UIView = UIView()
    let placeholderLabel : Text = Text(.article)
    let textInputField: UITextView = UITextView()
    let textEditor: textKeybordEditor = textKeybordEditor(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    
    let deleteButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 25, height: 25))
        .setIconColor(.systemRed)
        .setColor(.clear)
        .setIcon(.crossCircle)
        .build()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        backgroundColor = .systemGray6
        addSubview(backGround)
        addSubview(textInputField)
        backGround.backgroundColor = .systemGray5
        backGround.easy.layout(Edges(10))
        backGround.layer.cornerRadius = 4
        textInputField.backgroundColor = .clear
        textInputField.easy.layout(Edges(19))
        textInputField.delegate = self
        textInputField.isScrollEnabled = false
        textInputField.autocorrectionType = .no
        textInputField.inputAccessoryView = textEditor
        textInputField.sizeToFit()
        placeholderLabel.text = "Yout article here"
        placeholderLabel.textColor = .systemGray3
        placeholderLabel.isUserInteractionEnabled = false
        placeholderLabel.font = FontNames.Bold.uiFont(18)
        addSubview(placeholderLabel)
        placeholderLabel.easy.layout(Edges(20))
        
        addSubview(deleteButton)
        deleteButton.easy.layout(Trailing(40),CenterY())
        
        textEditor.textLeftAligment.setTarget { [weak self] in
            self?.modelLink?.textAligment = .left
            self?.textInputField.textAlignment = .left
        }
        textEditor.textCenterAligment.setTarget { [weak self] in
            self?.modelLink?.textAligment = .center
            self?.textInputField.textAlignment = .center
        }
        textEditor.textRightAligment.setTarget { [weak self] in
            self?.modelLink?.textAligment = .right
            self?.textInputField.textAlignment = .right
        }
        textEditor.textBold.setTarget { [weak self] in
            self?.modelLink?.isBold = !(self?.modelLink?.isBold)!
            if (self?.modelLink!.isBold)! {
                self?.textInputField.font = FontNames.Bold.uiFont(18)
            } else {
                self?.textInputField.font = FontNames.Regular.uiFont(18)
            }
        }
        
    }
    
    public func setupWith(model: PostEditorSimpleTextCellModel) {
        
        modelLink = model
        
        textInputField.text = model.text
        if textInputField.text != "" {
            placeholderLabel.isHidden = true
        }
        if modelLink!.isBold {
            textInputField.font = FontNames.Bold.uiFont(18)
        } else {
            textInputField.font = FontNames.Regular.uiFont(18)
        }
        textInputField.textAlignment = modelLink!.textAligment
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
    
    override func willTransition(to state: UITableViewCell.StateMask) {

    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        deleteButton.isHidden = !editing
    }
}
