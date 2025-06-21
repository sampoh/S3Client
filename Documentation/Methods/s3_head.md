< S3 APIによるファイル情報取得 >  
  
第1引数 ( 必須 ) : クライアントパラメータ 【 オブジェクト型 】  
戻り値 : 結果オブジェクト 【 オブジェクト型 】  
  
[ 戻り値の例 ]  
　{  
　　"success":true,  
　　"request":< HTTPリクエストの結果を格納 >,  
　　"file": {  
　　　　"contentLength": <ファイルのバイト数>,  
　　　　"contentType": <ファイルに設定された Content-Type ヘッダ>,  
　　　　"etag": <ファイル識別子>,  
　　　　"lastModified": {  
　　　　　　"utc": "2025-06-21T07:45:15Z"  
　　　　　　"jst": "2025-06-21T16:45:15+09:00",  
　　　　}  
　　},  
　　"error":< ON ERR CALL によるエラー情報 >,  
　}  