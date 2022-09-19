//
//  ViewController.swift
//  excercise
//
//  Created by Moin Pansare on 9/18/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var searchTextField: UITextField!
    var list_of_cars = [Car]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.layer.cornerRadius = self.searchTextField.frame.size.height / 2.0;
        self.searchTextField.setLeftPadding(20)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hdieTheKeyboard))
        self.view.addGestureRecognizer(tap)
        self.list_of_cars = self.readFile()
        self.searchTextField.delegate = self
        self.getResultForSearch(input: "Bron 2021")
        self.getResultForPrice(price: 59341)
    }
    
    @objc func hdieTheKeyboard() {
        self.view.endEditing(true)
    }
    
    func readFile() -> [Car]{
        if let path = Bundle.main.path(forResource: "Exercise_Dataset", ofType: "json") {
            let list_of_cars : [Car] = try! decode(from: Data(contentsOf: URL(fileURLWithPath: path)))
            return list_of_cars
        }
        return []
    }
    
    func getResultForSearch(input : String){
        var result = [Car]()
        var input1 = ""
        var input2 = ""
        var input3 : Float = 0
        var input4 : Float = 0
        let temp_inputs = input.components(separatedBy: " ")
        for item in temp_inputs {
            let temp = Float(item)
            if temp != nil {
                if(input3 == 0){
                    input3 = temp!
                }else{
                    input4 = temp!
                }
            }else{
                if(input1.count == 0){
                    input1 = item.lowercased()
                }else{
                    input2 = item.lowercased()
                }
            }
        }
        
        for item in self.list_of_cars {
            if input1.count > 0 {
                if item.make.lowercased().range(of: input1) != nil || item.model.lowercased().range(of: input1) != nil {
                    result.append(item)
                }
            }
        }
        if result.count == 0 {
            result = self.list_of_cars
        }
        
        var temp = [Car]();
        if(input2.count > 0){
            for item in result {
                if item.make.lowercased().range(of: input2) != nil || item.model.lowercased().range(of: input2) != nil{
                    temp.append(item)
                }
            }
            if temp.count != result.count {
                result = temp
            }
        }
        
        temp = [Car]()
        if input3 > 0 {
            for item in result {
                if checkIfThisInputisYear(value: input3){
                    if item.year == Int(input3) {
                        temp.append(item)
                    }
                }else{
                    if Float(item.price) <= input3 {
                        temp.append(item)
                    }
                }
            }
            if temp.count != result.count {
                result = temp
            }
        }
        
        temp = [Car]();
        if input4 > 0 {
            for item in result {
                if checkIfThisInputisYear(value: input4){
                    if item.year == Int(input4) {
                        temp.append(item)
                    }
                }else{
                    if Float(item.price) <= input4 {
                        temp.append(item)
                    }
                }
            }
            if temp.count != result.count {
                result = temp
            }
        }
        
        if(result.count == 0){
            print("Search Resulted in Mo Matches")
        }else{
            print("Total Search Results \(result.count)")
            print(result)
        }
    }
    
    func getResultForPrice(price : Int){
        var vehicle : Car?
        for item in self.list_of_cars {
            if item.price == price {
                vehicle = item
                break;
            }
        }
        var list = [Int]()
        for item in self.list_of_cars{
            if item.make == vehicle?.make && item.model == vehicle?.model {
                list.append(item.price)
            }
        }
        
        let sortedOne = list.sorted { (first, second) -> Bool in
            return first < second
        }
        
        print(sortedOne)
        
        print("Lowest : \(sortedOne[0])  & Median : \(self.getMedian(input: sortedOne)) & Highest : \(sortedOne[sortedOne.count - 1])")
        
    }
    
    func getMedian(input : [Int]) -> Int {
        if input.count % 2 == 0 {
            return Int(Float((input[(input.count / 2)] + input[(input.count / 2) - 1])) / 2)
        } else {
            return Int(Float(input[(input.count - 1) / 2]))
        }
    }
    
    func checkIfThisInputisYear(value : Float) -> Bool {
        if(value >= 1960 && Int(value) <= Calendar.current.component(.year, from: Date())){
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hdieTheKeyboard();
        let value = self.searchTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines);
        if(value.count == 0){
            print("Type Something")
        }else{
            self.getResultForSearch(input: value)
        }
        return true
    }
    
    
    func decode<T : Decodable>(from data : Data) throws -> T
    {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}

struct Car : Codable   {
    let make: String
    let model: String
    let year: Int
    let vehicle_count: Int
    let price: Int
}


extension UITextField {
    
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension String {
    func trimmingLeadingAndTrailingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return trimmingCharacters(in: characterSet)
    }
}


