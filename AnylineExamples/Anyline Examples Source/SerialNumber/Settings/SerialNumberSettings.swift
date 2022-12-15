import Foundation
import Anyline

//this needs to be removed from BasicSettingsViewController
enum IncludeSetting : Int, CaseIterable {
    case numbersAndCapitals,numbersOnly,capitalsOnly
    static func getSetting(_ section: Int) -> IncludeSetting {
        return self.allCases[section]
    }
}
 
@objc class SerialNumberSettings : NSObject {
    static let isUsingAdvancedCharacterSettingsKey = "isUsingAdvancedCharacterSettings"
    static let advancedCharacterSettingsRegexKey = "AdvancedCharacterSettingsRegex"
    static let advancedCharacterSettingsAllowlistKey = "AdvancedCharacterSettingsAllowlist"
    static let basicCharacterSettingsMinimumCharactersKey = "basicCharacterSettingsMinimumCharacters"
    static let basicCharacterSettingsMaximumCharactersKey = "basicCharacterSettingsMaximumCharacters"
    static let basicCharacterSettingsIncludeSettingsKey = "basicCharacterSettingsIncludeSettings"
    static let basicCharacterSettingsExcludedCharactersKey = "basicCharacterSettingsExcludedCharacters"
    @objc static let shared = SerialNumberSettings()
    
    public enum CharacterSetting {
        case basic(minCharacters:UInt,maxCharacters:UInt,includeSetting:IncludeSetting, excludedCharacters:String?)
        case advanced(regularExpression:String?, allowlist:String?)
    }
    
    override init() {
        super.init()
        UserDefaults.standard.register(defaults: [
            Self.isUsingAdvancedCharacterSettingsKey : false,
            Self.advancedCharacterSettingsRegexKey : "[A-Z0-9]{4,}",
            Self.basicCharacterSettingsMinimumCharactersKey : 4,
            Self.basicCharacterSettingsMaximumCharactersKey : 20,
            Self.basicCharacterSettingsIncludeSettingsKey : IncludeSetting.numbersAndCapitals.rawValue
        ])
    }
    
    public var characterSetting:CharacterSetting {
        set {
            //set in userdefaults, unless it's an invalid advanced setting
            //we don't touch the defaults stored for the setting they're not using, as they might want to switch between them.
            let defaults = UserDefaults.standard
            switch (newValue) {
            case .basic(minCharacters: let minCharacters, maxCharacters: let maxCharacters, includeSetting: let includeSetting, excludedCharacters: let excludedCharacters):
                defaults.set(false, forKey: Self.isUsingAdvancedCharacterSettingsKey)
                defaults.set(minCharacters, forKey: Self.basicCharacterSettingsMinimumCharactersKey)
                defaults.set(maxCharacters, forKey: Self.basicCharacterSettingsMaximumCharactersKey)
                defaults.set(includeSetting.rawValue, forKey: Self.basicCharacterSettingsIncludeSettingsKey)
                defaults.set(excludedCharacters, forKey: Self.basicCharacterSettingsExcludedCharactersKey)
            case .advanced(regularExpression: let regularExpression, allowlist: let allowlist):
                defaults.set(true, forKey: Self.isUsingAdvancedCharacterSettingsKey)
                defaults.set(regularExpression, forKey: Self.advancedCharacterSettingsRegexKey)
                defaults.set(allowlist, forKey: Self.advancedCharacterSettingsAllowlistKey)
            }
            
        }
        get {
            //get from user defaults
            if (self.isUsingAdvancedCharacterSettings) {
                return CharacterSetting.advanced(
                    regularExpression:self.regex,
                    allowlist: self.allowlist
                )
            } else {
                return CharacterSetting.basic(
                    minCharacters: self.minCharacters,
                    maxCharacters: self.maxCharacters,
                    includeSetting: self.includeSetting,
                    excludedCharacters: self.excludedCharacters
                )
            }
        }
    }
    
