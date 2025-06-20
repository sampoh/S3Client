//%attributes = {}

var $1; $sec : Integer

var $waitTick : Integer
var $each : Integer

If (Count parameters:C259>=1)
	$sec:=$1
Else 
	$sec:=5
End if 
If ($sec<=0)
	$sec:=1
End if 

$waitTick:=$sec*60
$each:=30

While ($waitTick>0)
	DELAY PROCESS:C323(Current process:C322; $each)
	$waitTick:=$waitTick-$each
End while 
