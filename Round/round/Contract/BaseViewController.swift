//
//  BaseViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class BaseViewController<T> : UIViewController{
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemGray6
        dismissKey()
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissKey() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class LoadingIndicator : UIView {
    var indic : UIView?
    init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func showActivityIndicatory() {
        isUserInteractionEnabled = true
        let container: UIView = UIView()
        
        let back: UIView = UIView()
        container.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8388270548)
        
        let blur = UIBlurEffect(style: .prominent)
        let effect = UIVisualEffectView(effect: blur)
        
        let loadingView: UIView = UIView()
        loadingView.backgroundColor = .black
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10

        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.style = UIActivityIndicatorView.Style.large
        container.addSubview(back)
        container.addSubview(effect)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        addSubview(container)
        actInd.startAnimating()
        indic = container
        container.easy.layout(Edges())
        loadingView.easy.layout(CenterX(),CenterY(),Width(100),Height(100))
        actInd.easy.layout(CenterX(),CenterY(),Width(80),Height(80))
        effect.easy.layout(Edges())
    }
    func hideActivityIndicatory(){
        isUserInteractionEnabled = false
        indic?.removeFromSuperview()
    }
}
