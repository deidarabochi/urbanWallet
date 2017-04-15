import UIKit
import AVFoundation

let nameArray = ["Eric Lin",
                 "Kristen Berling",
                 "Jun Chang",
                 "Patrick Wu",
                 "Viet Doan",
                 "Juan Miguel Baluyut",
                 "Zark Muckerberg",
                 "Pauline Chen",
                 "Cynthia Zhang",
                 "Oscar"
]

let kitchenArray = ["Graham Hall",
                    "McWalsh Hall",
                    "Commuter Lounge",
                    "Sobrato",
                    "Villas 11",
                    "Villas 6",
                    "Harvard University",
                    "Overwatch",
                    "Villas 2",
                    "Sesame Street"
]

let pictureArray = ["ericlin",
                    "kberling",
                    "jchang",
                    "pwu",
                    "vdoan",
                    "mbaluyut",
                    "mzuckerberg",
                    "pchen",
                    "czhang",
                    "imgres"
]

class DonateViewController: UIViewController {
    
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var kitchenLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var donateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dollarsignLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBAction func donateButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Urban Wallet", message:
            "Thank you, your payment has been received. Please press Back to scan another QR code.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = Int(arc4random_uniform(10))

        self.pictureImage.image = UIImage(named: pictureArray[index])
        self.nameLabel.text = nameArray[index]
        self.kitchenLabel.text =  kitchenArray[index]
        
        donateButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
        commentsTextView.layer.cornerRadius = 5
        
        //looks for single or multiple taps
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DonateViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

