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
