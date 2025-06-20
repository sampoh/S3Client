//%attributes = {}

var $1; $percentile : Real

var $progress : Object

$percentile:=$1

$progress:=New object:C1471
$progress.number:=$percentile
$progress.string:=String:C10($percentile; "###0.00")+"%"

Use (Storage:C1525)
	Storage:C1525.progress:=OB Copy:C1225($progress; ck shared:K85:29)
End use 

