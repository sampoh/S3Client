//%attributes = {}

var err : Object

err:=New object:C1471
err.errCode:=0
err.info:=""
err.lastErrors:=New collection:C1472

If (Storage:C1525.error=Null:C1517)
	Use (Storage:C1525)
		Storage:C1525.error:=OB Copy:C1225(err; ck shared:K85:29)
	End use 
End if 


