import Foundation

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    private var viewController: UIViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        let licenseKey = LicenseKey.developerExamples
        do {
            try AnylineSDK.setup(withLicenseKey: licenseKey, 
                                 cacheConfig: .offlineLicenseCachingEnabled(),
                                 wrapperConfig: nil)
        } catch {
            print("Error initializing Anyline with license key \(licenseKey): \(error.localizedDescription)")
        }

        // `licenseExpirationDate` can only return a non-null answer if called after `setupWithLicenseKey:error:`
        // and it returns no error
        let humanReadableLicenseExpiryDate = AnylineSDK.licenseExpirationDate()
        print("This Anyline license expires on \(humanReadableLicenseExpiryDate)")

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.viewController = PrototypesViewController()
        self.window?.rootViewController = UINavigationController(rootViewController: self.viewController)
        self.window?.makeKeyAndVisible()
        return true
    }
}
