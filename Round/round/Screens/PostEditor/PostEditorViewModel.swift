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
    var locationManager: LocationManager = LocationManager()
    private let headerModel: PostEditorHeaderCellModel
    typealias routerType = PostEditorRouter

    init() {
        headerModel = PostEditorHeaderCellModel()
        headerModel.onAddPhotoAddButtonPress = { [weak self] imageView in
            self?.router?.ShowPhotoPicker(onImageSelect: { img in imageView(img) })
        }
        
        dataSource.append(.header(model: headerModel))
        locationManager.update()

    }
    
    func getLocation(complition: @escaping ()->()) {
        locationManager.getLocation() { [weak self] l in
            self?.router?.showLocationUseAlert(l: l, onUse: {  [weak self] in
                self?.headerModel.location = l
                Notifications.shared.Show(RNSimpleView(text: "Applied", icon: Icons.pin.image(),iconColor: .systemTeal))
                complition()
            })
            
        }
    }
    
    func showBlockPicker(){
        self.router?.ShowBlockPicker { [weak self] type in
            switch type {
            case .simpleText:
                let textModel = PostEditorSimpleTextCellModel(text: "") { text in
                    Debug.log(text)
                    self?.cellSizeChange.value = true
                }
                self?.dataSource.insert(.simpleText(model: textModel), at: (self?.dataSource.count)!)
            case .TitleText:
                let textModel = PostEditorTitleTextCellModel(text: "") { text in
                    Debug.log(text)
                    self?.cellSizeChange.value = true
                }
                self?.dataSource.insert(.title(model: textModel), at: (self?.dataSource.count)!)
            case .Photo:
                let photModel = PostEditorPhotoBlockCellModel { imageView in
                    self?.router?.ShowPhotoPicker(onImageSelect: { img in
                        imageView(img)
                    })
                }
                self?.dataSource.insert(.photo(model: photModel), at: (self?.dataSource.count)!)
            default: break
            }
            
            self?.needToUpdateTable.value = true
        }
    }
    
    func save(){
        if validation() == false {
            return
        }
        router?.showPostSaveAlert(onSave: { [weak self] in
            Notifications.shared.Show(RNSimpleView(text: "Ok", icon: Icons.checkmark.image()))
            FirebaseAPI.shared.savePost(cellData: self!.dataSource) { [weak self] in
                self!.router?.controller?.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    private func validation() -> Bool{
        var requirements : [String] = []
        for item in dataSource {
            switch item {
            case let .header(model):
                requirements.append(contentsOf: model.validation())
            case let .simpleText(model):
                requirements.append(contentsOf: model.validation())
            case let .title(model):
                requirements.append(contentsOf: model.validation())
            case let .photo(model):
                requirements.append(contentsOf: model.validation())
            default:
                break
            }
        }
        if requirements.count == 0 {
            return true
        } else {
            router?.showValidationAlert(requirements: requirements)
            return false
        }
        
    }
    
}
