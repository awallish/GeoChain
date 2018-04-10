//
//  ViewController.swift
//  crypto
//
//  Created by Alex Wallish on 4/7/18.
//  Copyright © 2018 Alex Wallish. All rights reserved.
//

import UIKit
import BigInt
import web3swift
//import Geth

import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    // memory location of 
    let contractAddress = "";
    
    let locationManager: CLLocationManager = CLLocationManager();
    let geocoder: CLGeocoder = CLGeocoder();

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization();
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        }
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // This is where all the functionality goes
    @IBAction func checkIn(_ sender: Any) {

        locationManager.requestLocation();
        
        

        
    }
    
    var address: String = "";
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var latValue = locationManager.location?.coordinate.latitude;
        var lonValue = locationManager.location?.coordinate.longitude;
        
        print(latValue!);
        print(lonValue!);
        
        CLGeocoder().reverseGeocodeLocation(locationManager.location!) { (placemark, error) in
            if error != nil
            {
                print("There was error!");
            }
            else {
                if let place = placemark?[0]{
                    self.address = place.name! + " " + place.locality! + " " + place.country!;
                }
            }
        }

        sendToContract(address: address);
        

    }
    
    
    
    // Returns true if successful
    private func sendToContract(address : String) -> Bool {
        let jsonString = "[{\"constant\":false,\"inputs\":[{\"name\":\"location\",\"type\":\"string\"}],\"name\":\"checkIn\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"tL\",\"type\":\"string\"},{\"name\":\"name\",\"type\":\"string\"},{\"name\":\"r\",\"type\":\"uint256\"},{\"name\":\"wN\",\"type\":\"uint256\"}],\"name\":\"createIncentive\",\"outputs\":[],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"function\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"log\",\"type\":\"string\"}],\"name\":\"log_string\",\"type\":\"event\"},{\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"fallback\"}]"
        do {
            
            let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let keystoreManager = KeystoreManager.managerForPath(userDir + "/keystore")
            
            var ks: EthereumKeystoreV3?
            if (keystoreManager?.addresses?.count == 0) {
                ks = try! EthereumKeystoreV3(password: "BANKEXFOUNDATION")
                let keydata = EthereumAddress("0xe1669a40f8356f1655e5052931b6f25d641ea6b6").addressData
                FileManager.default.createFile(atPath: userDir + "/keystore"+"/key.json", contents: keydata, attributes: nil)
            } else {
                ks = keystoreManager?.walletForAddress((keystoreManager?.addresses![0])!) as! EthereumKeystoreV3
            }
            guard let sender = ks?.addresses?.first else {
                print("sender is empty");
                return false;
            }
            print("0xe1669a40f8356f1655e5052931b6f25d641ea6b6")
            
            var options = Web3Options()
            options.from = EthereumAddress("0xe1669a40f8356f1655e5052931b6f25d641ea6b6")
            let web3Rinkeby = Web3.InfuraRinkebyWeb3()
            web3Rinkeby.addKeystoreManager(keystoreManager)
            let coldWalletABI = "[{\"payable\":true,\"type\":\"fallback\"}]"
            let coldWalletAddress = EthereumAddress("fd057dfbc822ccf6c4848c2ec1b580097810fbffacff6cf9a8eef401e751b196")
            let constractAddress = EthereumAddress("0x958D2AbC4E3BCdb49BdE50B9A840231Eb7b9d1e1")
            
            let contract = web3Rinkeby.contract(jsonString, at: constractAddress)
            let intermediate = contract?.method(options: options)
            var res = intermediate?.call(options: options)
            guard let result = res else {print("Fail");return false;}
            
            options = Web3Options.defaultOptions()
            options.from = sender
        } catch {
            print(error)
        }
        return true;
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }

    
}

