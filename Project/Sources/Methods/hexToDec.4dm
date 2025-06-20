//%attributes = {}
//16進数文字列を数値に変換する

#DECLARE($hexa : Text)->$result : Integer
If (Count parameters:C259=1)
	$result:=Formula from string:C1601("0x"+$hexa).call()
End if 
