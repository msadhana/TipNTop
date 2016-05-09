//
//  temp.swift
//  TipNTop
//
//  Created by Sadhana Maniarasu on 4/19/16.
//  Copyright © 2016 Sadhana Maniarasu. All rights reserved.
//

import Foundation

class tempController: UIViewController {
    
    @IBAction func printAction(sender: AnyObject) {
        
            
            txtView.text = "ABCD\nEFGH\nbvyurb\nnvenv\n"
            let pic:UIPrintInteractionController = .sharedPrintController()
            let viewpf:UIViewPrintFormatter = txtView.viewPrintFormatter()
            
            pic.showsPageRange = true
            pic.printFormatter = viewpf
            pic.presentAnimated(true, completionHandler: nil)
        

    }
    
     @IBOutlet weak var txtView: UITextView!
    
}