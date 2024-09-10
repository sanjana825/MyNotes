//
//  NotesCollectionViewCell.swift
//  MyNotes
//
//  Created by Sanjana on 06/08/24.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IB Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var noteBody: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
