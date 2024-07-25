import Foundation
import Anyline

enum VerticalAlignment : Int, CaseIterable {
    static var alignmentStringArray = ["top_half", "center", "bottom_half"]
    case top,center,bottom
    static func getRow(_ row: Int) -> VerticalAlignment {
        return self.allCases[row]
    }
}

@objc class CutoutSettings : NSObject {
    
    @objc static let shared = CutoutSettings()
    
    static let kcornerRadiusKey = "cornerRadius"
    static let kMaxWidthPercentKey = "maxWidthPercent"
    static let kRatioFromSizeKey = "ratioFromSize"
    static let kAlignmentKey = "alignment"
    static let maxCornerRadius = 100 //in case we change this to 50

    override init() {
        super.init()
        UserDefaults.standard.register(defaults: [
            Self.kcornerRadiusKey : 4,
            Self.kMaxWidthPercentKey : 67,
            Self.kRatioFromSizeKey : 5,
            Self.kAlignmentKey : VerticalAlignment.top.rawValue
        ])
    }
    
    var cornerRadius:Int {
        get {
            UserDefaults.standard.integer(forKey: Self.kcornerRadiusKey )
        }
        set {
            UserDefaults.standard.set(newValue.clamped(to: 1...CutoutSettings.maxCornerRadius), forKey: Self.kcornerRadiusKey)
        }
    }
    
    var maxWidthPercent:Int {
        get {
            UserDefaults.standard.integer(forKey: Self.kMaxWidthPercentKey )
        }
        set {
            UserDefaults.standard.set(newValue.clamped(to: 1...100), forKey: Self.kMaxWidthPercentKey)
        }
    }
    
    var ratioFromSize:Int {
        get {
            UserDefaults.standard.integer(forKey: Self.kRatioFromSizeKey )
        }
        set {
            UserDefaults.standard.set(newValue.clamped(to: 1...10), forKey: Self.kRatioFromSizeKey)
        }
    }
    
    var alignment:VerticalAlignment {
        get {
            return VerticalAlignment(rawValue: UserDefaults.standard.integer(forKey:Self.kAlignmentKey)) ?? .center
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Self.kAlignmentKey)
        }
    }
    
    func reset() {
        //reset to default settings by removing any values we've set
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Self.kcornerRadiusKey)
        defaults.removeObject(forKey: Self.kMaxWidthPercentKey)
        defaults.removeObject(forKey: Self.kRatioFromSizeKey)
        defaults.removeObject(forKey: Self.kAlignmentKey)
    }

    @objc func customizedCutoutConfig(from cutoutConfig: ALCutoutConfig) -> Dictionary <String, Any> {
        var cutoutJSONSString = cutoutConfig.asJSONString() as NSString

        var tempCutoutConfigDictionary = cutoutJSONSString.asJSONObject() as? Dictionary <String, Any> ?? [:]
        
        tempCutoutConfigDictionary[CutoutSettings.kcornerRadiusKey] = cornerRadius
        tempCutoutConfigDictionary[CutoutSettings.kMaxWidthPercentKey] = String(maxWidthPercent)
        tempCutoutConfigDictionary[CutoutSettings.kRatioFromSizeKey] = ["width" : ratioFromSize, "height" : 1]
        tempCutoutConfigDictionary[CutoutSettings.kAlignmentKey] = VerticalAlignment.alignmentStringArray[alignment.rawValue]

        return tempCutoutConfigDictionary;
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
