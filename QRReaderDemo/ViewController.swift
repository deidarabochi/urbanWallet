import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var testButton: UIButton!

    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    // list of suported barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // using AVCaptureDevice to initialize a video device object aka a camcorder
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // setting the capture device to above object
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // initializing captureSession
            captureSession = AVCaptureSession()
            // setting input device
            captureSession?.addInput(input)

            // initializing another AVCaptureMetadataOutput object to make it the output device for the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // using a dispatch queue
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

            // detecting qr and barcodes
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // initializing video preview layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // begin video capture
            captureSession?.startRunning()
            
            // moving message label to top view
            view.bringSubview(toFront: messageLabel)
            
            // allowing qr code to be highlighted in red
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.red.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch let error as NSError{
            // in case things go wrong
            print(error)
            return
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        //if no qr detected
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "Please scan a QR code."
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        //if qr detected
        if supportedBarCodes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            //actual action of qr detection
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let donateViewController = storyBoard.instantiateViewController(withIdentifier: "DonateView") as! DonateViewController
                self.present(donateViewController, animated:true, completion:nil)
            }
        }
    }
}

//|| metadataObjects == "localhost:5000/data_0" || metadataObjects == "localhost:5000/data_1" || metadataObjects == "localhost:5000/data_2" || metadataObjects == "localhost:5000/data_3" || metadataObjects == "localhost:5000/data_4" || metadataObjects == "localhost:5000/data_5" || metadataObjects == "localhost:5000/data_6" || metadataObjects == "localhost:5000/data_7" || metadataObjects == "localhost:5000/data_8" || metadataObjects == "localhost:5000/data_9"
