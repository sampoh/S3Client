//%attributes = {"shared":true}
//< S3 APIによる削除 >

//第1引数 ( 必須 ) : クライアントパラメータ 【 オブジェクト型 】
//戻り値 : 結果オブジェクト 【 オブジェクト型 】

//[ 戻り値の例 ]
//　{
//　　"success":true,
//　　"request":< HTTPリクエストの結果を格納 >,
//　　"error":< ON ERR CALL によるエラー情報 >,
//　}

onErrCast
ON ERR CALL:C155("onErrMethod")

var $0; $result : Object
var $1; $params : Object

var $path : Text
var $request : Object

$result:=New object:C1471

If (Count parameters:C259>=1)
	
	$params:=$1
	
	$path:="/"+$params.bucket+"/"+$params.key
	
	$request:=signedRequest($params; "DELETE"; $path)
	
	$result.success:=($request.response.status=204)
	$result.request:=$request
	$result.error:=err
	
Else 
	$result.success:=False:C215
	$result.request:=New object:C1471
	$result.error:=New object:C1471
	$result.error.errCode:=-1
	$result.error.info:="第1引数は必須です。"
	$result.error.lastErrors:=New collection:C1472
End if 

$0:=$result

ON ERR CALL:C155("")
