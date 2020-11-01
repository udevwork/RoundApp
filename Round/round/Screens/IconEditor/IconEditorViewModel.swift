//
//  IconEditorViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 31.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
class IconEditorViewModel {
    let router: IconEditorRouter
    var instruments: [EditorIntsrument] = []
    //
    var backgroundColor: UIImageView?
    var backgroundImage: UIImageView?
    var icon: UIImageView?
    var slider: IconEditorSlider?
    
    var saveBackgroundAlpha : Float = 1
    var saveBackgroundRound : Float = 0
    var saveIconScale : Float = 1
    
    
    init(router: IconEditorRouter) {
        self.router = router
        setupInstruments()
    }
    
    private func setupInstruments() {
        let instruments = [
            ColorInstrument(icon: Icons.iconsStack.image(weight: .thin), lableText: localized(.iconList),
                            onPress: { [weak self] in self?.showIconsPicker() }),
            ColorInstrument(icon: Icons.brush.image(weight: .thin), lableText: localized(.iconColor),
                            onPress: { [weak self] in self?.iconColorChange() }),
            ColorInstrument(icon: Icons.scale.image(weight: .thin), lableText: localized(.iconSize),
                            onPress: { [weak self] in self?.iconScaleChange() }),
            ColorInstrument(icon: Icons.gallery.image(weight: .thin), lableText: localized(.backgroundImage),
                            onPress: { [weak self] in self?.backgroundImagePick() }),
            ColorInstrument(icon: Icons.alpha.image(weight: .thin), lableText: localized(.backgroundAlpha),
                            onPress: { [weak self] in self?.backgroundAlpha() }),
            ColorInstrument(icon: Icons.brush.image(weight: .thin), lableText: localized(.backgroundColor),
                            onPress: { [weak self] in self?.backgroundColorChange() }),
            ColorInstrument(icon: Icons.cornerRadius.image(weight: .thin), lableText: localized(.backgroundCornerRadius),
                            onPress: { [weak self] in self?.cornerRadiusChange() }),
            ColorInstrument(icon: Icons.cross.image(weight: .thin), lableText: localized(.backgroundClearImage),
                            onPress: { [weak self] in self?.clearBackgroundImage() }),
            ColorInstrument(icon: Icons.save.image(weight: .thin), lableText: localized(.saveIcon),
                            onPress: { [weak self] in self?.saveToGallery() })
        ]
        
        self.instruments.append(contentsOf: instruments)
    }
    
    public func showIconsPicker() {
        slider?.animate(show: false)
        let block: (UIImage) -> () = { [weak self] newIcon in
            self?.icon?.image = newIcon
        }
        router.showIconsPicker(onSelectImage: block)
    }
    
    public func backgroundColorChange() {
        slider?.animate(show: false)

        let block: (UIColor) -> () = { [weak self] color in
            self?.backgroundColor!.backgroundColor = color
        }
        router.showColorPicker(onColorPicked: block)
    }
    
    public func clearBackgroundImage() {
        if backgroundImage?.image == nil {
            Notifications.shared.Show(RNSimpleView(text: localized(.backgroundClearNotification), icon: Icons.info.image(), iconColor: .systemBlue))
        }
        backgroundImage?.image = nil
       
    }
    
    public func backgroundImagePick() {
        slider?.animate(show: false)

        let block: (UIImage) -> () = { [weak self] newImage in
            self?.backgroundImage!.image = newImage
        }
        router.backgroundImagePicker(onSelectImage: block)
    }
    
    public func backgroundAlpha() {
        slider?.slider.value = self.saveBackgroundAlpha
        slider?.label.animatedTextChanging(time: 0.3, text: localized(.backgroundAlphaFull))
        slider?.animate(show: true)
        slider?.onSliderChange = { [weak self] val in
            self?.saveBackgroundAlpha = val
            self?.backgroundImage?.alpha = CGFloat(self!.saveBackgroundAlpha)
        }
    }
    
    public func iconColorChange() {
        slider?.animate(show: false)

        let block: (UIColor) -> () = { [weak self] color in
            self?.icon!.tintColor = color
        }
        router.showColorPicker(onColorPicked: block)
    }
    
    public func iconScaleChange() {
        slider?.slider.value = self.saveIconScale
        slider?.label.animatedTextChanging(time: 0.3, text: localized(.iconSizeFull))
        slider?.animate(show: true)
        slider?.onSliderChange = { [weak self] val in
            self?.saveIconScale = val
            self?.icon?.transform = CGAffineTransform(scaleX: CGFloat(self!.saveIconScale), y: CGFloat(self!.saveIconScale))
        }
    }
    public func cornerRadiusChange() {
        slider?.slider.value = self.saveBackgroundRound
        slider?.animate(show: true)
        slider?.label.animatedTextChanging(time: 0.3, text: localized(.backgroundCornerRadiusFull))
        slider?.onSliderChange = { [weak self] val in
            guard let self = self else { return }
            self.saveBackgroundRound = val
            self.backgroundColor!.layer.cornerRadius = CGFloat(self.saveBackgroundRound) * (self.backgroundColor!.frame.height/2)
        }
    }
    
    public func saveToGallery() {
        slider?.animate(show: false)

        backgroundColor!.isOpaque = true
        UIGraphicsBeginImageContext(backgroundColor!.frame.size)
        backgroundColor!.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let result = UIImage(cgImage: image!.cgImage!)
        UIImageWriteToSavedPhotosAlbum(result, router, #selector(router.saveImageAlert), nil)
    }
    
}
