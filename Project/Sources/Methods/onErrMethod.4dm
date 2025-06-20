//%attributes = {}

var $p : Integer

err.errCode:=error
err.info:=Error method+" 行番号"+String:C10(Error line)
err.lastErrors:=Last errors:C1799

$p:=New process:C317("onErrMethod_p"; 0; "onErrMethod_p"; err)
