//%attributes = {}
//S3 APIの最大分割数 10000 に応じた分割サイズ補正

var $0; $1; $partSize : Integer  //分割サイズ
var $2; $fileSize : Real  //ファイルサイズ

var $maxFileCountWasabi : Integer
var $safetyMargin : Integer
var $FLG_FIX : Boolean

$partSize:=$1
$fileSize:=$2

$maxFileCountWasabi:=10000  //S3 APIの最大分割数
$safetyMargin:=98  //ギリギリにしないためのマージン(98%)

$maxFileCountWasabi:=Trunc:C95($maxFileCountWasabi*($safetyMargin/100); 0)

If (($partSize*$maxFileCountWasabi)<$fileSize)
	$partSize:=Trunc:C95($fileSize/$maxFileCountWasabi; 0)+1
End if 

$0:=$partSize
