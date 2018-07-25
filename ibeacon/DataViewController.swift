//
//  DataViewController.swift
//  ibeacon
//
//  Created by Stefano Cicero on 02/11/16.
//  Copyright © 2016 Stefano Cicero. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func nextClicked(_ sender: Any)
    {
        let tutorialViewController = self.parent as! TutorialViewController
        tutorialViewController.nextPageWithIndex(index: index)
    }
    
    @IBAction func dismissTutorial(_ sender: Any)
    {
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Data model for each walkthrough screen
    var index = 0                   //current page index
    var headerText = ""
    var imageName = ""
    var descriptionText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = headerText
        descriptionLabel.text = descriptionText
        imageView.image = UIImage(named: imageName)
        pageControl.currentPage = index
        
        nextButton.isHidden = (index == 5) ? true : false
        startButton.isHidden = (index == 5) ? false : true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
