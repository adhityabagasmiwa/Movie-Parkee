//
//  ChipCollectionViewCell.swift
//  Parkee
//
//  Created by Adhitya Bagas on 01/09/23.
//

import UIKit

class ChipCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    private func setupUI() {
        mainView.layer.cornerRadius = 12
        mainView.clipsToBounds = true
    }
    
    func setData(_ name: String) {
        titleLabel.text = name
    }
}
