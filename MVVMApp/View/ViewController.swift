//
//  ViewController.swift
//  MVVMApp
//
//  Created by Abhinav Singh on 10/1/18.
//  Copyright © 2018 Abhinav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var articleTableView: UITableView!
    
    let articleViewModel = ArticleViewModel()
    var articles:[Articles] = []
    var pageSize = 10
    var totalSize = 0
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Articles"
        getData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData(){
        callAPI(1)
    }
    
    func getImage(_ imageView:UIImageView,IndexPath:Foundation.IndexPath,url:String)
    {
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            if let url=URL(string: url),let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async(execute: {[weak self]() -> Void in
                    imageView.image = UIImage(data: data)
                    self?.imageCache.setObject(UIImage(data: data)!, forKey: "\(IndexPath.row)" as NSString)
                })
            }
        })
    }
    
    func callAPI(_ page:Int){
        articleViewModel.getArticlesFromAPI(page){[weak self](success:Bool) in
            if success{
                self?.articles.append(contentsOf:(self?.articleViewModel.articles)!)
                self?.totalSize = (self?.articleViewModel.totalResults)!
                DispatchQueue.main.async {
                    self?.articleTableView.reloadData()
                }
            }
        }
    }
    
    
    func showAlert(message:String,title:String) {
        let objAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let objAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:
        {Void in
            
            
        })
        
        
        objAlertController.addAction(objAction)
        present(objAlertController, animated: true, completion: nil)
    }
    
    @IBAction func openUrl(_ sender: UIButton) {
        if self.articles[sender.tag].url != "",let uri = URL(string:self.articles[sender.tag].url){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let wikiController = storyBoard.instantiateViewController(withIdentifier: "articleWebViewController") as! ArticleWebViewController
            wikiController.url = uri
            self.navigationController?.pushViewController(wikiController, animated: false)
        }else {
            self.showAlert(message: "No page present for this selection", title: "Article Missing")
        }
        
    }
    
    @IBAction func sortByDate(_ sender: UIButton) {
        
        imageCache.removeAllObjects()
        let filtered = self.articles.sorted(by: {
              $0.publishedAt! > $1.publishedAt!
        })
        
        self.articles = []
        self.articles.append(contentsOf:filtered)
        
        self.articleTableView.reloadData()
    }
    
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var articleCell:ArticleTableViewCell? = articleTableView.dequeueReusableCell(withIdentifier: "articlesCell", for: indexPath) as? ArticleTableViewCell
        
        if articleCell == nil {
            articleCell = articleTableView.dequeueReusableCell(withIdentifier: "articlesCell", for: indexPath) as? ArticleTableViewCell
        }
        
        configureCell(articleCell!, IndexPath: indexPath)
        return articleCell!
    }
    
    func configureCell(_ cell:ArticleTableViewCell,IndexPath:Foundation.IndexPath)
    {
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        cell.containingView.dropShadowOnAllSides()
        cell.viewBtn.tag = IndexPath.row
        cell.articleImage.image = UIImage(named:"")
        
        cell.titleLabel.text = self.articles[IndexPath.row].title
        cell.desc.text = self.articles[IndexPath.row].desc
        if let image = imageCache.object(forKey:"\(IndexPath.row)" as NSString){
            cell.articleImage.image = image
        }else {
             self.getImage(cell.articleImage, IndexPath: IndexPath, url: self.articles[IndexPath.row].urlToImage)
        }
        if(IndexPath.row == (self.articles.count-1) && self.totalSize != self.articles.count){
            self.callAPI((self.articles.count/pageSize)+1)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120;
    }
    
    
}

extension UIView {
    
    func dropShadowOnAllSides() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        //        self.layer.shouldRasterize = true
    }
    
}

