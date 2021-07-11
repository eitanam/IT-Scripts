<#

***************   This script is provided AS-IS without any warranty to any damage that may occured. It will delete emails, if you are using it it's AT YOUR OWN RISK!  ***********

Version 1.0
Inital release

#>


$str001 = "Modify users aliases ver 1.0"
$str002 = "User name:"
$str003 = "Search"
$str004 = "User name is missing"
$str005 = "The user name you entered does not exist"
$str006 = "Hide from address lists"
$str007 = "Change"
$str008 = "Primary email address:"
$str009 = "Set as a new primary"
$str010 = "Add an alias:"
$str011 = "Add"
$str012 = "Delete an alias"
$str013 = "Delete"
$str014 = "This alias already a primary"
$str015 = "This alias already in use"
$str016 = "Alias is missing"
$str017 = "This alias is a primary alias"
$str018 = "This alias is not existing"
$str020 = "Close"


Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '600,650'
$Form.text                       = $str001
$Form.TopMost                    = $false

$UserName                        = New-Object system.Windows.Forms.Label
$UserName.text                   = $str002
$UserName.AutoSize               = $true
$UserName.Size                   = new-object System.Drawing.Size(70,10)
$UserName.location               = New-Object System.Drawing.Point(30,52)
$UserName.Font                   = 'Microsoft Sans Serif,10'
$form.Controls.Add($UserName)

$UserNameTextBox                = New-Object system.Windows.Forms.TextBox
$UserNameTextBox.multiline      = $false
$UserNameTextBox.Size           = new-object System.Drawing.Size(200,20)
$UserNameTextBox.location       = New-Object System.Drawing.Point(110,50)
$UserNameTextBox.Font           = 'Microsoft Sans Serif,10'
$form.Controls.Add($UserNameTextBox)

$Search_User_Button           = New-Object system.Windows.Forms.Button
$Search_User_Button.text       = $str003
$Search_User_Button.location   = New-Object System.Drawing.Point(340,50)
$Search_User_Button.Size = new-object System.Drawing.Size(100,25)
$Search_User_Button.Font       = 'Microsoft Sans Serif,10'
$Search_User_Button.Add_Click({Search})
$form.Controls.Add($Search_User_Button)

$checkbox1 = new-object System.Windows.Forms.checkbox
$checkbox1.Location = new-object System.Drawing.Size(30,90)
$checkbox1.Size = new-object System.Drawing.Size(250,50)
$checkbox1.Text = $str006

$HideSetButton = new-object System.Windows.Forms.Button
$HideSetButton.Location = new-object System.Drawing.Size(340,100)
$HideSetButton.Size = new-object System.Drawing.Size(100,25)
$HideSetButton.Text = $str007
$HideSetButton.Add_Click({HideFromGal})

$PrimaryEmailAddress                       = New-Object system.Windows.Forms.Label
$PrimaryEmailAddress.text                  = $str008
$PrimaryEmailAddress.AutoSize              = $true
$PrimaryEmailAddress.Size                  = new-object System.Drawing.Size(70,10)
$PrimaryEmailAddress.location              = New-Object System.Drawing.Point(30,160)
$PrimaryEmailAddress.Font                  = 'Microsoft Sans Serif,10'

$PrimaryEmailAddressTextBox                = New-Object system.Windows.Forms.TextBox
$PrimaryEmailAddressTextBox.multiline      = $false
$PrimaryEmailAddressTextBox.Size           = new-object System.Drawing.Size(200,20)
$PrimaryEmailAddressTextBox.location       = New-Object System.Drawing.Point(175,155)
$PrimaryEmailAddressTextBox.Font           = 'Microsoft Sans Serif,10'

$PrimaryEmailAddressButton                 = new-object System.Windows.Forms.Button
$PrimaryEmailAddressButton.Location        = new-object System.Drawing.Size(380,155)
$PrimaryEmailAddressButton.Size            = new-object System.Drawing.Size(150,25)
$PrimaryEmailAddressButton.Text            = $str009
$PrimaryEmailAddressButton.Add_Click({SetPrimaryEmail})

$AddAnAlias                                = New-Object system.Windows.Forms.Label
$AddAnAlias.text                           = $str010
$AddAnAlias.AutoSize                       = $true
$AddAnAlias.Size                           = new-object System.Drawing.Size(70,10)
$AddAnAlias.location                       = New-Object System.Drawing.Point(30,205)
$AddAnAlias.Font                           = 'Microsoft Sans Serif,10'

$AddAnAliasTextBox                         = New-Object system.Windows.Forms.TextBox
$AddAnAliasTextBox.multiline               = $false
$AddAnAliasTextBox.Size                    = new-object System.Drawing.Size(200,20)
$AddAnAliasTextBox.location                = New-Object System.Drawing.Point(175,200)
$AddAnAliasTextBox.Font                    = 'Microsoft Sans Serif,10'

