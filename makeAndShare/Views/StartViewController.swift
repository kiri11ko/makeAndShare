//
//  ViewController.swift
//  makeAndShare
//
//  Created by Кирилл Лукьянов on 17/06/2019.
//  Copyright © 2019 Кирилл Лукьянов. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, RemouteControl {
    var alert: UIAlertController!
    lazy var collectionView: UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        let collectionViewFrame = CGRect(x: 10, y: 10, width: view.frame.width - 40, height: 200)
        let collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.dataSource = self.dataProvider
        collectionView.delegate = self.dataProvider
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    lazy var dataProvider: ColletionViewDataProvider = {
        let dataProvider = ColletionViewDataProvider()
        dataProvider.delegate = self
        return dataProvider
    }()
    
    var onPhoto: (() -> Void)?
    var onTakePicture: ((UIImage) -> Void)?
//    var imagePicker = UIImagePickerController()
    func control(image: UIImage) {
        alert.dismiss(animated: false, completion: nil)
        onTakePicture?(image)
    }

    @IBAction func makeFoto(_ sender: Any) {
        onPhoto?()
    }
    @IBAction func shareFoto(_ sender: Any) {
        
        showPickerInActionSheet()
    }
    
    func showPickerInActionSheet() {
        
        let title = ""
        let message = "\n\n\n\n\n\n\n\n\n\n"
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.isModalInPopover = true
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.view.addSubview(collectionView)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func cancelSelection(){
        self.dismiss(animated: true, completion: nil)
    }

        
    
}

extension StartViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = extractImage(from: info) else { return }
        picker.dismiss(animated: true, completion: { () -> Void in
            self.onTakePicture?(image)
        })
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        } else {
            return nil
        }
    }
    
    
}
