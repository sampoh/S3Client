//%attributes = {}

//"Sat, 21 Jun 2025 07:45:15 GMT"
//のようなUTC文字列を
//"2025-06-21T07:45:15Z"
//に変換する処理

var $0; $dateStrUTC : Text
var $1; $str : Text

var $pattern : Text
ARRAY LONGINT:C221($alPosFound; 0)
ARRAY LONGINT:C221($alLenFound; 0)

var $date : Date
var $wDay : Text
var $nDay : Integer
var $monStr : Text
var $year : Integer
var $timeStr : Text
var $month : Integer

$str:=$1

$pattern:="^([a-zA-Z]+),\\s([0-9]+)\\s([a-zA-Z]+)\\s([0-9]+)\\s([0-9]{2}:[0-9]{2}:[0-9]{2})\\sGMT$"

If (Match regex:C1019($pattern; $str; 1; $alPosFound; $alLenFound))
	$wDay:=Substring:C12($str; $alPosFound{1}; $alLenFound{1})
	$nDay:=Num:C11(Substring:C12($str; $alPosFound{2}; $alLenFound{2}))
	$monStr:=Substring:C12($str; $alPosFound{3}; $alLenFound{3})
	$year:=Num:C11(Substring:C12($str; $alPosFound{4}; $alLenFound{4}))
	$timeStr:=Substring:C12($str; $alPosFound{5}; $alLenFound{5})
End if 

$month:=New collection:C1472("jan"; "feb"; "mar"; "apr"; "may"; "jun"; "jul"; "aug"; "sep"; "oct"; "nov"; "dec").findIndex(Formula:C1597($1.value=$2); Lowercase:C14($monStr))+1


$dateStrUTC:=\
String:C10($year)+"-"+\
String:C10($month; "00")+"-"+\
String:C10($nDay; "00")+"T"+\
$timeStr+"Z"

$0:=$dateStrUTC
