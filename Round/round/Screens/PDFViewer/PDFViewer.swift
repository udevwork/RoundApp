//
//  PDFViewer.swift
//  round
//
//  Created by Denis Kotelnikov on 06.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import PDFKit


class PDFViewer: UIViewController {
    
    enum pdfs {
        case PRIVACYPOLICY
        case SUBSCRIPTIONTERMS
        case TERMSANDCONDITIONSOFUSE
        
        func file() -> URL? {
            switch self {
            case .PRIVACYPOLICY:
                return Bundle.main.url(forResource: "PRIVACY POLICY", withExtension: "pdf")
            case .SUBSCRIPTIONTERMS:
                return Bundle.main.url(forResource: "SUBSCRIPTION TERMS", withExtension: "pdf")
            case .TERMSANDCONDITIONSOFUSE:
                return Bundle.main.url(forResource: "TERMS AND CONDITIONS OF USE", withExtension: "pdf")
            }
        }
    }
    
    let pdfView: PDFView = PDFView()
    
    init(file: PDFViewer.pdfs) {
        super.init(nibName: nil, bundle: nil)
        setupView()
        showPDF(file: file)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        self.view.addSubview(pdfView)
        pdfView.easy.layout(Edges())
        pdfView.autoScales = true
    }
    
    
    public func showPDF(file: PDFViewer.pdfs){
        if let url = file.file() {
            pdfView.document = PDFDocument(url: url)
        } else {
            debugPrint("PDF NOT FOUND")
        }
    }
}
