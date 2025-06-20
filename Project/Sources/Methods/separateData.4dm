//%attributes = {}

var $1; $documentPath : Text

var $partSize : Integer
var $fileSize; $count : Integer
var $buffer : Blob
var $offset : Integer
var $i; $size : Integer
var $colBuffer : Collection
var $isLast : Boolean
var $lastSize : Integer

$documentPath:=$1

$def:=cast
$partSize:=$def.partSize


$docRef:=Open document:C264($documentPath; Read mode:K24:5)

$fileSize:=Get document size:C479($docRef)

$count:=($fileSize/$partSize)
If (($fileSize%$partSize)>0)
	$count:=$count+1
End if 

$colBuffer:=New collection:C1472
$size:=$count-1
For ($i; 0; $size)
	$offset:=$i*$partSize
	CLEAR VARIABLE:C89($buffer)
	RECEIVE PACKET:C104($docRef; $buffer; $partSize)
	
	$colBuffer.push($buffer)
	
End for 

CLOSE DOCUMENT:C267($docRef)

TRACE:C157

//$def:=cast
//$partSize:=$def.partSize

//$fileSize:=BLOB size($1)

//$count:=($fileSize/$partSize)

//If (($fileSize%$partSize)>0)
//$count:=$count+1
//End if 

//$colBuffer:=New collection
//$size:=$count-1
//For ($i; 0; $size)
//$offset:=$i*$partSize
//CLEAR VARIABLE($buffer)
//$isLast:=($i=$size)
//If ($isLast)
//$lastSize:=BLOB size($1)-($size*$partSize)
//COPY BLOB($1; $buffer; $offset; 0; $lastSize)
//Else 
//COPY BLOB($1; $buffer; $offset; 0; $partSize)
//End if 
//$colBuffer.push($buffer)

//End for 

//TRACE


