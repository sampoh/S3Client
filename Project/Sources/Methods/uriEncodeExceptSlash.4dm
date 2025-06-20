//%attributes = {}
//スラッシュ以外をURLエンコード

var $1; $IN : Text

var $preArr : Collection
var $encodedArr : Collection
var $ONE : Text
var $OUT : Text

$IN:=$1

$preArr:=Split string:C1554($IN; "/")

$encodedArr:=New collection:C1472
For each ($ONE; $preArr)
	$encodedArr.push(uriEncode($ONE))
End for each 

$OUT:=$encodedArr.join("/")

$0:=$OUT
