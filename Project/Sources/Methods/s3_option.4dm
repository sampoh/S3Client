//%attributes = {"shared":true}
//< S3 APIの通信設定 >

//第1引数 : 設定を格納したオブジェクト 【 オブジェクト型 】
//戻り値 : 反映後の設定値 【 オブジェクト型 】

//[ 設定可能な項目 ( いずれも任意 ) ]
//　{
//　　"partSize":< アップロード時の分割サイズ(バイト数) ( 数値 ) >,
//　　"upload":{
//　　　"maxRetry":< アップロード処理全体を通したリトライ上限回数 ( 数値 ) >,
//　　　"maxRetryEach":< アップロード処理の個別通信処理のリトライ上限回数 ( 数値 ) >,
//　　　"retryWait":< リトライ時の待機時間(秒) ( 数値 ) >
//　　}
//　}

//[ デフォルト値 ]
//　{
//　　"partSize":5242880,
//　　"upload":{
//　　　"maxRetry":10,
//　　　"maxRetryEach":5,
//　　　"retryWait":3
//　　}
//　}

onErrCast
ON ERR CALL:C155("onErrMethod")

var $0; $current : Object
var $1; $fix : Object

var $execute : Boolean
var $default : Object

$execute:=(Count parameters:C259>=1)

If ($execute)
	$execute:=OB Is defined:C1231($1)
End if 

If ($execute)
	
	$fix:=OB Copy:C1225($1)
	
	$default:=cast
	
	If ($fix.partSize=Null:C1517)
		$fix.partSize:=$default.partSize
	End if 
	
	If ($fix.upload=Null:C1517)
		$fix.upload:=$default.upload
	Else 
		If (OB Is defined:C1231($fix.upload))
			
			If ($fix.upload.maxRetry=Null:C1517)
				$fix.upload.maxRetry:=$default.upload.maxRetry
			Else 
				$fix.upload.maxRetry:=Num:C11($fix.upload.maxRetry)
				If ($fix.upload.maxRetry<0)
					$fix.upload.maxRetry:=0
				End if 
			End if 
			
			If ($fix.upload.maxRetryEach=Null:C1517)
				$fix.upload.maxRetryEach:=$default.upload.maxRetryEach
			Else 
				$fix.upload.maxRetryEach:=Num:C11($fix.upload.maxRetryEach)
				If ($fix.upload.maxRetryEach<0)
					$fix.upload.maxRetryEach:=0
				End if 
			End if 
			
			If ($fix.upload.retryWait=Null:C1517)
				$fix.upload.retryWait:=$default.upload.retryWait
			Else 
				$fix.upload.retryWait:=Num:C11($fix.upload.retryWait)
				If ($fix.upload.retryWait<0)
					$fix.upload.retryWait:=0
				End if 
			End if 
			
		End if 
	End if 
	
	Use (Storage:C1525)
		Storage:C1525.s3:=OB Copy:C1225($fix; ck shared:K85:29)
	End use 
	
End if 

$current:=cast

$0:=$current

ON ERR CALL:C155("")
