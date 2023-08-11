//
//  AppRouter.swift
//  Pokemon App
//
//  Created by Андрей Логвинов on 8/9/23.
//

import Foundation

import UIKit

typealias RouterCompletions = [UIViewController : CompletionBlock]

final class AppRouter: NSObject {
    // MARK: - Private variables
    fileprivate weak var rootController: UINavigationController?
    
    fileprivate var completions: RouterCompletions
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        completions = [:]
    }
    
    var toPresent: UIViewController? {
        return rootController
    }
}

// MARK: - Private methods
private extension AppRouter {
    func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

extension AppRouter: Routable {
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }
    
    func presentOnRoot(_ module: Presentable?) {
        guard let controller = module?.toPresent else { return }
        rootController?.parent?.present(controller, animated: true, completion: nil)
    }
    
    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent else { return }
        rootController?.visibleViewController?.present(controller, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: CompletionBlock?) {
        guard
            let controller = module?.toPresent,
            !(controller is UINavigationController)
            else { assertionFailure("⚠️Deprecated push UINavigationController."); return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        rootController?.pushViewController(controller, animated: animated)
    }
    
}
