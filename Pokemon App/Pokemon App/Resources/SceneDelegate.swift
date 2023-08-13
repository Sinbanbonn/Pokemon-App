import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var rootCoordinator: RootCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let navigationController: UINavigationController = UINavigationController()
        window?.rootViewController = navigationController
        rootCoordinator = RootCoordinator(router: AppRouter(rootController: navigationController))
        rootCoordinator?.start()
        window?.makeKeyAndVisible()
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        try! CoreDataManager.shared.context.save()
    }

}
