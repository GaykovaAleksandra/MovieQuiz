import UIKit

final class AlertPresenter {
    
    static func showAlert(on viewController: UIViewController, with model: AlertModel) {
        let alertController = UIAlertController(title: model.title,
                                                message: model.message,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alertController.addAction(alertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
