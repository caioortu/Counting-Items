//
//  AppDelegate.swift
//  Counters
//
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        Networking(configuration: .ephemeral)
    }()
    
    private lazy var loaderURL = URL(string: baseURL + "/api/v1/counters")!
    private lazy var increaseURL = URL(string: baseURL + "/api/v1/counter/inc")!
    private lazy var decreaseURL = URL(string: baseURL + "/api/v1/counter/dec")!
    private lazy var creatorURL = URL(string: baseURL + "/api/v1/counter")!
    
    private lazy var userDefaults: UserDefaults = .standard
    
    private lazy var loader: CounterLoader = {
        RemoteCounterLoader(url: loaderURL, client: httpClient)
    }()
    
    private lazy var creator: CounterCreator = {
        RemoteCounterCreator(url: creatorURL, client: httpClient)
    }()
    
    private lazy var increaseOperator: CounterOperator = {
        RemoteCounterOperator(url: increaseURL, client: httpClient)
    }()
    
    private lazy var decreaseOperator: CounterOperator = {
        RemoteCounterOperator(url: decreaseURL, client: httpClient)
    }()
    
    private lazy var navigationController = UINavigationController(
        rootViewController: CountersUIComposer.composedWith(
            loader: loader,
            increaseOperator: increaseOperator,
            decreaseOperator: decreaseOperator,
            addAction: showAddCounter
        )
    )
    
    convenience init(httpClient: HTTPClient, userDefaults: UserDefaults) {
        self.init()
        self.httpClient = httpClient
        self.userDefaults = userDefaults
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        guard !isUnitTesting() else { return false }
        
        window = UIWindow()
        configureWindow()
        setupAppearance()
        
        return true
    }
    
    func configureWindow() {
        window?.rootViewController = rootViewController()
        window?.makeKeyAndVisible()
    }
    
    private func rootViewController() -> UIViewController {
        userDefaults.welcomeCompleted ? navigationController : WelcomeUIComposer.compose(primaryAction: welcomeContinue)
    }
    
    private func welcomeContinue() {
        window?.rootViewController = navigationController
        userDefaults.welcomeCompleted = true
    }
    
    private func showAddCounter() {
        let addCounterViewController = AddCounterUIComposer.composedWith(creator: creator)
        navigationController.present(
            UINavigationController(rootViewController: addCounterViewController),
            animated: true
        )
    }
    
    private func setupAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .navigationBar

        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        
        window?.tintColor = .accentColor
    }
    
    private func isUnitTesting() -> Bool {
        // Short-circuit starting app if running unit tests
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        
        return isUnitTesting
    }
}
