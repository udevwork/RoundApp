//
//  PostEditorContract.swift
//  round
//
//  Created by Denis Kotelnikov on 09.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

enum EditorBlockCellTypes {
    case header(model: PostEditorHeaderCellModel)
    case addButton(model: PostEditorAddNewBlockCellModel)
    case simpleText(model: PostEditorSimpleTextCellModel)
    case photo(model: PostEditorPhotoBlockCellModel)
    case title(model: PostEditorTitleTextCellModel)

}

protocol PostEditorViewModelProtocol: BaseViewModel {
    var dataSource: [EditorBlockCellTypes] { get set }
}
