<#
AUTOR: Gabriel Sepúlveda Santibáñez
AÑO: 15-04-2026
CONTACTO: gabriel.sepulveda.s@outlook.es
DESCRIPCIÓN: Aplicación qu es capaz de editar archivos de forma masiva
#>
New-Variable -Name "MAX_PATH" -Value 248 -Option Constant
New-variable -Name "NULL_STRING" -Value 0 -Option Constant

<# Elimina Solo desde el primer lugar #>
function Remove-First
{
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]

    param
    (
        [Parameter(Mandatory=$true)]
        [array]$archivos,
        [string]$Patron
    )

    for($i = 0; $i -lt $archivos.Count; $i++)
    {

        if($Patron -eq $archivos.Get($i).Name)
        {
            Write-Warning -Message "`"$($Patron)`" no se puede procesar la cadena completa.`nSaltando..."
            continue
        }
        <# Se aplica el filtro antes #>
        if($archivos.Get($i).Name -notmatch "^$([regex]::Escape("$($Patron)")).*")
        {
            continue
        }

        $archivo_original = $archivos.Get($i).Name
        $archivo_original_ext = "$($archivos.Get($i).Extension)"
        #$archivo_nuevo = "$($archivo_original)" -split [regex]::Escape("$($Patron)") -join ""
        $archivo_nuevo = "$($archivo_original)" -split "$($archivos.Get($i).Extension)" -join "$null" -split [regex]::Escape("$($Patron)") -join "" -split "$" -join "$($archivo_original_ext)"
        $archivo_ruta = $archivos.Get($i).FullName
        $prueba_ruta = "$($archivos.Get($i).FullName)" -split [regex]::Escape("$($archivos.Get($i).Name)") -join "$($archivo_nuevo)"
        [int64]$len = $("$($archivo_nuevo.Length)" - "$($archivo_original_ext.Length)")

        if($len -cle "$NULL_STRING")
        {
            Write-Warning -Message "`"$($archivo_original)`" >> `"$($archivo_nuevo)`" no puede quedar vacio.`nSaltando..."
            continue
        }
        if($archivo_nuevo.Length -eq 0)
        {
            Write-Warning -Message "Debes aportar al menos un caracter."
            break
        }
         if($($archivo_ruta.Length) -gt "$MAX_PATH")
        {
            Write-Warning -Message "$($archivo_original), excede los 256 caracteres."
            $archivo_ruta = "\\?\$($archivos.Get($i).FullName)"
        }
        if(Test-Path -LiteralPath "$prueba_ruta")
        {
            Write-Warning -Message "`"$($archivo_original)`" >> `"$($archivo_nuevo)`" ya existe.`nSaltando..."
            continue
        }
        if($PSCmdlet.ShouldProcess("$($archivos.Get($i).Name)", "$($archivos.Get($i).FullName) >> $($archivo_nuevo)"))
        {
            Rename-Item -LiteralPath "$($archivo_ruta)" -NewName "$($archivo_nuevo)"
            Write-Output "$archivo_original >> $archivo_nuevo"
        }
    }
}

