//%attributes = {}
//S3 APIのデフォルト設定

var $0; $opt : Object

If (Storage:C1525.s3=Null:C1517)
	
	$opt:=New object:C1471
	
	//基本設定
	$opt.partSize:=5*1024*1024  //分割サイズ - 5MB
	
	//リトライ設定
	$opt.upload:=New object:C1471
	$opt.upload.maxRetry:=10  //最大10回リトライ ( ※ 処理全体を通して )
	$opt.upload.maxRetryEach:=5  //最大5回リトライ ( ※ 個別の通信処理に対して )
	$opt.upload.retryWait:=3  //リトライ時の待機時間 ( 秒 )
	
	Use (Storage:C1525)
		Storage:C1525.s3:=OB Copy:C1225($opt; ck shared:K85:29)
	End use 
	
Else 
	$opt:=OB Copy:C1225(Storage:C1525.s3)
End if 

$0:=$opt
