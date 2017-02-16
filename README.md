## QRCodeScanner

Scan the following codes with just few lines of code

⋅⋅* QRCode
⋅⋅* Interleaved2of5Code
⋅⋅* ITF14Code
⋅⋅* DataMatrixCode
⋅⋅* UPCECode
⋅⋅* Code39Code
⋅⋅* Code39Mod43Code
⋅⋅* Code93Code
⋅⋅* Code128Code
⋅⋅* EAN8Code
⋅⋅* EAN13Code
⋅⋅* AztecCode
⋅⋅* PDF417Code

![Default](https://raw.githubusercontent.com/kapilahuja/touchid/master/TouchID/TouchID/IMG_1213.PNG)

## Usage

### Without Cocoapods

Add `CodeScan.swift` to your project.

### Examples

Initializing the object of class

```swift
@IBOutlet var scanCode: CodeScan! = CodeScan.sharedInstance
```

Call `ScanCode()` method to scan a code and define `CodeScanDelegate` Delegate to get the success and fail responses.

```swift
scanCode.codeScanDelegate = self
scanCode.ScanCode()
```

Delegate Methods (All are optional)

```swift
func CodeScanSuccedd(Code: String)
func CodeScanFail(ErrorMessage: String)
```

Use like

```swift
//MARK:- CodeScanDelegate
    
    func CodeScanSuccedd(Code: String) {
        // Implementation After Getting Code
        print("\(Code)")
    }
    
    func CodeScanFail(ErrorMessage: String) {
        // Sacn Fail/Error
        print("\(ErrorMessage)")
    }

``````

## Swift and Objective-C compatability

QRCodeScanner uses Swift as of its 3.0 release. CodeScan.swift can be used in Objective-C using Swift Objective-C bridging.

## Requirements

QRCodeScanner requires iOS 7.0 and above.

## License

Made available under the MIT License. Attribution would be nice.
