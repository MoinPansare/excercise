//
//  VehicleType.swift
//  excercise
//
//  Created by Moin Pansare on 9/18/22.
//

import UIKit

class VehicleType: UIViewController{
    
    
    @IBOutlet weak var backButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.goBack))
        self.backButton.addGestureRecognizer(tap)
        self.backButton.isUserInteractionEnabled = true

    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
