//%attributes = {}
//S3シグネチャ生成

var $0; $signature : Text
var $1; $datestamp : Text
var $2; $auth : Object
var $3; $stringToSign : Text

var $bDatestamp; $bAWS4 : Blob
var $kDate : Text
var $bkDate; $bAuthRegion : Blob
var $kRegion : Text
var $bkRegion; $bAuthService : Blob
var $kService : Text
var $bkService; $bAws4Req : Blob
var $kSigning : Text
var $bkSigning; $bStringToSign : Blob

$datestamp:=$1
$auth:=$2
$stringToSign:=$3

TEXT TO BLOB:C554($datestamp; $bDatestamp; UTF8 text without length:K22:17)
TEXT TO BLOB:C554("AWS4"+$auth.secretkey; $bAWS4; UTF8 text without length:K22:17)

$signingKey:=New object:C1471

$kDate:=HMACSHA256($bAWS4; $bDatestamp; Crypto HEX)

$bkDate:=hexToBlob($kDate)
TEXT TO BLOB:C554($auth.region; $bAuthRegion; UTF8 text without length:K22:17)

$kRegion:=HMACSHA256($bkDate; $bAuthRegion; Crypto HEX)

$bkRegion:=hexToBlob($kRegion)
TEXT TO BLOB:C554($auth.service; $bAuthService; UTF8 text without length:K22:17)

$kService:=HMACSHA256($bkRegion; $bAuthService; Crypto HEX)

$bkService:=hexToBlob($kService)
TEXT TO BLOB:C554("aws4_request"; $bAws4Req; UTF8 text without length:K22:17)

$kSigning:=HMACSHA256($bkService; $bAws4Req; Crypto HEX)

$bkSigning:=hexToBlob($kSigning)
TEXT TO BLOB:C554($stringToSign; $bStringToSign; UTF8 text without length:K22:17)

$signature:=HMACSHA256($bkSigning; $bStringToSign; Crypto HEX)

$0:=$signature

