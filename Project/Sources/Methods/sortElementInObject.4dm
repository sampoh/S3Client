//%attributes = {}

var $0; $OUT : Object
var $1; $IN : Object

var $keys : Collection
var $i; $sizeI : Integer

$IN:=$1

$keys:=OB Keys:C1719($IN)

$OUT:=New object:C1471
$OUT.keys:=New object:C1471
$OUT.keys.sorted:=$keys.sort(Formula:C1597(Lowercase:C14($1.value)<Lowercase:C14($1.value2)))
$OUT.keys.lowercase:=$OUT.keys.sorted.map(Formula:C1597(Lowercase:C14($1.value)))

$OUT.fixed:=New object:C1471
$OUT.col:=New collection:C1472

$sizeI:=$OUT.keys.sorted.length-1
For ($i; 0; $sizeI)
	$OUT.fixed[$OUT.keys.lowercase[$i]]:=$IN[$OUT.keys.sorted[$i]]
	$OUT.col.push($OUT.keys.lowercase[$i]+":"+String:C10($IN[$OUT.keys.sorted[$i]]))
End for 

$0:=$OUT

