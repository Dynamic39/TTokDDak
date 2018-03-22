//
//  MainViewController.swift
//  DDalKak
//
//  Created by Samuel K on 2018. 3. 17..
//  Copyright © 2018년 Samuel K. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
 
  //뷰 파인더 및 필터 컬렉션 뷰
  @IBOutlet weak var previewFromCamera: UIImageView!
  @IBOutlet weak var filterCollectionView: UICollectionView!
  
  //필터 이름 설정
  @IBOutlet weak var fileterLB: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupDevice()
    setupInpuToOutput()
    
  }
  
  
  //MARK : - Camera Setting Properties & Method
  
  var captureSession = AVCaptureSession()
  //카메라 장비 세팅
  var backCamera: AVCaptureDevice?
  var frontCamera: AVCaptureDevice?
  var currentCamera: AVCaptureDevice?
  //사진 촬영후, 아웃풋 결과물을 담는 프로퍼티 생성
  var photoOutput: AVCapturePhotoOutput?
  //카메라 레이아웃을 설정한다.
  var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
  //카메라 오리엔테이션 설정 : 기본은 portrait
  var orientation: AVCaptureVideoOrientation = AVCaptureVideoOrientation.portrait
  //필터 사용시 사용할 context설정
  let context = CIContext()
  //필터 명
  var filter:String = "CIColorCrossPolynomial"
  
  override func viewDidLayoutSubviews() {
    //오리엔테이션 고정
    //orientation = AVCaptureVideoOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!
  }
  
  //디바이스를 세팅한다.
  func setupDevice() {
    //디바이스를 찾아낸다. 타입은 현재 설치 되어있는 와이드 앵글 카메라이다.
    let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
    
    //전 후면의 디바이스를 가지고 온다.
    //For 문을 사용하여 각 디바이스를 나눠준후, 기초 값을 설정하여 준다.
    let devices = deviceDiscoverySession.devices
    for device in devices {
      if device.position == AVCaptureDevice.Position.back {
        backCamera = device
      } else if device.position == AVCaptureDevice.Position.front {
        frontCamera = device
      }
    }
    currentCamera = backCamera
  }
  
  
  //데이터 입출력 메서드 구현
  func setupInpuToOutput() {
    
    do {
      let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
      captureSession.sessionPreset = AVCaptureSession.Preset.photo
      
      //인풋이 가능하다면 인풋을 실행한다.
      if captureSession.canAddInput(captureDeviceInput) {
        captureSession.addInput(captureDeviceInput)
      }
      //실시간 필터링을 위한 서브 스레드 작업을 진행한다.
      let videoOutput = AVCaptureVideoDataOutput()
      videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
      if captureSession.canAddOutput(videoOutput) {
        captureSession.addOutput(videoOutput)
      }
      
      photoOutput = AVCapturePhotoOutput()
      photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
      
      captureSession.addOutput(photoOutput!)
      
      captureSession.startRunning()
      
    } catch  {
      print("FATAL ERROR TO CAMERA TAKEN")
    }
    
  }
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    
    let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
    let cameraImage = CIImage(cvImageBuffer: pixelBuffer!)
    
    connection.videoOrientation = .portrait
    
    let currentFilterString = filters.first
    print("응?", currentFilterString)
    var currentFilter = CIFilter(name: currentFilterString!)
    
    if currentFilterString != filter {
      currentFilter = CIFilter(name: filter)
    } else {
      currentFilter = CIFilter(name: currentFilterString!)
    }
    
    currentFilter?.setValue(cameraImage, forKey: kCIInputImageKey)
    let filteredImage = UIImage(ciImage: currentFilter?.value(forKey: kCIOutputImageKey) as! CIImage)
    DispatchQueue.main.async {
      self.previewFromCamera.image = filteredImage
    }
    
  }
  
  
  //MARK : - Button Handler
  @IBAction func flashHandler(_ sender: Any) {
    
  }
  
  @IBAction func timerHandler(_ sender: Any) {
    
  }
  
  @IBAction func changeCameraHandler(_ sender: Any) {
    
  }
  
  @IBAction func autoSaveTakenPhotoHandler(_ sender: Any) {
    
  }
  

}

//MARK : - Filter Collection View Methods
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filters.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let item = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "filter_cell", for: indexPath) as! FilterCustomCell
  
    return item
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let filterFromItemIndex = FilterIndex()
    filter = filterFromItemIndex.filterFromIndexPath(indexPath: indexPath)
    fileterLB.text = filtersName[indexPath.row]
  }
  
  
  
  
}
