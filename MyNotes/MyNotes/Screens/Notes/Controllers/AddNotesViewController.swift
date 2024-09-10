//
//  AddNotesViewController.swift
//  MyNotes
//
//  Created by Sanjana on 09/08/24.
//

import UIKit

class AddNotesViewController: UIViewController {
    
    let manager = DatabaseManager()
    var noteEntity : NoteEntity?
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    // MARK: - VC life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    
    //MARK: - Action
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !(title.isEmpty) else{
            alert(message: "Please enter a title before proceeding.")
            return
        }
        guard let noteBody = notesTextView.text, (notesTextView.textColor != UIColor.lightGray), !(noteBody.isEmpty) else{
            alert(message: "Please enter a note before proceeding.")
            return
        }
        let date = Date()
        let note = NoteModel(noteTitle: title, noteBody: noteBody, date: date)
        
        //update note
        if let noteEntity{
            manager.updateNote(note, noteEntity: noteEntity )
        }
        else{
            //save note
            manager.addNote(note)
        }
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TextField Delegates
extension AddNotesViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

// MARK: - TextView Delegates

extension AddNotesViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor ==  UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            notesTextView.text = "Note"
            notesTextView.textColor = UIColor.lightGray
        }
    }
}

// MARK: - Set up methods

extension AddNotesViewController{
    func displayDate(){
        let date = Date()
        dateLabel.text = date.getFormattedDate(format: "MMM d, yyyy")
    }
    func setUpData(){
        displayDate()
        notesTextView.delegate = self
        titleTextField.delegate = self
        if let noteEntity{
            titleTextField.text = noteEntity.noteTitle
            notesTextView.text = noteEntity.noteBody
            dateLabel.text = noteEntity.date?.getFormattedDate(format: "MMM d, yyyy")
        }
        else{
            notesTextView.text = "Note"
            notesTextView.textColor = UIColor.lightGray
        }
    }
}

// MARK: - Alert method

extension UIViewController{
    func alert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