$AddAnAliasButton                          = new-object System.Windows.Forms.Button
$AddAnAliasButton.Location                 = new-object System.Drawing.Size(380,199)
$AddAnAliasButton.Size                     = new-object System.Drawing.Size(150,25)
$AddAnAliasButton.Text                     = $str011
$AddAnAliasButton.Add_Click({AddNewAlias})

$DeleteAnAlias                             = New-Object system.Windows.Forms.Label
$DeleteAnAlias.text                        = $str012
$DeleteAnAlias.AutoSize                    = $true
$DeleteAnAlias.Size                        = new-object System.Drawing.Size(70,10)
$DeleteAnAlias.location                    = New-Object System.Drawing.Point(30,250)
$DeleteAnAlias.Font                        = 'Microsoft Sans Serif,10'

$DeleteAnAliasTextBox                      = New-Object system.Windows.Forms.TextBox
$DeleteAnAliasTextBox.multiline            = $false
$DeleteAnAliasTextBox.Size                 = new-object System.Drawing.Size(200,20)
$DeleteAnAliasTextBox.location             = New-Object System.Drawing.Point(175,245)
$DeleteAnAliasTextBox.Font                 = 'Microsoft Sans Serif,10'

$DeleteAnAliasButton                       = new-object System.Windows.Forms.Button
$DeleteAnAliasButton.Location              = new-object System.Drawing.Size(380,244)
$DeleteAnAliasButton.Size                  = new-object System.Drawing.Size(150,25)
$DeleteAnAliasButton.Text                  = $str013
$DeleteAnAliasButton.Add_Click({DeletAlias})

$result                                    = New-Object system.Windows.Forms.TextBox
$result.multiline                          = $true
$result.width                              = 500
$result.Size                               = new-object System.Drawing.Size(500,250)
$result.ScrollBars                         = 'Both'
$result.TabIndex                           = 1
$result.location                           = New-Object System.Drawing.Point(30,300)
$result.BackColor                          = [System.Drawing.Color]::FromArgb(245,245,220)
$result.text                               = ""
$result.Font                               = 'Microsoft Sans Serif,10'
$form.Controls.Add($result)

$closeButton                              = new-object System.Windows.Forms.Button
$closeButton.Location                     = new-object System.Drawing.Size(30,600)
$closeButton.Size                         = new-object System.Drawing.Size(100,40)
$closeButton.Text                         = $str020
$closeButton.Add_Click({$Form.Close()})
$form.Controls.Add($closeButton)


$MsgBoxError = [System.Windows.Forms.MessageBox]


$global:Aliasses = @()
$global:Primary_Address = $null
$global:Aliasses_multi_lines = $null
$global:DN = $null
$global:Hidden_From_GAL = $null
$global:Primary_Display = $null
$global:user=$null

#Search for the user details
function Search()
{ 
    $global:Hidden_From_GAL = $null
    $global:Aliasses = @()
    if ( $UserNameTextBox.Text)
    {
        try
        {
            $result.text = ""
            $PrimaryEmailAddressTextBox.Text=""
            $AddAnAliasTextBox.text=""
            $DeleteAnAliasTextBox.text=""
            $global:User = Get-ADUser $UserNameTextBox.Text -Properties proxyAddresses
            $global:DN = get-aduser $UserNameTextBox.Text | Select-Object -ExpandProperty DistinguishedName
            $global:Hidden_From_GAL = Get-ADObject $global:DN -Property msexchhidefromaddresslists | Select-Object -ExpandProperty msexchhidefromaddresslists
                       
            Hidden_CheckBox
            EmailAddresses
            ShowResults
        }
        Catch
        {
            $MsgBoxError::Show($str005, $str001, "OK", "Error")
        }
    }
    else
    {
        $MsgBoxError::Show($str004, $str001, "OK", "Error")
    }
}

function EmailAddresses ()
{
    $smtp_addresses = Get-ADuser $UserNameTextBox.Text -Properties proxyAddresses |  Select-Object @{L = "ProxyAddresses"; E = { ($_.ProxyAddresses -clike 'smtp:*')}}
    ForEach ($smtp_address In $smtp_addresses)
    {
        ForEach ($proxyAddress in $smtp_address.proxyAddresses)
        {
            $alias_address = $proxyAddress.split(":")
            $global:Aliasses += $alias_address[1]      
        }
    }
}

