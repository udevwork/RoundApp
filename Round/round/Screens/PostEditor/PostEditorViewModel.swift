//
//  PostEditorViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 09.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

class PostEditorViewModel: PostEditorViewModelProtocol {
    var dataSource: [EditorBlockCellTypes] = []
    var needToUpdateTable: Observable<Bool> = .init(false)
    var cellSizeChange: Observable<Bool> = .init(false)
    var router: PostEditorRouter?
    typealias routerType = PostEditorRouter

    init() {
        
        let headerCellModel = PostEditorHeaderCellModel { [weak self] imageView in
            self?.router?.ShowPhotoPicker(onImageSelect: { img in
                imageView(img)
                
            })
        }
        
        let addBlockButtonModel = PostEditorAddNewBlockCellModel { [weak self] in
            self?.router?.ShowBlockPicker { type in
                switch type {
                case .simpleText:
                    let textModel = PostEditorSimpleTextCellModel(text: "") { text in
                        print(text)
                        self?.cellSizeChange.value = true
                    }
                    self?.dataSource.insert(.simpleText(model: textModel), at: (self?.dataSource.count)!-1)
                case .TitleText:
                    let textModel = PostEditorTitleTextCellModel(text: "") { text in
                        print(text)
                        self?.cellSizeChange.value = true
                    }
                    self?.dataSource.insert(.title(model: textModel), at: (self?.dataSource.count)!-1)
                case .Photo:
                    let photModel = PostEditorPhotoBlockCellModel { imageView in
                        self?.router?.ShowPhotoPicker(onImageSelect: { img in
                            imageView(img)
                        })
                    }
                    self?.dataSource.insert(.photo(model: photModel), at: (self?.dataSource.count)!-1)
                }
                
                self?.needToUpdateTable.value = true
            }
            
        }
        
        dataSource.append(.header(model: headerCellModel))
        dataSource.append(.addButton(model: addBlockButtonModel))
    }
    
}
