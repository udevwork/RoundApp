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
        case agreement
        case policy
        
        func file() -> URL? {
            switch self {
            case .agreement:
                return Bundle.main.url(forResource: "agreement", withExtension: "pdf")
            case .policy:
                return Bundle.main.url(forResource: "agreement", withExtension: "pdf")
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
