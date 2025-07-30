//%attributes = {"shared":true}
//< S3 APIによるダウンロード >

//第1引数 ( 必須 ) : クライアントパラメータ 【 オブジェクト型 】
//第2引数 ( 必須 ) : ダウンロードするファイルへのフルパス 【 テキスト型 】
//第3引数 ( 任意 ) : ダウンロード時の分割サイズ ( バイト指定 )  【 整数型 】 ( ※ 未指定時は 5242880 ( = 5MB ) )
//戻り値 : 結果オブジェクト 【 オブジェクト型 】

//[ 戻り値の例 ]
//　{
//　　"success":true,
//　　"request":< 最終HTTPリクエストの結果を格納 >,
//　　"error":< ON ERR CALL によるエラー情報 >,
//　}

onErrCast
ON ERR CALL:C155("onErrMethod")

var $0; $result : Object
var $1; $params : Object
var $2; $downloadPath : Text
var $3; $partSize : Integer

var $FLG_ERROR; $FLG_SUCCESS : Boolean

var $path : Text
var $fileSize : Real
var $offset; $start; $end : Real
var $rangeHeader : Text
var $emptyBlob : Blob

var $percentile : Real
var $docRef : Time

s3_progress_set(0)

$result:=New object:C1471

If (Count parameters:C259>=2)
	
	$params:=$1
	$downloadPath:=$2
	
	$docRef:=Create document:C266($downloadPath)
	SET DOCUMENT POSITION:C482($docRef; 0)
	
	//分割サイズ - 最低5MB
	$def:=cast
	If (Count parameters:C259>=3)
		$partSize:=$3
		If ($partSize<$def.partSize)
			$partSize:=$def.partSize
		End if 
	Else 
		$partSize:=$def.partSize
	End if 
	
	$FLG_ERROR:=False:C215
	$FLG_SUCCESS:=False:C215
	
	$path:="/"+$params.bucket+"/"+$params.key
	
	//ヘッダ取得リクエスト
	$request:=signedRequest($params; "HEAD"; $path)
	
	If ($request.response.status=200)
		
		$fileSize:=Num:C11($request.response.headers["content-length"])
		
		For ($offset; 0; $fileSize; $partSize)
			$start:=$offset
			$end:=New collection:C1472(($offset+$partSize-1); ($fileSize-1)).min()
			$rangeHeader:="bytes="+String:C10($start)+"-"+String:C10($end)
			
			$request:=signedRequest($params; "GET"; $path; $emptyBlob; ""; ""; New object:C1471("Range"; $rangeHeader))
			
			If ($request.response.status=206)
				SEND PACKET:C103($docRef; $request.response.body)
				$percentile:=($end+1/$fileSize)
				s3_progress_set($percentile)
			Else 
				$FLG_ERROR:=True:C214
			End if 
			
		End for 
		
	Else 
		$FLG_ERROR:=True:C214
	End if 
	
	$FLG_SUCCESS:=Not:C34($FLG_ERROR)
	
	If ($FLG_SUCCESS)
		s3_progress_set(100)
	End if 
	
	CLOSE DOCUMENT:C267($docRef)
	
	$result.success:=$FLG_SUCCESS
	$result.request:=$request
	$result.error:=err
	
Else 
	$result.success:=False:C215
	$result.request:=New object:C1471
	$result.error:=New object:C1471
	$result.error.errCode:=-1
	$result.error.info:="第1および第2引数は必須です。"
	$result.error.lastErrors:=New collection:C1472
End if 

$0:=$result

ON ERR CALL:C155("")

