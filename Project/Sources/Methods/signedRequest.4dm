//%attributes = {}

var $0; $request : Object
var $1; $params : Object
var $2; $METHOD : Text
var $3; $path : Text
var $4; $body : Blob
var $5; $queryString : Text
var $6; $extraHeaders : Object

var $amzOBJ : Object
var $queryString : Text
var $authHeader; $headers : Object
var $headerKeys : Collection
var $oneKey : Text

var $reqOpt : Object

$params:=$1
$METHOD:=$2
$path:=$3

If (Count parameters:C259>=4)
	$body:=$4
End if 

If (Count parameters:C259>=5)
	$queryString:=$5
End if 

If (Count parameters:C259>=6)
	$extraHeaders:=$6
Else 
	$extraHeaders:=New object:C1471
End if 

//認証用日時情報
$amzOBJ:=getAmzDate

//送信データのハッシュ
$payloadHash:=SHA256($body; Crypto HEX)

$authHeader:=getAuthorizationHeader($params; $METHOD; $path; $amzOBJ.amzDate; $amzOBJ.datestamp; $payloadHash; $queryString; $extraHeaders)

$headers:=New object:C1471
$headers["Host"]:=$params.host
$headers["x-amz-date"]:=$amzOBJ.amzDate
$headers["x-amz-content-sha256"]:=$payloadHash
$headers["Authorization"]:=$authHeader.authorization

$headerKeys:=OB Keys:C1719($extraHeaders)
For each ($oneKey; $headerKeys)
	$headers[$oneKey]:=$extraHeaders[$oneKey]
End for each 

$url:="https://"+$params.host+$path
If ($queryString#"")
	$url:=$url+"?"+$queryString
End if 

//リクエストオプション指定
$reqOpt:=New object:C1471
$reqOpt.method:=$METHOD
$reqOpt.headers:=$headers
$reqOpt.body:=$body

//HTTPリクエスト実施
$request:=4D:C1709.HTTPRequest.new($url; $reqOpt)
$request.wait()

$0:=$request
