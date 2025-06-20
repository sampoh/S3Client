//%attributes = {}

var $0; $uploadId : Text
var $1; $body : Text

ARRAY LONGINT:C221($alPosFound; 0)
ARRAY LONGINT:C221($alLenFound; 0)

$body:=$1

If (Match regex:C1019("<UploadId>(.*?)</UploadId>"; $body; 1; $alPosFound; $alLenFound))
	$uploadId:=Substring:C12($body; $alPosFound{1}; $alLenFound{1})
End if 

$0:=$uploadId
