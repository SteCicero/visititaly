//
//  SiteOrDetailViewController.swift
//  test con le viste
//
//  Created by Stefano Cicero on 28/10/16.
//  Copyright © 2016 Stefano Cicero. All rights reserved.
//

import UIKit

class SiteOrDetailViewController: UIViewController {

    var tbc:TabBarViewController!
    
    var viewTitle:String?
    var imgUrl:String?
    var textDescription:String?
    
    
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    
    @IBAction func homeButton(_ sender: Any)
    {
        tbc.dismiss(animated: true, completion: nil)
    }


    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tbc.loadImageFromStrUrl(inUrl: imgUrl!, targetImg: imgView)
        
        navBarTitle.title = viewTitle
        descriptionView.text = textDescription
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update()
    {
        print("update site or detail chiamata")
        print(viewTitle!)
        let url = URL(string: imgUrl!)!
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            if (error != nil)
            {
                print(error!)
            }
            else
            {
                if let data = data
                {
                    if let bachImage = UIImage(data: data)
                    {
                        DispatchQueue.main.async() { () -> Void in
                            self.imgView.image = bachImage
                        }
                    }
                }
            }
        }
        
        task.resume()
        navBarTitle.title = viewTitle
        descriptionView.text = textDescription
        self.view.self.setNeedsDisplay()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
