//
//  ImageCollectionViewCell.swift
//  ramaxTest
//
//  Created by Кирилл Лукьянов on 03/04/2019.
//  Copyright © 2019 Кирилл Лукьянов. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    var moduleImage = UIImageView()
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            moduleImage.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        moduleImage.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        moduleImage.contentMode = .scaleAspectFit
        moduleImage.isUserInteractionEnabled = false
        self.addSubview(moduleImage)
    }
    
    func iconFrame() {
        let iconSideLinght: CGFloat = 100
        let iconSize = CGSize(width: iconSideLinght, height: iconSideLinght)
        let iconOrigin = CGPoint(x: bounds.midX - iconSideLinght / 2, y: bounds.midY - iconSideLinght / 2)
        moduleImage.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconFrame()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
