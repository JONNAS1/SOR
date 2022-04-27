#Para crear grupos, escribimos lo siguinete en el archivo ps1:
$dominio="edu-gva.es"
$path= "dc=caminas,dc=edu-gva,dc=es"
if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el módulo
}

$fileUsersCsv=Read-Host "Introduce el fichero csv de los grupos"
$fichero = import-csv -Path $fileUsersCsv -Delimiter ";"
foreach($linea in $fichero)
{
$path_OU=$linea.Path +","+$path
NEW-ADGroup -Name $linea.Name -Description $linea.Description -Path $path_OU -GroupScope $linea.Scope
}
