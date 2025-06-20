//%attributes = {}
//S3レスポンスのXMLをオブジェクトに変換

var $0; $data : Object
var $1; $xml : Text

ARRAY LONGINT:C221($alPosFound; 0)
ARRAY LONGINT:C221($alLenFound; 0)

var $start : Integer
var $contents : Object
var $eachXml : Text

$xml:=$1

If (Match regex:C1019("<ListBucketResult.*?>(.*?)</ListBucketResult>"; $xml; 1; $alPosFound; $alLenFound))
	$xml:=Substring:C12($xml; $alPosFound{1}; $alLenFound{1})
End if 

$data:=New object:C1471

$data.name:=""
$data.prefix:=""
$data.keyCount:=0
$data.maxKeys:=0
$data.isTruncated:=0
$data.nextContinuationToken:=""

If (Match regex:C1019("<Name.*?>(.*?)</Name>"; $xml; 1; $alPosFound; $alLenFound))
	$data.name:=Substring:C12($xml; $alPosFound{1}; $alLenFound{1})
End if 
If (Match regex:C1019("<Prefix.*?>(.*?)</Prefix>"; $xml; 1; $alPosFound; $alLenFound))
	$data.prefix:=Substring:C12($xml; $alPosFound{1}; $alLenFound{1})
End if 
If (Match regex:C1019("<KeyCount.*?>(.*?)</KeyCount>"; $xml; 1; $alPosFound; $alLenFound))
	$data.keyCount:=Num:C11(Substring:C12($xml; $alPosFound{1}; $alLenFound{1}))
End if 
If (Match regex:C1019("<MaxKeys.*?>(.*?)</MaxKeys>"; $xml; 1; $alPosFound; $alLenFound))
	$data.maxKeys:=Num:C11(Substring:C12($xml; $alPosFound{1}; $alLenFound{1}))
End if 
If (Match regex:C1019("<IsTruncated.*?>(.*?)</IsTruncated>"; $xml; 1; $alPosFound; $alLenFound))
	$data.isTruncated:=(Lowercase:C14(Substring:C12($xml; $alPosFound{1}; $alLenFound{1}))="true")
End if 
If (Match regex:C1019("<NextContinuationToken.*?>(.*?)</NextContinuationToken>"; $xml; 1; $alPosFound; $alLenFound))
	$data.nextContinuationToken:=Substring:C12($xml; $alPosFound{1}; $alLenFound{1})
End if 

$data.contents:=New collection:C1472

$start:=1

While (Match regex:C1019("<Contents>(.*?)</Contents>"; $xml; $start; $alPosFound; $alLenFound))
	
	$start:=$alPosFound{0}+$alLenFound{0}
	
	$contents:=New object:C1471
	$contents.key:=""
	$contents.lastModified:=""
	$contents.eTag:=""
	$contents.size:=0
	$contents.storageClass:=""
	
	//<Size>15</Size><StorageClass>STANDARD</StorageClass>
	
	$eachXml:=Substring:C12($xml; $alPosFound{1}; $alLenFound{1})
	
	If (Match regex:C1019("<Key.*?>(.*?)</Key>"; $eachXml; 1; $alPosFound; $alLenFound))
		$contents.key:=Substring:C12($eachXml; $alPosFound{1}; $alLenFound{1})
	End if 
	If (Match regex:C1019("<LastModified.*?>(.*?)</LastModified>"; $eachXml; 1; $alPosFound; $alLenFound))
		$contents.lastModified:=Substring:C12($eachXml; $alPosFound{1}; $alLenFound{1})
	End if 
	If (Match regex:C1019("<ETag.*?>(.*?)</ETag>"; $eachXml; 1; $alPosFound; $alLenFound))
		$contents.eTag:=Replace string:C233(Substring:C12($eachXml; $alPosFound{1}; $alLenFound{1}); "&quot;"; "")
	End if 
	If (Match regex:C1019("<Size.*?>(.*?)</Size>"; $eachXml; 1; $alPosFound; $alLenFound))
		$contents.size:=Num:C11(Substring:C12($eachXml; $alPosFound{1}; $alLenFound{1}))
	End if 
	If (Match regex:C1019("<StorageClass.*?>(.*?)</StorageClass>"; $eachXml; 1; $alPosFound; $alLenFound))
		$contents.storageClass:=Substring:C12($eachXml; $alPosFound{1}; $alLenFound{1})
	End if 
	
	$data.contents.push($contents)
	
End while 

$0:=$data
