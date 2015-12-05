//
//  HelpInfo.swift
//  JXT
//
//  Created by 1039soft on 15/8/28.
//  Copyright (c) 2015年 JW. All rights reserved.
//

import UIKit

class HelpInfo: UIViewController {

    var pathName = String()
    @IBOutlet weak var web: UIWebView!
    var tex:String?
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "考试要点"
        let path = NSBundle.mainBundle().pathForResource(pathName, ofType: "html")
        let request = NSURLRequest(URL: NSURL(fileURLWithPath: path!))
        web.loadRequest(request)
        // Do any additional setup after loading the view.
    }

 

}
