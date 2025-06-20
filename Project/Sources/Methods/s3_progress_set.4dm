//%attributes = {"shared":true}
//< 進捗状況の更新 >

//第1引数 : 進捗状況パーセント値 【 実数型 】
//※ 主に 0 クリアのために実装

onErrCast
ON ERR CALL:C155("onErrMethod")

var $1; $percentile : Real

var $p : Integer

$percentile:=$1

$p:=New process:C317("s3_progress_set_p"; 0; "s3_progress_set_p"; $percentile)

ON ERR CALL:C155("")
