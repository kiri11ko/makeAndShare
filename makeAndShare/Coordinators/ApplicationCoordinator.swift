//
//  ApplicationCoordinator.swift
//  makeAndShare
//
//  Created by Кирилл Лукьянов on 17/06/2019.
//  Copyright © 2019 Кирилл Лукьянов. All rights reserved.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    override func start() {
            toMain()
    }
    private func toMain() {
            let coordinator = MainCoordinator()
            coordinator.onFinishFlow = { [weak self, weak coordinator] in
                self?.removeDependency(coordinator)
                self?.start()
            }
        addDependency(coordinator)
        coordinator.start()
    }

}
