//
//  AnnotationsCollectionViewController.swift
//  hackerbooks2.0
//
//  Created by fran on 30/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import UIKit
import CoreData
class AnnotationsCollectionViewController: CoreDataCollectionViewController {
    let cellId = "AnnotationCell"
    let pdf : Pdf
    
    init(pdf : Pdf,fetchedResultsController fc: NSFetchedResultsController<NSFetchRequestResult>, layout: UICollectionViewLayout) {
        self.pdf = pdf
        super.init(fetchedResultsController: fc, layout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.backgroundColor = UIColor.white
        
 

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "AnnotationCollectionViewCell", bundle: Bundle.main)
        self.collectionView?.register(cellNib, forCellWithReuseIdentifier: cellId)
           let addNoteButton =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        let mapButton = UIBarButtonItem(title: "Map", style: .done, target: self, action: #selector(showMap))
        self.navigationItem.rightBarButtonItems = [addNoteButton,mapButton]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNote(){
        
        let _  = Annotation(pdf: self.pdf, inContext: self.pdf.managedObjectContext!)
        
    }
    
    func showMap(){
        
        let mapVC = NotesMapViewController(annotations: fetchedResultsController?.fetchedObjects as! [Annotation])
        self.navigationController?.pushViewController(mapVC, animated: true)
        
    }
  

}
//MARK: - DataSource
extension AnnotationsCollectionViewController{
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AnnotationCollectionViewCell
        let annotation = self.fetchedResultsController?.object(at: indexPath) as! Annotation
        cell.text.text = annotation.text
        cell.imageView.image = annotation.photo?.image
        
        return cell
    }

    
}

//MARK: - CollectionView Delegate

extension AnnotationsCollectionViewController{
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let annotation = self.fetchedResultsController?.object(at: indexPath) as! Annotation
        let annotationVC = AnnotationViewController(annotation:annotation)
        
        self.navigationController?.pushViewController(annotationVC, animated: true)
    }
    
}

extension AnnotationsCollectionViewController : UICollectionViewDelegateFlowLayout{
    
    @objc(collectionView:layout:sizeForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width/4, height: 80)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
    }
    
}
