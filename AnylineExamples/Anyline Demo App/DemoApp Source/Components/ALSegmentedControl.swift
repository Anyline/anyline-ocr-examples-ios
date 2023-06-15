import UIKit

// https://stackoverflow.com/a/60260259
class ALSegmentedControl: UISegmentedControl {
    // Captures existing selected segment on touchesBegan.
    var oldValue: Int!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.oldValue = self.selectedSegmentIndex
        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if self.oldValue == self.selectedSegmentIndex {
            self.sendActions(for: .valueChanged)
        }
    }
}
