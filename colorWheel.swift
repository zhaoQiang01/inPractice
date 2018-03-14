
// 
import UIKit

let width = 100
let height = 100
// RGB24
let bitsPerComponent = 8
let bitsPerPixel = 24
let bytesPerPixel = bitsPerPixel / 8
let bytesPerRow = bytesPerPixel * width

let colorSpace = CGColorSpaceCreateDeviceRGB()
let cgBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

var decode = UnsafeMutablePointer<CGFloat>.allocate(capacity: 6)
for idx in 0..<6 {
    if(idx % 2 == 0){
        decode.advanced(by: idx).pointee = 0.0
    }else {
        decode.advanced(by: idx).pointee = 1.0
    }
}

let rasterBufferSize = width * height * bytesPerPixel
var arr: [UInt8] = Array(repeating: 0, count: rasterBufferSize)

let radius = width / 2
let centre = (radius, radius)
for idx in stride(from: 0, to: rasterBufferSize, by: bytesPerPixel) {
    
    let (x, y) = (idx / 3 / width ,  idx / 3  % width )
    
    let (offsetX, offsetY) = (x - centre.0, y - centre.1)
    let hyp = hypot(CGFloat( offsetX ), CGFloat(offsetY) )
    if hyp > CGFloat(radius) {
        arr[idx] = 255
        arr[idx + 1] = 255
        arr[idx + 2] = 255
        continue
    }
    
    let proportion = 1.0 - hyp / CGFloat(radius)
    let angle = modf( (atan2( CGFloat(offsetY), CGFloat(offsetX)) + CGFloat.pi ) / (2 * CGFloat.pi) * 6 )
//: FIXME
    // 这个地方浮点精度控制有bug
    let ai = Int(angle.0) - 1 > 0 ? ( Int(angle.0) - 1 ) : 0
    let af = angle.1
    let r = UInt8( [proportion, af, 1.0, 1.0 , 1.0 - af, 0.0][ai] * 255 )
    let g = UInt8( [1.0, 1.0, 1.0 - af, proportion, proportion, af][ai] * 255 )
    let b = UInt8( [1.0 - af, proportion, proportion, af, 1.0, 1.0][ai] * 255 )
    arr[idx] = r
    arr[idx + 1] = g
    arr[idx + 2] = b
}

let rasterBuffer: CFMutableData = CFDataCreateMutable(nil, rasterBufferSize)!
CFDataAppendBytes(rasterBuffer, arr, rasterBufferSize)

let cgData = CGDataProvider(data: rasterBuffer)!

let cgImg = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: cgBitmapInfo, provider: cgData, decode: decode, shouldInterpolate: false, intent: .defaultIntent)

decode.deallocate(capacity: 6)
let img = UIImage(cgImage: cgImg!)