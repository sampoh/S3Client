//%attributes = {}

var $0; $bkSigning : Blob
var $1; $params : Object
var $2; $datestamp : Text

var $bDatestamp; $bAWS4 : Blob
var $kDate : Text
var $bkDate; $bAuthRegion : Blob
var $kRegion : Text
var $bkRegion; $bAuthService : Blob
var $kService : Text
var $bkService; $bAws4Req : Blob
var $kSigning : Text

$params:=$1
$datestamp:=$2

TEXT TO BLOB:C554($datestamp; $bDatestamp; UTF8 text without length:K22:17)
TEXT TO BLOB:C554("AWS4"+$params.secretkey; $bAWS4; UTF8 text without length:K22:17)

$kDate:=HMACSHA256($bAWS4; $bDatestamp; Crypto HEX)

$bkDate:=hexToBlob($kDate)
TEXT TO BLOB:C554($params.region; $bAuthRegion; UTF8 text without length:K22:17)

$kRegion:=HMACSHA256($bkDate; $bAuthRegion; Crypto HEX)

$bkRegion:=hexToBlob($kRegion)
TEXT TO BLOB:C554($params.service; $bAuthService; UTF8 text without length:K22:17)

$kService:=HMACSHA256($bkRegion; $bAuthService; Crypto HEX)

$bkService:=hexToBlob($kService)
TEXT TO BLOB:C554("aws4_request"; $bAws4Req; UTF8 text without length:K22:17)

$kSigning:=HMACSHA256($bkService; $bAws4Req; Crypto HEX)
$bkSigning:=hexToBlob($kSigning)

$0:=$bkSigning
