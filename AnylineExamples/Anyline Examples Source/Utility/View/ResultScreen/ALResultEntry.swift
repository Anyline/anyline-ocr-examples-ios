import Foundation
import UIKit

@objc
class ALResultEntry: NSObject {

    enum DictionaryKeys: String {
        case title = "title"
        case value = "value"
        case isAvailable = "isAvailable"
        case shouldSpellOutValue = "shouldSpellOutValue"
        case isMandatory = "isMandatory"
    }

    enum Constants {
        static let resultDataNotAvailableStr = "Not available"
    }

    /// The name of the result to display, e.g. 'Surname'
    /// or 'Voucher code'
    @objc var title: String = ""

    /// The result value, e.g. 'Dent' or 'ZZ9PZA'
    @objc var value: String = Constants.resultDataNotAvailableStr

    /// ???
    @objc var isAvailable: Bool = false

    /// Whether the value is a code potentially made up of
    /// letters and numbers rather than a word, number, or
    /// date. When this is YES, the value will be displayed in
    /// a monospaced font (to better distinguish e.g. 0/O, 1/I),
    /// and will be spelled out character-by-character in
    /// VoiceOver instead of read normally.
    @objc var shouldSpellOutValue: Bool = false

    /// This BOOL value will be used for our result and history
    /// screen. This can be used to filter the most important
    /// result fields. If isMandatory is set to YES, it will be
    /// always displayed.If it's set to NO, it will not show in
    /// every screen. Defaults to YES
    @objc var isMandatory: Bool = true

    @objc
    init(title: String? = nil,
         value: String? = nil,
         shouldSpellOutValue: Bool = false,
         isMandatory: Bool = true) {

        self.title = title ?? ""

        if let value = value, value.count > 0 {
            self.value = value
            self.isAvailable = true
        }

        self.shouldSpellOutValue = shouldSpellOutValue
        self.isMandatory = isMandatory
    }

    @objc
    init(withDictionary dict: [String: Any]) {
        if let val = dict[DictionaryKeys.title.rawValue] as? String {
            self.title = val
        }

        if let val = dict[DictionaryKeys.value.rawValue] as? String {
            self.value = val
        }

        if let val = dict[DictionaryKeys.isAvailable.rawValue] as? Bool {
            self.isAvailable = val
        }

        if let val = dict[DictionaryKeys.shouldSpellOutValue.rawValue] as? Bool {
            self.shouldSpellOutValue = val
        }

        if let val = dict[DictionaryKeys.isMandatory.rawValue] as? Bool {
            self.isMandatory = val
        }
    }

    @objc
    convenience init(title: String?, value: String?, shouldSpellOutValue: Bool) {
        self.init(title: title, value: value, shouldSpellOutValue: shouldSpellOutValue, isMandatory: true)
    }

    @objc
    convenience init(title: String?, value: String?) {
        self.init(title: title, value: value, shouldSpellOutValue: false, isMandatory: true)
    }

    @objc
    convenience init(title: String?, value: String?, isMandatory: Bool) {
        self.init(title: title, value: value, shouldSpellOutValue: false, isMandatory: isMandatory)
    }

    // ACO (copied from old ObjC version) - isAvailable is not used, this must be incorrect
    @objc
    convenience init(title: String?, value: String?, isAvailable: Bool) {
        self.init(title: title, value: value, shouldSpellOutValue: false, isMandatory: true)
    }


    @objc
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()

        dict[DictionaryKeys.title.rawValue] = self.title
        dict[DictionaryKeys.value.rawValue] = self.value
        dict[DictionaryKeys.isAvailable.rawValue] = self.isAvailable
        dict[DictionaryKeys.isMandatory.rawValue] = self.isMandatory
        dict[DictionaryKeys.shouldSpellOutValue.rawValue] = self.shouldSpellOutValue

        return dict
    }

    @objc
    static func with(title: String, value: String) -> ALResultEntry {
        return .init(title: title, value: value)
    }

    @objc
    static func with(title: String, value: String, shouldSpellOutValue: Bool) -> ALResultEntry {
        return .init(title: title, value: value, shouldSpellOutValue: shouldSpellOutValue)
    }

    @objc
    static func JSONStringFromList(_ list: [ALResultEntry]) -> String? {
        return list.JSONStringFromResultData
    }
}

extension Array where Element == ALResultEntry {
    var JSONStringFromResultData: String? {
        let maps: [[String: Any]] = self.map { $0.toDictionary() }
        let dict = ["result": maps]
        if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
            return .init(data: data, encoding: .utf8)
        }
        return nil
    }
}
