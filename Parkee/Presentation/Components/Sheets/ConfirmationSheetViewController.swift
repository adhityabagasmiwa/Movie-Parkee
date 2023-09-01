//
//  ConfirmationSheetViewController.swift
//  Parkee
//
//  Created by Adhitya Bagas on 01/09/23.
//

import UIKit

class ConfirmationSheetViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var onPressReloadPage: (() -> Void)?
    var isSuccess: Bool = false
    var setTitleLabel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setContent()
    }
    
    func setContent() {
        imageView.image = UIImage(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
        titleLabel.text = setTitleLabel
    }
    
    @IBAction func onPressReloadPageButton(_ sender: Any) {
        onPressReloadPage?()
    }
}