<# Elimina en cualquier ubicación #>
function Reset-Line
{
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param
    (
        [Parameter(Mandatory=$true)]
        [array]$archivos,
        [string]$Patron
    )

    for($i = 0; $i -lt $archivos.Count; $i++)
    {
        if($Patron -eq $archivos.Get($i).Name)
        {
            Write-Warning -Message "`"$($Patron)`" no se puede procesar la cadena completa.`nSaltando..."
            continue
        }
        if($archivos.Get($i).BaseName -notmatch "$([regex]::Escape("$($Patron)"))")
        {
            continue
        }
        $archivo_original = "$($archivos.Get($i).Name)"
        $archivo_original_ext = "$($archivos.Get($i).Extension)"
#       $archivo_nuevo = "$($archivo_original)" -split [regex]::Escape("$($Patron)") -join ""
        $archivo_nuevo = "$($archivo_original)" -split "$($archivos.Get($i).Extension)" -join "$null" -split [regex]::Escape("$($Patron)") -join "" -split "$" -join "$($archivo_original_ext)"
        $archivo_ruta = "$($archivos.Get($i).FullName)"
        $prueba_ruta = "$($archivos.Get($i).FullName)" -split [regex]::Escape("$($archivos.Get($i).Name)") -join "$($archivo_nuevo)"
        [int64]$len = $("$($archivo_nuevo.Length)" - "$($archivo_original_ext.Length)")
        
        if($len -cle "$NULL_STRING")
        {
            Write-Warning -Message "`"$($archivo_original)`" >> `"$($archivo_nuevo)`" no puede quedar vacio.`nSaltando..."
            continue
        }
        if($($archivo_ruta.Length) -gt "$MAX_PATH")
        {
            Write-Warning -Message "`"$($archivo_original)`", excede los 256 caracteres."
            $archivo_ruta = "\\?\$($archivos.Get($i).FullName)"
        }
        if(Test-Path -LiteralPath "$prueba_ruta")
        {
            Write-Warning -Message "`"$($archivo_original)`" >> `"$($archivo_nuevo)`" ya existe.`nSaltando..."
            continue
        }
        if($PSCmdlet.ShouldProcess("$($archivos.Get($i).Name)", "$($archivos.Get($i).FullName) >> $($archivo_nuevo)"))
        {
            Rename-Item -LiteralPath "$($archivo_ruta)" -NewName "$($archivo_nuevo)"
            Write-Output "$($archivo_original) >> $($archivo_nuevo)"
        }
    }
}

<# renombra en cualquier ubicación #>
function Rename-Line
{
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param
    (
        [Parameter(Mandatory=$true)]
        [array]$archivos,
        [Parameter(Mandatory=$true)]
        [string]$Rename,
        [string]$patron
    )

    for($i = 0; $i -lt $archivos.Count; $i++)
    {

         if($patron -eq $archivos.Get($i).Name)
        {
            Write-Warning -Message "`"$($patron)`" no se puede procesar la cadena completa.`nSaltando..."
            continue
        }
        if($archivos.Get($i).BaseName -notmatch "$([regex]::Escape("$($Patron)"))")
        {
            continue
        }   
        $archivo_original = $archivos.Get($i).Name
        $archivo_original_ext = "$($archivos.Get($i).Extension)"
        $archivo_nuevo = "$($archivo_original)" -split "$($archivos.Get($i).Extension)" -join "$null" -split [regex]::Escape("$($patron)") -join "$($Rename)" -split "$" -join "$($archivo_original_ext)"
        $archivo_ruta = $archivos.Get($i).FullName
        $prueba_ruta = "$($archivos.Get($i).FullName)" -split [regex]::Escape("$($archivos.Get($i).Name)") -join "$($archivo_nuevo)"
        [int64]$len = $("$($archivo_nuevo.Length)" - "$($archivo_original_ext.Length)")

        if($len -cle "$NULL_STRING")
        {
            Write-Warning -Message "`"$($archivo_original)`" >> `"$($archivo_nuevo)`" no puede quedar vacio.`nSaltando..."
            continue
        }
        if($($archivo_ruta.Length) -gt "$MAX_PATH")
        {
            Write-Warning -Message "`"$($archivo_original)`", excede los 256 caracteres."
            $archivo_ruta = "\\?\$($archivos.Get($i).FullName)"
        }
        if(Test-Path -LiteralPath "$prueba_ruta")
        {
            Write-Warning -Message "`"$($archivo_original)`" >> `"$($archivo_nuevo)`" ya existe.`nSaltando..."
            continue
        }
        if($PSCmdlet.ShouldProcess("$($archivos.Get($i).Name)", "$($archivos.Get($i).FullName) >> $($archivo_nuevo)"))
        {
            Rename-Item -LiteralPath "$archivo_ruta" -NewName "$archivo_nuevo"
            Write-Output "$archivo_original >> $archivo_nuevo"
        }
    }
}

