//%attributes = {}

var $0; $fileSize : Real
var $1; $PATH : Text

var $docRef : Time

$PATH:=$1

$docRef:=Open document:C264($PATH; Read mode:K24:5)

$fileSize:=Get document size:C479($docRef)

CLOSE DOCUMENT:C267($docRef)

$0:=$fileSize
