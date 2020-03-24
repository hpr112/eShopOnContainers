Param(
    [parameter(Mandatory=$false)][string]$rg,
    [parameter(Mandatory=$false)][string]$name,
    [parameter(Mandatory=$false)][string]$namespace="default"
)

$specifyCluster=$false

if(-not [string]::IsNullOrEmpty($rg) -or -not [string]::IsNullOrEmpty($name)) {
    $specifyCluster=$true
    if([string]::IsNullOrEmpty($rg) -or [string]::IsNullOrEmpty($name)) {
        Write-Host "Error: must use -rg and -name when specifying cluster" -ForegroundColor Red
        exit 1
    }
}

if($specifyCluster) {
    az aks Get-Credentials -n $name -g $rg
}

if (!$?) {
    Write-Host "Error: wrong cluster name or resource group" -ForeGoundColor Red
    exit 1
}

Write-Host "Deleting all in cluster $name in resource group $rg"

$contents = ("deployments", "pods", "secrets", "replicasets", "configmaps", "ingresses", "services")

foreach ($content in $contents) {
    kubectl delete --all $content --namespace=$namespace
    Write-Host "All $content deleted from namespace $namespace" -ForegroundColor Green
}