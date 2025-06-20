//%attributes = {}
//16進数文字列をバイナリに変換する

var $1; $TXT : Text
var $0; $BLOB : Blob

var $len; $i; $sizeI; $pos : Integer

$TXT:=$1

$len:=Length:C16($TXT)

$sizeI:=$len/2
SET BLOB SIZE:C606($BLOB; $sizeI)

For ($i; 1; $sizeI)
	$pos:=$i-1
	$from:=($i*2)-1
	$str:=Substring:C12($TXT; $from; 2)
	$BLOB{$pos}:=hexToDec($str)
End for 

$0:=$BLOB
