//
//  MovieTableViewCell.swift
//  iOSTestBS23
//
//  Created by Md. Shahed Mamun on 20/10/22.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var customImageView: UIImageView!{
        didSet{
            customImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.numberOfLines = 0
            titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        }
    }
    @IBOutlet weak var detailsLabel: UILabel!{
        didSet{
            detailsLabel.numberOfLines = 0
            detailsLabel.font = .systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    var representedIdentifier: String = ""
    var image: UIImage? {
        didSet {
            customImageView.image = image
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
