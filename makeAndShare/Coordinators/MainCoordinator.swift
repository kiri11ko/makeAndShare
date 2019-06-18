//
//  MainCoordinator.swift
//  makeAndShare
//
//  Created by Кирилл Лукьянов on 17/06/2019.
//  Copyright © 2019 Кирилл Лукьянов. All rights reserved.
//

import UIKit


final class MainCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showMainModule()
    }
    
    private func showMainModule() {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(StartViewController.self)
        
        controller.onPhoto = { [weak self] in
            self?.showFotoModule()
        }
        controller.onTakePicture = { [weak self] image in
            self?.showResultImageModule(image)
        }

        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showFotoModule() {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(PhotoViewController.self)
        controller.onTakePicture = { [weak self] image in
            self?.showResultImageModule(image)
        }
        rootController?.pushViewController(controller, animated: true)
    }
    
    private func showResultImageModule(_ image: UIImage) {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(ResultFotoViewController.self)
        controller.image = image
        rootController?.pushViewController(controller, animated: true)
    }
    
}