    /* We still save any basic and advanced settings that the user has set, even if they are only using one of them, so they can switch between them and not lose anything. So here you can directly access those settings. You should only use characterSetting to get the actual setting, but use these to populate the edit screens. */
    public var minCharacters:UInt {
        get {
            return UInt(UserDefaults.standard.integer(forKey: Self.basicCharacterSettingsMinimumCharactersKey))
        }
    }
    
    public var maxCharacters:UInt {
        get {
            return UInt(UserDefaults.standard.integer(forKey: Self.basicCharacterSettingsMaximumCharactersKey))
        }
    }
    
    public var includeSetting:IncludeSetting {
        get {
            return IncludeSetting(rawValue: UserDefaults.standard.integer(forKey:Self.basicCharacterSettingsIncludeSettingsKey)) ?? .numbersAndCapitals
        }
    }
    
    public var excludedCharacters:String? {
        get {
            return UserDefaults.standard.string(forKey: Self.basicCharacterSettingsExcludedCharactersKey)
        }
    }
    
    public var regex:String? {
        get {
            return UserDefaults.standard.string(forKey: Self.advancedCharacterSettingsRegexKey)
        }
    }
    
    public var allowlist:String? {
        get {
            return UserDefaults.standard.string(forKey: Self.advancedCharacterSettingsAllowlistKey)
        }
    }
    
    public var isUsingAdvancedCharacterSettings:Bool {
        get {
            return UserDefaults.standard.bool(forKey: Self.isUsingAdvancedCharacterSettingsKey)
        }
        set {
            //this will use whatever the previously-saved (or default) settings are for the advanced or basic settings. Usually you would set characterSetting with the full configuration instead; this is for when the user switches between basic and advanced settings without editing them.
            UserDefaults.standard.set(newValue, forKey: Self.isUsingAdvancedCharacterSettingsKey)
        }
    }
    
    func resetBasicSettings() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Self.basicCharacterSettingsMinimumCharactersKey)
        defaults.removeObject(forKey: Self.basicCharacterSettingsMaximumCharactersKey)
        defaults.removeObject(forKey: Self.basicCharacterSettingsIncludeSettingsKey)
        defaults.removeObject(forKey: Self.basicCharacterSettingsExcludedCharactersKey)
    }
    
    func resetAdvancedSettings() {
        UserDefaults.standard.removeObject(forKey: Self.advancedCharacterSettingsRegexKey)
        UserDefaults.standard.removeObject(forKey: Self.advancedCharacterSettingsAllowlistKey)
    }

    func reset() {
        //reset to default settings by removing any values we've set
        UserDefaults.standard.removeObject(forKey: Self.isUsingAdvancedCharacterSettingsKey)
        resetAdvancedSettings()
        resetBasicSettings()
    }
    
    @objc public func toOCRConfig() -> ALOcrConfig {
        let ocrConfig = ALOcrConfig()
        ocrConfig.scanMode = .scanModeAuto()
        switch characterSetting {
        case .basic(minCharacters: let minCharacters, maxCharacters: let maxCharacters, includeSetting: let includeSetting, excludedCharacters: let excludedCharacters):
            switch includeSetting {
            case .numbersAndCapitals:
                ocrConfig.charWhitelist = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                ocrConfig.validationRegex = "[A-Z0-9]{\(minCharacters),\(maxCharacters)}"
            case .numbersOnly:
                ocrConfig.charWhitelist = "0123456789"
                ocrConfig.validationRegex = "[0-9]{\(minCharacters),\(maxCharacters)}"
            case .capitalsOnly:
                ocrConfig.charWhitelist = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                ocrConfig.validationRegex = "[A-Z]{\(minCharacters),\(maxCharacters)}"
            }
            ocrConfig.charWhitelist = ocrConfig.charWhitelist?.filter( { !(excludedCharacters?.contains($0) ?? false) })
        case .advanced(regularExpression: let regularExpression, allowlist: let allowlist):
            ocrConfig.charWhitelist = allowlist
            ocrConfig.validationRegex = regularExpression
        }
        return ocrConfig
    }
}
