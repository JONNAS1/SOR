#Para crear nuestro nuevo dominio, hacemos uso del siguiente comando:
Install-ADDSForest -DatabasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" -SYSVOLPath "C:\Windows\SYSVOL" -DomainName "edu-gva.es" -DomainNetBIOSName "dominio" -ForestMode "Win2012" -InstallDNS:$true -NoRebootOnCompletion:$false -Force:$true
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Para crear un nuevo dominio secundario llamado Repl.iescaminas en el bosque llamado edu-gva.es y que el sistema pida especificar y confirmar una contraseña enmascarada, usamos el sguiente comnado:
Install-ADDSDomain "NewDomainName Repl.iescaminas "ParentDomainName edu-gva.es "DomainType Child
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Para instalar el servidor DNS, desde PowerShell usamos el siguiente comando:
Install-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools -Restart
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Para instalar el módulo de Active Directory en PowerShell, usamos el siguiente comando:
Install-WindowsFeature -Name RSAT-AD-PowerShell -IncludeAllSubfeature -IncludeManagementTools -Restart
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Script de a implementación del controlador de dominio:
##
# Install-ADDSForest -DatabasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" -SYSVOLPath "C:\Windows\SYSVOL" -DomainName "dominio.local" -DomainNetBIOSName "dominio" -ForestMode "Win2012" -InstallDNS:$true -NoRebootOnCompletion:$false -Force:$trueScript de WindowsPowershell para la implementación de AD DS
#

Import-Module ADDSDeployment 
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Window\NTDS" `
-DomainMode "WinThreshold" `
-DomainNetbiosName "EDU-GVA" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath  "C\Windows\NTDS" `
-NoRebooOCompletion:$false ` 
-SysvolPath "C:\WindowsªSYSVOL" `
-Force:$true
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Script de a implementación de AD DS al subdominio (asignación de subdominio a bosque existente):
#
# Script de Windows PowerShell para implementación de AD DS
#

Import-Module ADDSDeployment
Install-ADDSDomain `
-NoGlobalCatalog:$false `
-CreateDnsDelegation:$true `
-Credential (Get-Credential) `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainType "ChildDomain" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NewDomainName "caminas" `
-NewDomainNetbiosName "CAMINAS" `
-ParentDomainName "edu-gva.es" `
-NoRebootOnCompletion:$false `
-SiteName "Default-First-Site-Name" `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Implementación del dominio secundario al bosque existente:
Install-AddsDomain
-domaintype <{childdomain | treedomain}>
-parentdomainname <edu-gva.es>
-newdomainname <Repl.iescaminas>
-credential <pscredential>
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Primero se pone el ps1 y después el csv.
#Para crear nuevos equipos (escribimos todo en csv) , usamos el sigiente comando:
Computer:Path
W10IC-1:"OU=equipos,OU=departamentos,dc="caminas",dc="edu-gva",dc="es"
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


#Para iniciar a crear nuevos equipos (creamos y escribimos esto en un archivo ps1), usamos el sigiente comando:
$dc="dc=caminas,dc=edu-gva,dc=es"
$equiposCsv=Read-Host "Introduce el fichero csv de Equipos"
$fichero= import-csv -Path $equiposcsv -delimiter ":"

foreach($linea in $fichero)
{
New-ADComputer -Enabled:$true -Name:$linea.Computer -Path:$linea.Path -SamAccountName:$linea.Computer
}
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#En el csv para crear usuarios, escribimos lo siguiente:
Name:Surname:Surname1:Surname2:account:DNI:Delegation:Department:Enabled:Password:TurnPassDays:email:Computer:Path
MAICA:CAMPOS LLUCH:CAMPOS:LLUCH:MCAMPOSL:12345685-H:general:Enfermeria:$true:12345685-HLLUCH:60:MCAMPOSL@hgeneral.san-gva.es:W10HG-1:OU=departamentos
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#En el ps1 para crear usuarios, escribimos lo siguiente:
$dominio="edu-gva.es"
$dc="dc=caminas,dc=edu-gva,dc=es"
if (!(Get-Module -Name ActiveDirectory)) #accederá al then si no tiene ActiveDirectory sería como decirle al ordenador si no lo tienes carga el modulo,si lo tienes no hagas nada
{
  Import-Module ActiveDirectory #carga el modulo ActiveDirectory
}
$fichero_csv=Read-Host "Introduce el fichero csv de los usuarios"

$fichero_csv_importado = import-csv -Path $fichero_csv -Delimiter : 			     
foreach($linea in $fichero_csv_importado)
{
$Path =$linea.Path+","+$dc
$passAccount=ConvertTo-SecureString $linea.Dni -AsPlainText -force
$name=$linea.Name
	$nameShort=$linea.Name+'.'+$linea.Surname1
	$Surnames=$linea.Surname
	$cuenta=$linea.account
	$nameLarge=$linea.Name+' '+$linea.Surname1+' '+$linea.Surname2
	$computerAccount=$linea.Computer
	$email=$linea.email
	$DNI=$linea.Dni
	$Delegation=$linea.delegation
	$departament=$linea.departament
	$password=$linea.password
	$days=$linea.TurnPassDays
  
New-ADUser -SamAccountName $cuenta -UserPrincipalName $nameShort -Name $cuenta -Surname $Surnames -DisplayName $nameLarge -GivenName $name -LogonWorkstations: $computerAccount -Description "Cuenta de $nameLarge" -EmailAddress $email -AccountPassword $passAccount -Enabled $True `
		-CannotChangePassword $false `
    		-ChangePasswordAtLogon $true `
		-PasswordNotRequired $false `
    		-Path $Path
    Write-Host $linea.department
    Write-Host $linea.account
Add-ADGroupMember -Identity $linea.Department -Members $linea.account
}
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Para crear grupos grupos, primero escribimos lo siguinete en l csv:
Name;Description;Category;Path;Scope
Informatica_GL;Grupo local del departamento de informatica;Security;OU=departamentos;DomainLocal7

Informatica_GG;Grupo del departamento de informatica;Security;OU=departamentos;Global
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Para crear grupos, escribimos lo siguinete en el archivo ps1:
$dominio="edu-gva.es"
$path= "dc=caminas,dc=edu-gva,dc=es"
if (!(Get-Module -Name ActiveDirectory)) #Accederá al then solo si no existe una entrada llamada ActiveDirectory
{
  Import-Module ActiveDirectory #Se carga el módulo
}
Informatica_GG;Grupo del departamento de informatica;Security;OU=departamentos;Global
$fileUsersCsv=Read-Host "Introduce el fichero csv de los grupos"
$fichero = import-csv -Path $fileUsersCsv -Delimiter ";"
foreach($linea in $fichero)
{
$path_OU=$linea.Path +","+$path
NEW-ADGroup -Name $linea.Name -Description $linea.Description -Path $path_OU -GroupScope $linea.Scope
}
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Para crear UOS en el archivo csv:
Name:Descripcion:Path:1
departamentos:Unidad Organizativa::1
Equipos:Unidad Organizativa equipos:OU=departamentos:2
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




