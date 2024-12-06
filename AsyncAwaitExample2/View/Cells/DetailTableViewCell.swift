//
//  DetailTableViewCell.swift
//  AsyncAwaitExample2
//
//  Created by Dionicio Cruz Velázquez on 12/2/24.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var abilityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(with pokemon: DisplayablePokemon) {
        nameLabel.text = "Name: \(pokemon.name)"
        typeLabel.text = "Type: \(pokemon.type)"
        abilityLabel.text = "Ability: \(pokemon.ability)"
    }
}
