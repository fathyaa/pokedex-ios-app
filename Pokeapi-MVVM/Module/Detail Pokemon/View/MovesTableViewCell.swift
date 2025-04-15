//
//  MovesTableViewCell.swift
//  Pokeapi-MVVM
//
//  Created by Fathya on 20/03/25.
//

import UIKit

class MovesTableViewCell: UITableViewCell {

    static let identifier = "MovesTableViewCell"
    @IBOutlet weak var moveName: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var effectLabel: UILabel!
    @IBOutlet weak var moveView: UIView!{
        didSet{
            moveView.layer.cornerRadius = 8
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(moveData: MoveModel){
        
        moveName.text = moveData.name
        accuracyLabel.text = "+\(moveData.detail?.accuracy ?? 0)"
        effectLabel.text = moveData.detail?.effectString ?? ""
    }
    
}
