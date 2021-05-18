//
//  sample_web.swift
//  
//
//  Created by Yudai Fujioka on 2021/05/18.
//


//webサービスとの連携について


/*
 ・クライアントとサーバ間でデータフォーマット（ex.JSON）と通信プロトコル(ex.HTTPS)による取り決めが必要
 ・コアライブラリであるFoundationを利用することでJSONの取り扱いやHTTPSによる通信を簡単に実装できる
 
 ・エンコード：データを一定の規則に基づいて変換すること
 ・デコード：エンコードしたデータをもとに戻すこと
 ・サーバからデータを受信したりするときには、swiftの型にデコードする
 */

import Foundation

//JSONのエンコード・デコード
//JSONEncoderクラス・JSONDecoderクラス（Foundationが元々用意している）
//特定の型の値をエンコード、デコードするには、その型がEncodableプロトコルやDecodableプロトコルに準拠している必要がある
//エンコードとデコードの両方に対応させるにはCodableプロトコルに準拠する

//JSONEncoder: Swiftの値 -> JSONバイト列にエンコード
let encoder = JSONEncoder()

//JSONDecoder: JSONバイト列　-> Swiftの値にデコード
let decoder = JSONDecoder()

let encoded = try encoder.encode(["key":"value"])
let jsonString = String(data: encoded, encoding: .utf8)
print("エンコード結果:", jsonString)

let decoded = try decoder.decode([String:String].self, from: encoded)
print("デコード結果:", decoded)


print("------------------------------------------------------------")

struct SomeStruct : Codable {
    let value: Int
}

let someStruct = SomeStruct(value: 1)

let jsonEncoder = JSONEncoder()

//Codableに準拠した型からJSONへのエンコード
let encodedJSONData = try! jsonEncoder.encode(someStruct)
let encodedJSONString = String(data: encodedJSONData, encoding: .utf8)
print("Encoded:", encodedJSONString)

let jsonDecoder = JSONDecoder()

//JSONからCodableに準拠した型へのデコード
let decodedSomeStruct = try! jsonDecoder.decode(SomeStruct.self, from: encodedJSONData)
print("Decoded:", decodedSomeStruct)

/*
 struct NonCodableStruct {}
 
 nonCOdableStructプロパティの型がCodableに準拠していないためコンパイルエラー
 struct COdableStruct : Codable {
 let nonCodableStruct: NonCodableStruct
 }
 
 */

//HTTPによるWebサービスとの通信

/*
 ・FoundationはHTTPによる通信に必要な型を提供する
 ・HTTPリクエストはURLRequest型(リクエスト情報の表現)で表現
 ・HTTPレスポンスはHTTPURLRequest型（HTTPレスポンスのメタデータ）で表現
 ・HTTPSはHTTPによる通信をSSL/TLSという仕組みで暗号化したもの
 
 */

//URLRequest型
//HTTPリクエストのURL、ヘッダ、メソッド、ボディなどの情報を持つ

let url = URL(string: "https://api.github.com/search/repositories?Q=swift")!
var urlRequest = URLRequest(url: url)
urlRequest.httpMethod = "GET"
urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

//HTTPURLResponse型
//ヘッダやステータスコードなどの情報を持つ

let responseUrl = URL(string: "https://api.github.com/search/repositories?Q=swift")!
let responseUrlRequest = URLRequest(url: responseUrl)

let session = URLSession.shared
let task = session.dataTask(with: responseUrlRequest) {
    data, urlResponse, error in
    if let urlResponse = urlResponse as? HTTPURLResponse {
        urlResponse.statusCode
        
        urlResponse.allHeaderFields["Date"]
        
        urlResponse.allHeaderFields["Content-Type"]
    }
}

task.resume()

/*
 ・URLSessionクラス：URL経由でのデータの送信、取得
 ・個々のリクエストはタスクと呼ばれ、URLSessionTaskクラスで表現される
 ・３種類のタスク（基本、アップロード用、ダウンロード用 / URLSessionTaskのサブクラスであるURLSessionDataTaskクラス, URLSessionUploadTaskクラス, URlSessionDownloadTaskクラス）
 
 ・URLSessionDataTaskクラス:iOSではバックグラウンドで動作できず、サーバから受け取るデータをメモリに保存するため短時間での小さいデータのやり取りを想定。
 ・URLSessionUploadTaskクラス:バックグラウンドで動作可能。時間がかかる通信にも適している。
 ・URlSessionDownloadTaskクラス:バックグラウンドで動作可能。時間がかかる通信位も適している。サーバからダウンロードしたデータをファイルに保存するため、メモリ使用量を抑えつつ大きいデータを受け取ることができる。
 
 */

let session2 = URLSession.shared
//URLRequest型の値と通信完了時のクロージャを渡す
let task2 = session2.dataTask(with: urlRequest) {
    data, urlResponse, error in
    //通信完了時に実行される
}

task2.resume()
