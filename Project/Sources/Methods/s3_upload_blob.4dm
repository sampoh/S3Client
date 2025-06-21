//%attributes = {"shared":true}
//< S3 APIによるアップロード >

//第1引数 ( 必須 ) : クライアントパラメータ 【 オブジェクト型 】
//第2引数 ( 必須 ) : アップロードするBLOB 【 BLOB型 】
//第3引数 ( 任意 ) : ファイルに設定しする Content-Type 【 テキスト型 】 ( ※ 未指定時は "application/octet-stream" )
//第4引数 ( 任意 ) : アップロード時の分割サイズ ( バイト指定 )  【 整数型 】 ( ※ 未指定時は 5242880 ( = 5MB ) )
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
var $2 : Blob
var $3; $contentType : Text
var $4; $partSize : Integer

var $def : Object
var $amzOBJ; $request : Object
var $emptyBlob : Blob
var $resBody; $uploadId : Text

var $def : Object
var $fileSize : Real
var $i; $sizeI; $partNum; $count : Integer
var $queryString : Text
var $FLG_ERROR; $FLG_SUCCESS : Boolean
var $buffer : Blob
var $bufferSize : Real
var $bufferSizeUploaded : Real
var $percentile : Real

var $NEXT_STEP : Boolean
var $retry : Object

var $etag : Text
var $etags : Collection
var $completeXml; $ONE : Text
var $completeBlob : Blob

s3_progress_set(0)

$result:=New object:C1471

If (Count parameters:C259>=1)
	
	$params:=$1
	
	If (Count parameters:C259>=3)
		$contentType:=$3
	Else 
		$contentType:="application/octet-stream"
	End if 
	
	//分割サイズ - 最低5MB
	$def:=cast
	If (Count parameters:C259>=4)
		$partSize:=$4
		If ($partSize<$def.partSize)
			$partSize:=$def.partSize
		End if 
	Else 
		$partSize:=$def.partSize
	End if 
	
	$path:="/"+$params.bucket+"/"+$params.key
	
	//マルチパート開始宣言リクエスト
	$request:=signedRequest($params; "POST"; $path; $emptyBlob; "uploads"; New object:C1471("Content-Type"; $contentType))
	
	If ($request.response.status=200)
		$resBody:=Convert to text:C1012($request.response.body; "UTF-8")
		$uploadId:=getUploadId($resBody)
	End if 
	
	$def:=cast
	$partSize:=$def.partSize
	
	$etags:=New collection:C1472
	$FLG_ERROR:=False:C215
	$FLG_SUCCESS:=False:C215
	
	$retry:=New object:C1471
	$retry.retry:=0  //処理全体を通したリトライ回数カウント
	$retry.retryEach:=0  //個別の通信ごとのリトライ回数カウント
	
	If ($uploadId#"")
		
		$fileSize:=BLOB size:C605($2)
		
		$count:=Trunc:C95($fileSize/$partSize; 0)
		If (($fileSize%$partSize)>0)
			$count:=$count+1
		End if 
		
		$bufferSizeUploaded:=0
		CLEAR VARIABLE:C89($buffer)
		
		$sizeI:=$count-1
		For ($i; 0; $sizeI)
			
			$partNum:=$i+1
			$queryString:="partNumber="+String:C10($partNum)+"&uploadId="+uriEncode($uploadId)
			
			$offset:=$i*$partSize
			CLEAR VARIABLE:C89($buffer)
			$isLast:=($i=$sizeI)
			If ($isLast)
				$lastSize:=BLOB size:C605($2)-($sizeI*$partSize)
				COPY BLOB:C558($2; $buffer; $offset; 0; $lastSize)
			Else 
				COPY BLOB:C558($2; $buffer; $offset; 0; $partSize)
			End if 
			
			$bufferSize:=BLOB size:C605($buffer)
			$bufferSizeUploaded:=$bufferSizeUploaded+$bufferSize
			
			$retry.retryEach:=0
			
			Repeat 
				
				//マルチパートアップロード
				$request:=signedRequest($params; "PUT"; $path; $buffer; $queryString; New object:C1471(\
					"Content-Length"; BLOB size:C605($buffer)))
				
				$NEXT_STEP:=Not:C34(isRetryHttpCode($request.response.status))
				
				If (Not:C34($NEXT_STEP))
					
					If (\
						($retry.retry>=$def.upload.retry) | \
						($retry.retryEach>=$def.upload.maxRetryEach))
						$NEXT_STEP:=True:C214
						$FLG_ERROR:=True:C214
						$i:=$sizeI+1
					Else 
						$retry.retry:=$retry.retry+1
						$retry.retryEach:=$retry.retryEach+1
						delay($def.upload.retryWait)
					End if 
					
				End if 
				
			Until ($NEXT_STEP)
			
			CLEAR VARIABLE:C89($buffer)
			
			If ($request.response.status=200)
				//OK
				$etag:=Replace string:C233($request.response.headers["etag"]; "\""; "")
				$etags.push(New object:C1471("PartNumber"; $partNum; "ETag"; $etag))
				
				$percentile:=$bufferSizeUploaded/$fileSize
				s3_progress_set($percentile)
				
			Else 
				//NG
				$FLG_ERROR:=True:C214
				$i:=$sizeI+1
			End if 
			
		End for 
		
	End if 
	
	If (Not:C34($FLG_ERROR))
		
		$completeXml:="<CompleteMultipartUpload>"+\
			$etags.map(Formula:C1597("<Part><PartNumber>"+String:C10($1.value.PartNumber)+"</PartNumber><ETag>"+$1.value.ETag+"</ETag></Part>")).join("")+\
			"</CompleteMultipartUpload>"
		
		CONVERT FROM TEXT:C1011($completeXml; "utf-8"; $completeBlob)
		
		$queryString:="uploadId="+uriEncode($uploadId)
		
		//マルチパート完了
		$request:=signedRequest($params; "POST"; $path; $completeBlob; $queryString; New object:C1471(\
			"Content-Type"; "application/xml"; \
			"Content-Length"; BLOB size:C605($completeBlob)))
		
		If ($request.response.status=200)
			//OK
			$FLG_SUCCESS:=True:C214
			s3_progress_set(100)
		End if 
		
	End if 
	
	$result.success:=$FLG_SUCCESS
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
