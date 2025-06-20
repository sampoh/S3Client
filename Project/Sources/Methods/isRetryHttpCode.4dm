//%attributes = {}
//リトライ対象のHTTP CODEに True を返す処理

var $0; $FLG_RETRY : Boolean
var $1; $httpCode : Integer

var $retryCodes : Collection
var $index : Integer

$httpCode:=$1

$retryCodes:=New collection:C1472
$retryCodes.push(500)  //Internal Server Error
$retryCodes.push(502)  //Bad Gateway
$retryCodes.push(503)  //Service Unavailable
$retryCodes.push(504)  //Gateway Timeout
$retryCodes.push(408)  //Request Timeout
$retryCodes.push(429)  //Too Many Requests
$retryCodes.push(0)  //ネットワークエラー

$index:=$retryCodes.indexOf($httpCode)

$FLG_RETRY:=($index>=0)

$0:=$FLG_RETRY

