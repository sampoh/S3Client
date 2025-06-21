//%attributes = {"shared":true}
//< S3 APIによるファイル情報取得 >

//第1引数 ( 必須 ) : クライアントパラメータ 【 オブジェクト型 】
//戻り値 : 結果オブジェクト 【 オブジェクト型 】

//[ 戻り値の例 ]
//　{
//　　"success":true,
//　　"request":< HTTPリクエストの結果を格納 >,
//　　"file": {
//　　　　"contentLength": <ファイルのバイト数>,
//　　　　"contentType": <ファイルに設定された Content-Type ヘッダ>,
//　　　　"etag": <ファイル識別子>,
//　　　　"lastModified": {
//　　　　　　"utc": "2025-06-21T07:45:15Z"
//　　　　　　"jst": "2025-06-21T16:45:15+09:00",
//　　　　}
//　　},
//　　"error":< ON ERR CALL によるエラー情報 >,
//　}

onErrCast
ON ERR CALL:C155("onErrMethod")

var $0; $result : Object
var $1; $params : Object

var $path : Text
var $request : Object
var $dateStr : Text

$result:=New object:C1471

If (Count parameters:C259>=1)
	
	$params:=$1
	
	$path:="/"+$params.bucket+"/"+$params.key
	
	//ヘッダ取得リクエスト
	$request:=signedRequest($params; "HEAD"; $path)
	
	
	$result.file:=New object:C1471
	
	If ($request.response.status=200)
		$result.file.contentLength:=Num:C11($request.response.headers["content-length"])
		$result.file.contentType:=$request.response.headers["content-type"]
		$result.file.etag:=Replace string:C233($request.response.headers["etag"]; "\""; "")
		$result.file.lastModified:=New object:C1471
		$result.file.lastModified.utc:=convertDateStr($request.response.headers["last-modified"])
		$result.file.lastModified.jst:=convertUtcToJst($result.file.lastModified.utc)
	End if 
	
	$result.success:=($request.response.status=200)
	$result.request:=$request
	$result.error:=err
	
Else 
	$result.success:=False:C215
	$result.request:=New object:C1471
	$result.file:=New object:C1471
	$result.error:=New object:C1471
	$result.error.errCode:=-1
	$result.error.info:="第1引数は必須です。"
	$result.error.lastErrors:=New collection:C1472
End if 

$0:=$result

ON ERR CALL:C155("")
