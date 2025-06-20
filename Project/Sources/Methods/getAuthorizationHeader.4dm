//%attributes = {}

var $0 : Object
var $1; $params : Object
var $2; $METHOD : Text
var $3; $path : Text
var $4; $amzDate : Text
var $5; $datestamp : Text
var $6; $payloadHash : Text
var $7; $queryString : Text
var $8; $additionalHeaders : Object

var $credentialScope : Text
var $canonicalPath; $canonicalQueryString : Text
var $allHeaders; $headerSorted : Object
var $signedHeaders; $canonicalHeaders; $canonicalRequest; $stringToSign : Text
var $bCanonicalRequest : Blob
var $signingKey; $bStringToSign : Blob
var $authorization : Text

$params:=$1
$METHOD:=$2
$path:=$3
$amzDate:=$4
$datestamp:=$5
$payloadHash:=$6
$queryString:=$7

If (Count parameters:C259>=8)
	$additionalHeaders:=OB Copy:C1225($8)
Else 
	$additionalHeaders:=New object:C1471
End if 

$credentialScope:=$datestamp+"/"+$params.region+"/"+$params.service+"/aws4_request"

$canonicalPath:=uriEncodeExceptSlash($path)

$canonicalQueryString:=normalizeQueryString($queryString)

$allHeaders:=$additionalHeaders

$allHeaders["host"]:=$params.host
$allHeaders["x-amz-content-sha256"]:=$payloadHash
$allHeaders["x-amz-date"]:=$amzDate

$headerSorted:=sortElementInObject($allHeaders)

$signedHeaders:=$headerSorted.keys.lowercase.join(";")

$canonicalHeaders:=$headerSorted.col.join(Char:C90(Line feed:K15:40))+Char:C90(Line feed:K15:40)

$canonicalRequest:=New collection:C1472(\
$METHOD; \
$canonicalPath; \
$canonicalQueryString; \
$canonicalHeaders; \
$signedHeaders; \
$payloadHash).join(Char:C90(Line feed:K15:40))

TEXT TO BLOB:C554($canonicalRequest; $bCanonicalRequest; UTF8 text without length:K22:17)

$stringToSign:=New collection:C1472(\
"AWS4-HMAC-SHA256"; \
$amzDate; \
$credentialScope; \
SHA256($bCanonicalRequest; Crypto HEX)).join(Char:C90(Line feed:K15:40))

TEXT TO BLOB:C554($stringToSign; $bStringToSign; UTF8 text without length:K22:17)

$signingKey:=getSigningKey($params; $datestamp)
$signature:=HMACSHA256($signingKey; $bStringToSign; Crypto HEX)


$authorization:=\
"AWS4-HMAC-SHA256 Credential="+\
$params.accesskey+"/"+$credentialScope+\
", SignedHeaders="+$signedHeaders+", Signature="+$signature

$0:=New object:C1471(\
"authorization"; $authorization; \
"signedHeaders"; $signedHeaders; \
"canonicalRequest"; $canonicalRequest; \
"stringToSign"; $stringToSign)


