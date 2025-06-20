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

$params:=$1

$path:="/"+$params.bucket+"/"+$params.key

$request:=signedRequest($params; "DELETE"; $path)

$result:=New object:C1471
$result.success:=($request.response.status=204)
$result.request:=$request
$result.error:=err

$0:=$result

ON ERR CALL:C155("")
