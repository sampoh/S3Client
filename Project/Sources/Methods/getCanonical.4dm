//%attributes = {}

var $0; $canonical : Object
var $1; $params : Object
var $2; $amzDate : Text
var $3; $payloadHash : Text

var $canonicalBlob : Blob

$params:=$1
$amzDate:=$2
$payloadHash:=$3

$canonical:=New object:C1471

$canonical.request:=New collection:C1472(\
"PUT"; \
"/"+$params.bucket+"/"+$params.key; \
""; \
"host:"+$params.host; \
"x-amz-content-sha256:"+$payloadHash; \
"x-amz-date:"+$amzDate; \
""; \
"host;x-amz-content-sha256;x-amz-date"; \
$payloadHash).join(Char:C90(Line feed:K15:40))

TEXT TO BLOB:C554($canonical.request; $canonicalBlob; UTF8 text without length:K22:17)

$canonical.hash:=SHA256($canonicalBlob; Crypto HEX)

$0:=$canonical
