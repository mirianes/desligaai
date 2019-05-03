//
//  NovoDispositivoViewController.swift
//  DesligaAi
//
//  Created by Miriane Silva on 30/04/2019.
//  Copyright © 2019 desligaAi. All rights reserved.
//

import UIKit
import AVFoundation

class NovoDispositivoViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate  {

    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var infoDispositivoStackView: UIStackView!
    @IBOutlet weak var nomeDispositivoTextField: UITextField!
    @IBOutlet weak var nomeEquipamentoTextField: UITextField!
    @IBOutlet weak var autoOffSwitch: UISwitch!
    
    var newDevice: [String: Any] = [:]
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var isReading: Bool = false
    var videoPreview: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.title = "Voltar"

        cameraImageView.layer.cornerRadius = 5
        captureSession = nil
        
        if !isReading {
            if (self.startReading()) {
                self.infoDispositivoStackView.isHidden = true
            }
        } else {
            stopReading()
        }
        
        isReading = !isReading
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startReading() -> Bool {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
        } catch let error as NSError {
            print(error)
            return false
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = self.cameraImageView.layer.bounds
        self.cameraImageView.layer.addSublayer(videoPreviewLayer)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureSession?.startRunning()
        
        return true
    }
    
    func stopReading() {
        captureSession?.stopRunning()
        captureSession = nil
        videoPreviewLayer.removeFromSuperlayer()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        for data in metadataObjects {
            let metaData = data as! AVMetadataObject
            let transformed = videoPreviewLayer?.transformedMetadataObject(for: metaData) as? AVMetadataMachineReadableCodeObject
            if let unwraped = transformed {
                self.newDevice["id"] = unwraped.stringValue
                self.readSuccess()
                self.performSelector(onMainThread: #selector(stopReading), with: nil, waitUntilDone: false)
                isReading = false;
            }
        }
    }
    
    func readSuccess() {
        let alert: UIAlertController = UIAlertController(title: "Alerta", message: "Dispositivo reconhecido com sucesso.",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        self.infoDispositivoStackView.isHidden = false
        self.cameraImageView.isHidden = true
    }
    
    func singupSuccess() {
        performSegue(withIdentifier: "newDeviceSuccess", sender: self)
        let alert: UIAlertController = UIAlertController(title: "Alerta", message: "Dispositivo cadastrado com sucesso.",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func createDevice(_ sender: Any) {
        if let nome = self.nomeDispositivoTextField.text, let equipamento = self.nomeEquipamentoTextField.text {
            self.newDevice["name"] = nome
            self.newDevice["equipament"] = equipamento
            self.newDevice["autoOff"] = self.autoOffSwitch.isOn
            self.newDevice["idUser"] = UIDevice.current.identifierForVendor!.uuidString
            DeviceCRUD.createDevice(self.newDevice, { (status) in
                print(status)
            })
            self.singupSuccess()
        }
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