<# Función principal #>
function Remove-Line {
<#
 .SYNOPSIS
  Elimina texto específico de archivos.

 .DESCRIPTION
  Elimina texto específico de archivos. Este módulo soporta
  eliminar y remplazar en cualquier lugar del archivo.

 .PARAMETER First
  Elimina desde el inicio de un archivo.

 .PARAMETER Rename
  Renombra en cualquier lugar del archivo.

 .PARAMETER Ruta
  Donde se buscarán los archivos.

 .PARAMETER Patron
  El caracter o símbolo a modificar.

 .PARAMETER Recurse
  Busca en todas las subcarpetas.

 .PARAMETER File
  Busca solo archivos.

 .PARAMETER Directory
  Busca solo directorios.

 .EXAMPLE
  Remove-Line -Patron "2025"

  El directorio predeterminado es: <<.>>. Además, del comando
  predeterminado es:  - Esto elimina
  esta cadena de todo archivo, directorio en .

 .EXAMPLE
  Remove-Line -First -Patron "_" -Recurse -Path $HOME\Documentos
  _file1.txt >> file1.txt

  Elimina un patron que inicie con: <<_>>. en una ruta especifica y subcarpetas de esa ruta.
  Tanto en archivos y carpetas.

 .EXAMPLE
  Remove-Line -First -Patron '`n' -Recurse -Path $HOME\Documentos
  `nfile1.txt >> file1.txt

  Elimina un patron con caracter especial: <<`n>>. Se usan comillas en estos casos ''.

 .EXAMPLE
  Remove-Line -Patron " -- " -Ruta $HOME\Documentos -Recurse -File -Rename "-"
  file--1.txt >> file-1.txt

  Renombra un patron especifico solo en archivos.

 .EXAMPLE
  Remove-Line -Patron " -- " -Ruta $HOME\Documentos -Recurse -Filter *.jpg
  file -- .jpg >> file.jpg

  Renombra un patron solo en archivos con extensión .JPG

  .EXAMPLE
  Remove-Line -Patron "dir-1" -Ruta $HOME\Documentos -Recurse -Directory
  dir-1-files >> -files

  Renombra un patron en directorios

  .EXAMPLE
  Remove-Line -Patron "dir-1" -Ruta $HOME\Documentos -Recurse -Directory
  dir-1-files >> -files

  Renombra un patron en directorios
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param
(
    [Parameter(Mandatory=$true)]
    [string]$Patron,
    [Parameter(Mandatory=$false)]
    [string]$Ruta = ".",
    [Parameter(Mandatory=$false)]
    [switch]$Recurse,
    [Parameter(Mandatory=$false)]
    [switch]$File,
    [Parameter(Mandatory=$false)]
    [switch]$Directory,
    [Parameter(Mandatory=$false, ParameterSetName='A')]
    [string]$Rename,
    [Parameter(Mandatory=$false)]
    [switch]$First,
    [Parameter(Mandatory=$false)]
    [string]$Filter = "*"
)

$argumentos = @{
    Path = $Ruta
    Recurse = $Recurse
    File = $File
    Directory = $Directory
    Filter = $Filter
    ErrorAction = "SilentlyContinue"
}
<# Para tener caracteres reservados como literales regex #>
[array]$archivos = $(Get-ChildItem @argumentos | Where-Object { $_.Name -match [regex]::Escape("$($patron)")})


    if(-not $First -and -not $Rename)
    {
        Reset-Line -archivos $archivos -Patron $patron
    }
    elseif ($First -and -not $Rename)
    {
        Remove-First -archivos $archivos -Patron $Patron
    }
    elseif(-not $First -and $Rename)
    {
        Rename-Line -archivos $archivos -Rename $Rename -patron $Patron
    }
    else
    {
        Write-Error "Elige una opción valida."
    }
}

Export-ModuleMember -Function Remove-Line