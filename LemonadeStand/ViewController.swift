//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Joshua Haines on 1/25/15.
//  Copyright (c) 2015 Joshua Haines. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var lemonsLabel: UILabel!
    @IBOutlet weak var iceCubesLabel: UILabel!
    @IBOutlet weak var purchaseLemonsLabel: UILabel!
    @IBOutlet weak var purchaseIceCubesLabel: UILabel!
    @IBOutlet weak var mixLemonsLabel: UILabel!
    @IBOutlet weak var mixIceCubesLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var money:Int = 10
    var lemons:Int = 1
    var iceCubes:Int = 1
    var purchaseLemons:Int = 0
    var purchaseIceCubes:Int = 0
    var mixLemons:Int = 0
    var mixIceCubes:Int = 0
    var lemonadeRatio:Double = 0.0
    var customers:Int = 0
    var weather:Int = 0
    var weatherBonus:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resetGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions - Step 1: Purchase
    
    @IBAction func purchaseLemonAddButtonPressed(sender: AnyObject) {
        purchaseLemon(true)
    }
    
    @IBAction func purchaseLemonMinusButtonPressed(sender: AnyObject) {
        purchaseLemon(false)
    }
    
    @IBAction func purchaseIceCubeAddButtonPressed(sender: AnyObject) {
        purchaseIceCube(true)
    }
    
    @IBAction func purchaseIceCubeMinusButtonPressed(sender: AnyObject) {
        purchaseIceCube(false)
    }
    
    // MARK: IBActions - Step 2: Mix
    
    @IBAction func mixLemonsAddButtonPressed(sender: AnyObject) {
        mixLemon(true)
    }
    
    @IBAction func mixLemonsMinusButtonPressed(sender: AnyObject) {
        mixLemon(false)
    }
    
    @IBAction func mixIceCubesAddButtonPressed(sender: AnyObject) {
        mixIceCube(true)
    }
    
    @IBAction func mixIceCubesMinuesButtonPressed(sender: AnyObject) {
        mixIceCube(false)
    }
    
    // MARK: IBActions - Step 3: Start Day
    
    @IBAction func startDayButtonPressed(sender: AnyObject) {
        if (mixLemons > 0 && mixIceCubes > 0) || (mixLemons == 0 && mixIceCubes == 0) {
            lemonadeRatio = Double(mixLemons) / Double(mixIceCubes)
            customers = Int(arc4random_uniform(UInt32(10))) + 1 + weatherBonus
            for var i = 0; i < customers; i++ {
                let preference = Double(arc4random_uniform(UInt32(11))) / 10.0
                if lemonadeRatio > 1 {
                    if preference < 0.4 {
                        println("Customer \(i + 1): Paid!")
                        money++
                    }
                    else {
                        println("Customer \(i + 1): No match, No Revenue.")
                    }
                }
                else if lemonadeRatio == 1 {
                    if preference >= 0.4 && preference < 0.6 {
                        println("Customer \(i + 1): Paid!")
                        money++
                    }
                    else {
                        println("Customer \(i + 1): No match, No Revenue.")
                    }
                }
                else if lemonadeRatio < 1 {
                    if preference >= 0.6 && preference <= 1 {
                        println("Customer \(i + 1): Paid!")
                        money++
                    }
                    else {
                        println("Customer \(i + 1): No match, No Revenue.")
                    }
                }
            }
            startNextDay()
        }
        else {
            let alertView = UIAlertView(title: "Warning", message: "You need to have at least 1 lemon and 1 ice cube!", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
        }
    }
    
    // MARK: Helper Methods
    
    func resetGame() {
        weather = Int(arc4random_uniform(UInt32(3)))
        
        money = 10
        lemons = 1
        iceCubes = 1
        
        purchaseLemons = 0
        purchaseIceCubes = 0
        
        mixLemons = 0
        mixIceCubes = 0
        
        updateLabels()
    }
    
    func purchaseLemon(add:Bool) {
        switch add {
        case true:
            if purchaseLemons < 99 && money >= 2{
                purchaseLemons += 1
                lemons += 1
                money -= 2
            }
        default:
            if purchaseLemons > 0 {
                purchaseLemons -= 1
                lemons -= 1
                money += 2
            }
        }
        updateLabels()
    }
    
    func purchaseIceCube(add:Bool) {
        switch add {
        case true:
            if purchaseIceCubes < 99 && money >= 1 {
                purchaseIceCubes += 1
                iceCubes += 1
                money -= 1
            }
        default:
            if purchaseIceCubes > 0 {
                purchaseIceCubes -= 1
                iceCubes -= 1
                money += 1
            }
        }
        updateLabels()
    }
    
    func mixLemon(add:Bool) {
        switch add {
        case true:
            if mixLemons < 99 && lemons >= 1 {
                mixLemons++
                lemons--
            }
        default:
            if mixLemons > 0 {
                mixLemons--
                lemons++
            }
        }
        updateLabels()
    }
    
    func mixIceCube(add:Bool) {
        switch add {
        case true:
            if mixIceCubes < 99 && iceCubes >= 1 {
                mixIceCubes++
                iceCubes--
            }
        default:
            if mixIceCubes > 0 {
                mixIceCubes--
                iceCubes++
            }
        }
        updateLabels()
    }
    
    func startNextDay() {
        weather = Int(arc4random_uniform(UInt32(3)))
        
        purchaseLemons = 0
        purchaseIceCubes = 0
        
        mixLemons = 0
        mixIceCubes = 0
        
        updateLabels()
    }
    
    func updateLabels() {
        switch weather {
        case 0:
            weatherImageView.image = UIImage(named: "snow")
            weatherBonus = -3
        case 1:
            weatherImageView.image = UIImage(named: "cloudy")
            weatherBonus = 0
        default:
            weatherImageView.image = UIImage(named: "sun")
            weatherBonus = 4
        }
        
        moneyLabel.text = "$\(money)"
        lemonsLabel.text = "\(lemons) Lemons"
        iceCubesLabel.text = "\(iceCubes) Ice Cubes"
        purchaseLemonsLabel.text = "\(purchaseLemons)"
        purchaseIceCubesLabel.text = "\(purchaseIceCubes)"
        mixLemonsLabel.text = "\(mixLemons)"
        mixIceCubesLabel.text = "\(mixIceCubes)"
    }
}

