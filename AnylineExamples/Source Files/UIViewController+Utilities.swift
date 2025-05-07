
import Foundation

extension UIViewController {
    
    func showErrorAlert(_ message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert: UIAlertController = .init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .default, handler: handler))
        self.navigationController?.present(alert, animated: true)
    }
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 40, y: self.view.frame.size.height-120, width: self.view.frame.size.width - 80, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.numberOfLines = 0
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {_ in 
            toastLabel.removeFromSuperview()
        })
    }
}
