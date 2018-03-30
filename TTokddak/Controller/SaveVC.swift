//
//  SaveVC.swift
//  TTokddak
//
//  Created by Samuel K on 2018. 3. 30..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit

class SaveVC: UIViewController {
  
  @IBOutlet weak var savedImage: UIImageView!
  var capturedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
      
      savedImage.image = capturedImage

      
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
