//
//  BooksViewController.swift
//  hackerbooks2.0
//
//  Created by fran on 17/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import UIKit
import CoreData
class BooksViewController: CoreDataTableViewController {

    typealias bookHandler = (UIImage) ->()
    
    func downloadCover(url : URL,completion handler: @escaping bookHandler){
        
        DispatchQueue.global(qos: .userInitiated).async {
            let photoData = try! Data(contentsOf: url)
            let image = UIImage(data:photoData)!
            DispatchQueue.main.async {
                handler(image)
            }
        }
        
    }
  
}

//MARK: - Lifecycle

extension BooksViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hackerbooks"
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "BookCell")
    }
    
    
    
}


//MARK: - DataSource
extension BooksViewController{
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        return fetchedResultsController?.sections?[section].name.capitalized
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> BookTableViewCell {
        
        let cellId = "BookCell"
        
        let bookTag = fetchedResultsController?.object(at: indexPath) as! BookTag
        let book = bookTag.book
        let cell : BookTableViewCell =
            tableView.dequeueReusableCell(withIdentifier: cellId) as! BookTableViewCell
        
        cell.title.text = book?.title
        var authorString = [String]()
        for author in (book?.authors)!{
            let a = author as! Author
            authorString.append(a.name!)
            
        }
        cell.authors.text = authorString.joined(separator: ", ")
        
        if (book?.photo == nil){
            cell.coverImage.image = UIImage(imageLiteralResourceName: "default_cover.jpg")
            self.downloadCover(url: (book?.imageURL)!, completion: { (cover : UIImage) in
                let photo = Photo(image: cover, context: (self.fetchedResultsController?.managedObjectContext)!)
                book?.photo = photo

            })
        }else{
            cell.coverImage.image = book?.photo?.image
        }
        
        
        return cell
    }

    //MARK: - Delegate
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        let bookTag = self.fetchedResultsController?.object(at: indexPath) as! BookTag
        let pdfViewController = PDFViewController(book: bookTag.book!,
                                                  context: (self.fetchedResultsController?.managedObjectContext)!)
        pdfViewController.title = bookTag.book?.title
        let navVc = UINavigationController(rootViewController: pdfViewController)
        
        self.navigationController?.present(navVc, animated: true, completion: nil)
       
    }
    
}
