//
//  ChatViewController.swift
//  Free Chat
//
//  Created by Talha on 06/03/2020.
//  Copyright © 2020 Talha. All rights reserved.
//
import UIKit
import Firebase
import ChameleonFramework
class ChatViewController: UIViewController {
      
    var msgArrat :[Massage] = [Massage] ()
    @IBOutlet weak var hieght: NSLayoutConstraint!
    @IBOutlet weak var tavleView: UITableView!
    @IBOutlet weak var sendButtonTextFeild: UIButton!
    @IBOutlet weak var msgTextFeild: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tavleView.delegate = self
        tavleView.dataSource = self
        tavleView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier:"customMessageCell" )
        configureTableView()
        msgTextFeild.delegate = self
        let tapGesture = UITapGestureRecognizer (target: self, action: #selector(tableViewTapped))
        tavleView.addGestureRecognizer(tapGesture)
        retrieveMassage()
        tavleView.separatorStyle = .none
    }
//MARK: - Ende ViewDid Load
    @IBAction func logOut(_ sender: AnyObject) {
        do{
        try Auth.auth().signOut()
            //For go to direct Root Screen
        navigationController?.popToRootViewController(animated: true)
        }
        catch {
        print("Problem")
        }
    }
    @objc func tableViewTapped(){
        msgTextFeild.endEditing(true)
    }
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        msgTextFeild.endEditing(true)
        //Because oF Sent button pressed so sent button and text Field dissable
        msgTextFeild.isEnabled = false
        sendButtonTextFeild.isEnabled = false
        // Create a New Data Base in Main Data base For just msg
        let massageDB = Database.database().reference().child("Massage_DB")
        let massageDic = ["sender" : Auth.auth().currentUser?.email,
                          "massage" : msgTextFeild.text!]
        //give the Every Msg unique
        massageDB.childByAutoId().setValue(massageDic){
            (error,refrence) in
            if error != nil {
                print(error)
            }
            else{
                print("Massage Saved")
                self.msgTextFeild.isEnabled = true
                self.sendButtonTextFeild.isEnabled = true
                self.msgTextFeild.text = ""
            }
        }
    }
    func retrieveMassage(){
        let massageDB = Database.database().reference().child("Massage_DB")
        massageDB.observe(.childAdded) { (sapshotn) in
            let value =  sapshotn.value as! Dictionary< String,String>
            let text = value["massage"]!
            let send = value["sender"]!
          var  massage = Massage()
            massage.sender = send
            massage.massageBody = text
            self.msgArrat.append(massage)
        
            self.configureTableView()
            self.tavleView.reloadData()
            
        }
    }
    
}
//MARK: - UItABLEviewDataSource
//For table view
extension ChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArrat.count
    }
    
   
    //Declare cellForRowIndexPath here;
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tavleView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
       // let massageArray = ["First Message  avsvjhahsvas as  c c saggashjsc cgagac gacsgcgac ga aagj asj ashjbaj,jsavhjvchjvcahjvcvsjasvchjavajhchjvashchjv cs cgs gassags as sgs a sags sag jas sg as sa","Second Massage", "Third Massage"]
      //  let a = ["Talha","sahi","Fhad"]
        cell.messageBody.text = msgArrat[indexPath.row].massageBody
        cell.senderUsername.text = msgArrat[indexPath.row].sender
        cell.avatarImageView.image = UIImage (named: "egg")
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String?{
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        }
        else{
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        return cell
    }
// for adjust the all the  cel hight with respect to Msg lenght
    func configureTableView(){
        tavleView.rowHeight = UITableView.automaticDimension
        tavleView.estimatedRowHeight = 120.0
        
    }
    
    
    
}
//MARK: - UITableViewDelegate
//For table View
extension  ChatViewController : UITableViewDelegate{
    
}
//MARK: - UITextFieldDelegate
extension ChatViewController : UITextFieldDelegate{
    // THis method Called auto
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.hieght.constant = 345
            self.view.layoutIfNeeded()
        }
        
    }
    //This fun can not auto  call
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
                   self.hieght.constant = 45
                   self.view.layoutIfNeeded()
               }
    }
    func textFieldShouldReturn(_ textField:
        UITextField) -> Bool {
        //this function is call when return button pressed.
        msgTextFeild.endEditing(true)
        return true
    }
}
