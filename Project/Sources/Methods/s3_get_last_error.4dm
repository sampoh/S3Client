//%attributes = {"shared":true}
//< 最終エラー情報を含むオブジェクトを取得 >
//戻り値 : エラーオブジェクト 【 オブジェクト型 】

var $0; $err : Object

onErrCast

$err:=OB Copy:C1225(Storage:C1525.error)

$0:=$err
