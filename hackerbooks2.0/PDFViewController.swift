//
//  PDFViewController.swift
//  hackerbooks
//
//  Created by fran on 6/7/16.
//  Copyright © 2016 Fran. All rights reserved.
//

import UIKit
import CoreData
class PDFViewController: UIViewController, URLSessionDownloadDelegate {

 
    
    var session  : URLSession!
    var context : NSManagedObjectContext
    var book : Book
    
    @IBOutlet weak var progressView: UIProgressView!
        
    @IBOutlet weak var webView: UIWebView!
    
    init(book : Book,context : NSManagedObjectContext){
        self.book = book
        self.context = context
        super.init(nibName: nil,bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.edgesForExtendedLayout = []
        
        saveLastPdf()
        
        if(self.book.pdf == nil){
            let conf = URLSessionConfiguration.background(withIdentifier: "hackerbooks.pdf." + self.book.title!)
            let queue = OperationQueue()
            self.session = URLSession(configuration: conf, delegate: self, delegateQueue: queue)
            
            let task = session.downloadTask(with: self.book.pdfURL)
            
            task.resume()
        }else{
            self.loadPDF(data: self.book.pdf?.pdfData as! Data)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PDFViewController.cancel))
        
        
    }
    
    
    func cancel(){
        self.clean()
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }

    func showNotes(){
        
        let notesRequest : NSFetchRequest<Annotation> = Annotation.fetchRequest()
        notesRequest.sortDescriptors = [NSSortDescriptor(key:"modificationDate",ascending:false)]
        
        
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: notesRequest, managedObjectContext: self.book.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)


        
        let annotationCVC = AnnotationsCollectionViewController(pdf: self.book.pdf!,fetchedResultsController: fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>, layout: UICollectionViewFlowLayout())
        annotationCVC.title = "List"
        
    
        self.navigationController?.pushViewController(annotationCVC, animated: true)
        
        
    }
    
    func loadPDF(data : Data){
        
        self.webView.load(data, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: NSURL() as URL)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Notas", style: .plain, target: self, action: #selector(PDFViewController.showNotes))
    }
    
    func clean(){
        self.progressView.progress = 0
        
        self.session?.invalidateAndCancel()
        self.session?.finishTasksAndInvalidate()
    }
}
//MARK: - ProgressView
extension PDFViewController{
    
    @objc(URLSession:downloadTask:didFinishDownloadingToURL:) func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let data = try! Data(contentsOf: location)
        let pdf = Pdf(pdfData: data, inContext: self.context)
        self.book.pdf = pdf
        
        self.loadPDF(data: data)
        
        self.clean()
    }
    
    @objc(URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:) func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.progressView.progress = self.progressWith(nextBytes: totalBytesWritten, totalExpectedBytes: totalBytesExpectedToWrite)
        }
    }
    
    @objc(URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:) func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        DispatchQueue.main.async {
            self.progressView.progress = self.progressWith(nextBytes: fileOffset, totalExpectedBytes: expectedTotalBytes)
        }
    }
    
    func progressWith(nextBytes : Int64, totalExpectedBytes : Int64) -> Float{
        return Float(integerLiteral: nextBytes) / Float(integerLiteral: totalExpectedBytes)
    }
    
}

extension PDFViewController{
    
    func saveLastPdf(){
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(self.book.objectID.uriRepresentation(), forKey: "lastPDF")
        
    }
    
}


