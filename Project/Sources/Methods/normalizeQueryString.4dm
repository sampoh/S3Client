//%attributes = {}

var $0; $res : Text
var $1; $queryString : Text

var $splitOne; $splitTwo; $params : Collection
var $ONE : Text

$queryString:=$1

If ($queryString="")
	$res:=""
Else 
	$params:=New collection:C1472
	$splitOne:=Split string:C1554($queryString; "&")
	For each ($ONE; $splitOne)
		$splitTwo:=Split string:C1554($ONE; "=")
		Case of 
			: ($splitTwo.length=2)
				$params.push(uriEncode($splitTwo[0])+"="+uriEncode($splitTwo[1]))
			: ($splitTwo.length=1)
				$params.push(uriEncode($splitTwo[0])+"=")
		End case 
	End for each 
	$res:=$params.join("&")
End if 

$0:=$res
