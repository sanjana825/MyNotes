//
//  NotesViewController.swift
//  MyNotes
//
//  Created by Sanjana on 25/07/24.
//

import UIKit

class NotesViewController: UIViewController {
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    let manager = DatabaseManager()
    var notes : [NoteEntity] = []
    
    //MARK: - Outlets
    
    @IBOutlet weak var notesCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noNotesView: UIView!
    
    // MARK: - VC life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        notes = manager.fetchNotes()
        notesCollectionView.reloadData()
        displayNoNotesView()
    }
}

// MARK: - CollectionView Delegates & DataSource

extension NotesViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCollectionViewCell", for: indexPath) as! NotesCollectionViewCell
        cell.titleLabel.text = notes[indexPath.row].noteTitle
        cell.noteBody.text =  notes[indexPath.row].noteBody
        cell.date.text = notes[indexPath.row].date?.getFormattedDate(format: "MMM d, yyyy")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let addNotesVC = storyboard?.instantiateViewController(identifier: "AddNotesViewController") as! AddNotesViewController
        addNotesVC.noteEntity = notes[indexPath.row]
        navigationController?.pushViewController(addNotesVC, animated: true)
    }
}

// MARK: - Gesture Recognizer Delegate

extension NotesViewController: UIGestureRecognizerDelegate{
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let press = longPressGesture.location(in: self.notesCollectionView)
        let indexPath = self.notesCollectionView.indexPathForItem(at: press)
        if let indexPath{
            if longPressGesture.state == UIGestureRecognizer.State.began {
                
                //Alert
                let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this note", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive){ _ in
                    //Delete note
                    self.manager.deleteNote(noteEntity: self.notes[indexPath.row] )
                    self.notes.remove(at: indexPath.row)   //deletes data from the notes array
                    self.notesCollectionView.reloadData()
                    self.displayNoNotesView()
                }
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                present(alert, animated: true)
            }
        }
    }
}

// MARK: - SearchBar Delegates

extension NotesViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            notes = manager.fetchNotes()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            notesCollectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            notes =  manager.searchNote(title: text)
            notesCollectionView.reloadData()
        }
        self.searchBar.endEditing(true)
    }
}

// MARK: - Set up methods

extension NotesViewController{
    func setUp(){
        setUpCollectionView()
        longPressGesture()
        searchBar.delegate = self
        notes = manager.fetchNotes()
        displayNoNotesView()
    }
    
    func setUpCollectionView(){
        notesCollectionView.register(UINib(nibName: "NotesCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "NotesCollectionViewCell")
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (screenWidth - 30)/2, height: screenWidth/3)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        notesCollectionView.collectionViewLayout = layout
    }
    
    func longPressGesture(){
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        self.notesCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    func displayNoNotesView(){
        if notes.isEmpty{
            noNotesView.isHidden = false
        }
        else{
            noNotesView.isHidden = true
        }
    }
}


