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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        if self.isFav(book!){
            
            cell.fav.setTitle("🌟", for: .normal)
            
        }else {
            cell.fav.setTitle("⭐️",for: .normal)
        }
        cell.fav.addTarget(self, action: #selector(BooksViewController.didFav(_:)), for: .touchUpInside)
        
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
//MARK: - Favorites
extension BooksViewController {
    
    func didFav(_ sender:AnyObject){
        // Obtain the indexPath of the pressed fav button
        let cgPointZero = CGPoint(x: 0, y: 0)
        let point = sender.convert(cgPointZero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: point)
        // Fetch the bookTag and the book associated to that indexPath
        let bookTag = self.fetchedResultsController?.object(at: indexPath!) as! BookTag
        let book = bookTag.book!
        // if is favorite, we delete it, else, we create a new BookTag with favorite Tag
        if isFav(book){
            
            let bookTag = self.bookTagOfFavorites(with: book)
            self.fetchedResultsController?.managedObjectContext.delete(bookTag)
            
        }else{
            let _ = BookTag(book: book, tag: self.favEntity(), inContext: (self.fetchedResultsController?.managedObjectContext)!)
        }
    
        self.tableView.reloadData()
        
    }
    
    func favEntity() ->Tag{
        
        let favRequest = NSFetchRequest<Tag>(entityName: Tag.entityName)
        favRequest.predicate = NSPredicate(format: "name == %@", "Favorites")
        
        let favEntity = try! (self.fetchedResultsController?.managedObjectContext.fetch(favRequest)[0])! as Tag
        return favEntity
    }
    
    func isFav(_ book: Book) -> Bool{
        
        for bookTag : BookTag in favEntity().bookTags?.allObjects as! [BookTag]{
            if bookTag.book == book{
                return true
            }
        }
        return false
        
    }
    
    func bookTagOfFavorites(with book: Book) -> BookTag{
        
        let bookTagRequest = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        
        let tagPredicate = NSPredicate(format: "tag == %@", self.favEntity())
        let bookPredicate = NSPredicate(format: "book == %@", book)
        bookTagRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [tagPredicate,bookPredicate])
        let bookTag = try! (self.fetchedResultsController?.managedObjectContext.fetch(bookTagRequest)[0])! as BookTag
        return bookTag
    }
    
    
}
