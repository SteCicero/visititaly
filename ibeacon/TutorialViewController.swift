//
//  TutorialViewController.swift
//  ibeacon
//
//  Created by Stefano Cicero on 02/11/16.
//  Copyright © 2016 Stefano Cicero. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController {
    
    var pageHeaders=["Welcome in VisitItaly!",
                     "Site found!",
                     "Always know where you are",
                     "Exhibit info",
                     "Exhibits checklist",
                     "VisitItaly enabled sites map"
                     ]
    
    var pageImages = ["walkthrough-1",
                      "walkthrough-2",
                      "walkthrough-3",
                      "walkthrough-4",
                      "walkthrough-5",
                      "walkthrough-6"]
    var pageDescriptions = ["A new way to enjoy museums, exhibits and monuments in Italy. Just tap the START button on the home screen to start scanning for the sites nearby you.",
                            "When a site is being detected a brief presentation of the latter is displayed.",
                            "Red dots indicate exhibit not visited yet, blinking orange is current exhibit. Green dots indicate exhibit already visited. Tap on a dot to know the associated exhibit name.",
                            "Tap on Detail button to read about the exhibit you are currently watching. The app will update automatically all the showed information as you will move closer to another exhibit.",
                            "Check through the list what exhibits you already visited and what you not.",
                            "Tap the compass button on the home screen to check wich sites are currently supported by VisitItaly."
                            ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.dataSource = self
        
        if let startDataVC = self.viewControllerAtIndex(index: 0)
        {
            setViewControllers([startDataVC], direction: .forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    
    //MARK: - Navigate
    
    func nextPageWithIndex(index: Int)
    {
        if let nextDataVS = self.viewControllerAtIndex(index: index+1)
        {
            setViewControllers([nextDataVS], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func viewControllerAtIndex(index: Int) -> DataViewController?
    {
        if(index == NSNotFound || index < 0 || index >= self.pageDescriptions.count)
        {
            return nil
        }
        if let dataViewController = storyboard?.instantiateViewController(withIdentifier: "DataViewController") as?
        DataViewController
        {
            dataViewController.imageName = pageImages[index]
            dataViewController.headerText = pageHeaders[index]
            dataViewController.descriptionText = pageDescriptions[index]
            dataViewController.index = index
            return dataViewController
        }
        return nil
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

extension TutorialViewController : UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! DataViewController).index
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! DataViewController).index
        index += 1
        return self.viewControllerAtIndex(index: index)
    }
}
