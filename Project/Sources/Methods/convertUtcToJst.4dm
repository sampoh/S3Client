//%attributes = {}

var $0; $JST : Text
var $1; $UTC : Text

var $date : Date
var $time : Time
var $vdCurrent : Date
var $vhCurrent : Time

$UTC:=$1

$date:=Date:C102(Substring:C12($UTC; 1; 10))
$time:=Time:C179(Substring:C12($UTC; 12; 8))

$time:=$time+?09:00:00?

If ($time>=?24:00:00?)
	$date:=Add to date:C393($date; 0; 0; 1)
	$time:=$time-?24:00:00?
End if 

$JST:=Replace string:C233(String:C10($date; System date short:K1:1); "/"; "-")+\
"T"+String:C10($time; HH MM SS:K7:1)+"+09:00"

$0:=$JST
