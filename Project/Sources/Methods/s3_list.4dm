//%attributes = {"shared":true}
//< S3 APIでオブジェクト一覧取得 >

//第1引数 ( 必須 ) : クライアントパラメータ 【 オブジェクト型 】
//第2引数 ( 任意 ) : 検索プレフィックス 【 テキスト型 】 ( フォルダ指定などは "files/" のように指定可能 )
//第3引数 ( 任意 ) : 継続トークン  【 テキスト型 】 ( 複数ページの場合に前回リクエストの結果にある nextContinuationToken を設定 )
//戻り値 : 結果オブジェクト 【 オブジェクト型 】

//[ 戻り値の例 ]
//　{
//　　"success":true,
//　　"request":< HTTPリクエストの結果を格納 >,
//　　"nextContinuationToken":"<次ページがある場合ここに値が入る",
//　　"data":<一覧データ>,
//　　"error":< ON ERR CALL によるエラー情報 >,
//　}

onErrCast
ON ERR CALL:C155("onErrMethod")

var $0; $result : Object
var $1; $params : Object
var $2; $prefix : Text
var $3; $continuationToken : Text

var $path : Text
var $request : Object
var $emptyBlob : Blob
var $queryString; $nativeQueryString : Text

$result:=New object:C1471

If (Count parameters:C259>=1)
	
	$params:=$1
	
	If (Count parameters:C259>=2)
		$prefix:=$2
	End if 
	
	If (Count parameters:C259>=3)
		$continuationToken:=$3
	End if 
	
	$path:="/"+$params.bucket
	
	//クエリパラメータはASCIIコード順にする必要があるため注意 ( continuation-token → list-type → prefix )
	
	$queryString:=""
	$nativeQueryString:=""
	
	If ($continuationToken#"")
		If ($queryString#"")
			$queryString:=$queryString+"&"
			$nativeQueryString:=$nativeQueryString+"&"
		End if 
		//$queryString:=$queryString+uriEncode("continuation-token")+"="+uriEncode($continuationToken)
		//↓不具合修正
		$queryString:=$queryString+uriEncodeExceptSlash("continuation-token")+"="+uriEncodeExceptSlash($continuationToken)
		$nativeQueryString:=$nativeQueryString+"continuation-token="+$continuationToken
	End if 
	
	If ($queryString#"")
		$queryString:=$queryString+"&"
		$nativeQueryString:=$nativeQueryString+"&"
	End if 
	$queryString:=$queryString+uriEncodeExceptSlash("list-type")+"=2"
	$nativeQueryString:=$nativeQueryString+"list-type=2"
	
	If ($prefix#"")
		//$queryString:=$queryString+"&prefix="+uriEncode($prefix)
		//↓不具合修正
		$queryString:=$queryString+"&prefix="+uriEncodeExceptSlash($prefix)
		$nativeQueryString:=$nativeQueryString+"&prefix="+$prefix
	End if 
	
	$request:=signedRequest($params; "GET"; $path; $emptyBlob; $queryString; $nativeQueryString)
	
	$result.success:=($request.response.status=200)
	$result.request:=$request
	$result.nextContinuationToken:=""
	$result.data:=New object:C1471
	If ($result.success)
		$result.data:=parseXml($request.response.body)
		$result.nextContinuationToken:=$result.data.nextContinuationToken
	End if 
	
	$result.error:=err
	
Else 
	$result.success:=False:C215
	$result.request:=New object:C1471
	$result.nextContinuationToken:=""
	$result.data:=New object:C1471
	$result.error:=New object:C1471
	$result.error.errCode:=-1
	$result.error.info:="第1引数は必須です。"
	$result.error.lastErrors:=New collection:C1472
End if 

$0:=$result

ON ERR CALL:C155("")
