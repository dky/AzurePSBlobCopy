### Source VHD
$srcVhd = "src.vhd"
$srcUri = "https://.blob.core.windows.net/vhds/$srcVhd"

### Source Storage Account ###
$srcStorageAccount = ""
$srcStorageKey = ""

### Target Storage Account ###
$destStorageAccount = ""
$destStorageKey = ""

### Target Container Name ###
$containerName = "vhds"

### Target VHD Name ###
$targetVhd = ".vhd"
 
### Create the source storage account context ###
$srcContext = New-AzureStorageContext  –StorageAccountName $srcStorageAccount `
                                        -StorageAccountKey $srcStorageKey
 
### Create the destination storage account context ### 
$destContext = New-AzureStorageContext  –StorageAccountName $destStorageAccount `
                                        -StorageAccountKey $destStorageKey
 
### Create the container on the destination ###
New-AzureStorageContainer -Name $containerName -Context $destContext
 
### Start the asynchronous copy - specify the source authentication with -SrcContext ###
$blob1 = Start-AzureStorageBlobCopy -srcUri $srcUri `
                                    -SrcContext $srcContext `
                                    -DestContainer $containerName `
                                    -DestBlob $targetVhd `
                                    -DestContext $destContext

### Retrieve the current status of the copy operation ###
$status = $blob1 | Get-AzureStorageBlobCopyState 

### Print out status ###
$status 

### Loop until complete ###
While($status.Status -eq "Pending"){
  $status = $blob1 | Get-AzureStorageBlobCopyState
  Start-Sleep 10
  ### Print out status ###
  $status
}
