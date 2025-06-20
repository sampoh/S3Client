//%attributes = {}

var $1 : Blob

var $partSize : Integer
var $fileSize; $count : Integer
var $buffer : Blob
var $offset : Integer
var $i; $size : Integer
var $colBuffer : Collection
var $isLast : Boolean
var $lastSize : Integer

$def:=cast
$partSize:=$def.partSize

$fileSize:=BLOB size:C605($1)

$count:=($fileSize/$partSize)

If (($fileSize%$partSize)>0)
	$count:=$count+1
End if 

$colBuffer:=New collection:C1472
$size:=$count-1
For ($i; 0; $size)
	$offset:=$i*$partSize
	CLEAR VARIABLE:C89($buffer)
	$isLast:=($i=$size)
	If ($isLast)
		$lastSize:=BLOB size:C605($1)-($size*$partSize)
		COPY BLOB:C558($1; $buffer; $offset; 0; $lastSize)
	Else 
		COPY BLOB:C558($1; $buffer; $offset; 0; $partSize)
	End if 
	$colBuffer.push($buffer)
	
End for 

TRACE:C157