function ShowResults()
{
        $Name = get-aduser $UserNameTextBox.Text | Select-Object -ExpandProperty Name
        $Enable_Status = get-aduser $UserNameTextBox.Text | Select-Object -ExpandProperty Enabled
        $UPN = get-aduser $UserNameTextBox.Text | Select-Object -ExpandProperty UserPrincipalName
        $global:Primary_Address = Get-ADuser $UserNameTextBox.Text -Properties proxyAddresses | Select-Object -ExpandProperty ProxyAddresses | Where-Object {$_ -clike "SMTP:*"}
        $Primary_email = $global:Primary_Address.split(":")
        $global:Primary_Display=$Primary_email[1]
        $Aliases_results = $global:Aliasses -join "`r`n"
        if ($global:Hidden_From_GAL -ne "True")
            {
                $global:Hidden_From_GAL = "False"
            }
        $result.text = "User Name: $Name `r`nHidden from GAL: $global:Hidden_From_GAL `r`nEnabled User: $Enable_Status `r`nUserPrincipalName: $UPN `r`n `r`nPrimary email address:`r`n$global:Primary_Display `r`n `r`nOther email addresses:`r`n$Aliases_results"
}
 

function Hidden_CheckBox()
{
    $Form.Controls.Add($checkbox1)
    $form.Controls.Add($HideSetButton)
    $form.Controls.Add($PrimaryEmailAddress)
    $form.Controls.Add($PrimaryEmailAddressTextBox)
    $form.Controls.Add($PrimaryEmailAddressButton)
    $form.Controls.Add($AddAnAlias)
    $form.Controls.Add($AddAnAliasTextBox)
    $form.Controls.Add($AddAnAliasButton)
    $form.Controls.Add($DeleteAnAlias)
    $form.Controls.Add($DeleteAnAliasTextBox)
    $form.Controls.Add($DeleteAnAliasButton)

    $checkbox1.Checked = $false
    if($global:Hidden_From_GAL -eq "True")
    {
        $checkbox1.Checked = $true
    }
    else
    {
        $checkbox1.Checked = $false
    }
}

function HideFromGal()
{
    if ($checkbox1.Checked)
    {
        set-adobject -Identity $global:DN -replace @{msExchHideFromAddressLists=$True}
        search
    }
    else 
    {
        set-adobject -Identity $global:DN -replace @{msExchHideFromAddressLists=$False}
        search
    }
}

function SetPrimaryEmail ()
{
    #Check if the new promary alias already existing
    #$User = Get-ADUser $UserNameTextBox.Text -Properties proxyAddresses
    if ($global:Primary_Display -notlike $PrimaryEmailAddressTextBox.Text)
    {
        if ($global:Aliasses -match $PrimaryEmailAddressTextBox.Text)
        {
            # Remove the current primary alias
            $global:User.proxyAddresses.remove("SMTP:" + $global:Primary_Display)
            Set-ADUser -instance $global:User
            # Add the previous primary as an alias
            $global:User.proxyAddresses.add("smtp:" + $global:Primary_Display)
            Set-ADUser -instance $global:User
            # Remove the alias who should be come primary
            $global:User.proxyAddresses.remove("smtp:" + $PrimaryEmailAddressTextBox.Text)
            Set-ADUser -instance $global:User
            # Set a new primary
            $global:User.proxyAddresses.add("SMTP:" + $PrimaryEmailAddressTextBox.Text)
            Set-ADUser -instance $global:User
        }
        else
        {
            # Remove the current primary alias
            $global:User.proxyAddresses.remove("SMTP:" + $global:Primary_Display)
            Set-ADUser -instance $global:User
            # Add the previous primary as an alias
            $global:User.proxyAddresses.add("smtp:" + $global:Primary_Display)
            Set-ADUser -instance $global:User
            # Set a new primary
            $global:User.proxyAddresses.add("SMTP:" + $PrimaryEmailAddressTextBox.Text)
            Set-ADUser -instance $global:User
        }
    search
    }
    else
    {
        $MsgBoxError::Show($str014, $str001, "OK", "Error")
    }
}

function AddNewAlias ()
{
    #$User = Get-ADUser $UserNameTextBox.Text -Properties proxyAddresses
    if ($AddAnAliasTextBox.text)
    {
        if (($global:Aliasses -match $AddAnAliasTextBox.Text) -or ($AddAnAliasTextBox.Text -like $global:Primary_Display))
        {
            $MsgBoxError::Show($str015, $str001, "OK", "Error")
        }
        else
        {
            $global:User.proxyAddresses.add("smtp:" + $AddAnAliasTextBox.text)
            Set-ADUser -instance $global:User
        }
    }
    else
    {
        $MsgBoxError::Show($str016, $str001, "OK", "Error")
    }
    search
}


function DeletAlias ()
{
    if ($DeleteAnAliasTextBox.text -like $global:Primary_Display)
    {
        $MsgBoxError::Show($str017, $str001, "OK", "Error")
    }
    else
    {
        if($global:Aliasses -match $DeleteAnAliasTextBox.Text)
        {
            $global:User.proxyAddresses.remove("smtp:" + $DeleteAnAliasTextBox.text)
            Set-ADUser -instance $global:User
        }
        else
        {
            Write-Host $DeleteAnAliasTextBox.Text
            Write-Host $global:Aliasses
            $MsgBoxError::Show($str018, $str001, "OK", "Error")
        }
    }
    search
}


[void]$Form.ShowDialog()
