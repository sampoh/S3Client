//%attributes = {"shared":true}
//< 進捗状況オブジェクトの取得 >

//戻り値 : 進捗状況オブジェクト 【 オブジェクト型 】

onErrCast
ON ERR CALL:C155("onErrMethod")

var $0; $progress : Object

var $percentile : Real

If (Storage:C1525.progress=Null:C1517)
	$percentile:=0
	$progress:=New object:C1471
	$progress.number:=$percentile
	$progress.string:=String:C10($percentile; "###0.00")+"%"
Else 
	$progress:=OB Copy:C1225(Storage:C1525.progress)
End if 

$0:=$progress

ON ERR CALL:C155("")
