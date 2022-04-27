#Para crear UOS en el archivo ps1:
$dominio="edu-gva.es"
$dc="dc=caminas,dc=edu-gva,dc=es"
Write-Host $dc
$Path=$linea.Path+","+$dc	
$ficheroCsvUO=Read-Host "Introduce el fichero csv de UO's:"
$fichero = import-csv -Path $ficheroCsvUO -delimiter :
foreach($linea in $fichero)
{
   New-ADOrganizationalUnit -Description:$linea.Description -Name:$linea.Name -Path:$Path -ProtectedFromAccidentalDeletion:$true
}
