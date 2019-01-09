//
//  PersonTableViewCell.swift
//  Prepopulate
//
//  Created by Soulchild on 09/01/2019.
//  Copyright © 2019 fluffy. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var relationshipLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    // Use static variable so that no need create a new instance of date formatter for every cell
    private static let dateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureWith(person : Person) {
        self.nameLabel.text = person.name
        self.raceLabel.text = String(describing: person.raceEnum)
        self.moneyLabel.text = "$ \(person.money)"
        
        if(person.married){
            self.relationshipLabel.text = "Married"
        } else {
            self.relationshipLabel.text = "Single"
        }
        
        
        if let birthday = person.birthday {
            self.birthdayLabel.text = PersonTableViewCell.dateformatter.string(from: birthday)
        } else {
            self.birthdayLabel.text = "Unknown"
        }
    }
    
}
