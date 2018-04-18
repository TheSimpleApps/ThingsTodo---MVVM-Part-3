//
//  TodoItemCell.swift
//  ThingsTodo
//
//  Created by Karamjeet Singh on 17/04/18.
//  Copyright © 2018 TheSimpleApps@gmail.com. All rights reserved.
//

import UIKit

class TodoItemCell: UITableViewCell {

    @IBOutlet weak var text_Label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withVieModel viewModel: ToDoItemPresentable) -> (Void) {
        text_Label.text = "\(viewModel.id!) \(viewModel.textValue!)"
    }

}
