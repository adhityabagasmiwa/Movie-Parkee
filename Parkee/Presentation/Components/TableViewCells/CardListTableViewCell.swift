//
//  CardListTableViewCell.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import UIKit
import Kingfisher

class CardListTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var onPressFavorite: (() -> Void)?
    var onPressCard: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ data: Movie) {
        posterImageView.layer.cornerRadius = 12
        posterImageView.clipsToBounds = true
        
        mainView.layer.cornerRadius = 8
        mainView.clipsToBounds = true
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor.secondaryLabel.cgColor

        let url = URL(string: ApiURL.imageBaseURL.rawValue + (data.posterPath ?? ""))
        posterImageView.kf.setImage(with: url)
        
        titleLabel.text = data.title
        ratingLabel.text = "\(data.voteAverage)/10 TMDb"
        
        let hasFavorite = data.isFavorite ?? false
        favoriteButton.setTitle(hasFavorite ? "Remove Favorite" : "Add Favorite", for: .normal)
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height / 2
    }
    
    @IBAction func onPressCardButton(_ sender: Any) {
        onPressCard?()
    }
    
    @IBAction func onPressFavoriteButton(_ sender: Any) {
        onPressFavorite?()
    }
}
