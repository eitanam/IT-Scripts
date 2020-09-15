<#

Version 1.0
Inital release


#>

# .Net methods for hiding/showing the console in the background
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0)
}

Hide-Console


$str001 = "Password Expiration Checker V1.1"

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '500,300'
$Form.text                       = $str001
$Form.TopMost                    = $false

$User_Name                    = New-Object system.Windows.Forms.Label
$User_Name.text               = "User Name"
$User_Name.AutoSize           = $true
$User_Name.width              = 25
$User_Name.height             = 10
$User_Name.location           = New-Object System.Drawing.Point(20,31)
$User_Name.Font               = 'Microsoft Sans Serif,10'

$User_Name_TextBox             = New-Object system.Windows.Forms.TextBox
$User_Name_TextBox.multiline   = $false
$User_Name_TextBox.width       = 200
$User_Name_TextBox.height      = 20
$User_Name_TextBox.location    = New-Object System.Drawing.Point(140,29)
$User_Name_TextBox.Font        = 'Microsoft Sans Serif,10'

$Check_Button               = New-Object system.Windows.Forms.Button
$Check_Button.text          = "Check"
$Check_Button.width         = 200
$Check_Button.height        = 30
$Check_Button.location      = New-Object System.Drawing.Point(20,250)
$Check_Button.Font          = 'Microsoft Sans Serif,10'

$StatusUpdate                    = New-Object system.Windows.Forms.Label
$StatusUpdate.Text               = " "
$StatusUpdate.AutoSize           = $true
$StatusUpdate.width              = 200
$StatusUpdate.height             = 10
$StatusUpdate.location           = New-Object System.Drawing.Point(90,150)
$StatusUpdate.Font               = 'Microsoft Sans Serif,10'

$Display_Name                   = New-Object system.Windows.Forms.Label
$Display_Name.Text               = ""
$Display_Name.AutoSize           = $true
$Display_Name.width              = 80
$Display_Name.height             = 10
$Display_Name.location           = New-Object System.Drawing.Point(20,120)
$Display_Name.Font               = 'Microsoft Sans Serif,10'

$Display_Name_Results                   = New-Object system.Windows.Forms.Label
$Display_Name_Results.Text               = ""
$Display_Name_Results.AutoSize           = $true
$Display_Name_Results.width              = 80
$Display_Name_Results.height             = 10
$Display_Name_Results.location           = New-Object System.Drawing.Point(180,120)
$Display_Name_Results.Font               = 'Microsoft Sans Serif,10'

$Display_Date                  = New-Object system.Windows.Forms.Label
$Display_Date.Text               = ""
$Display_Date.AutoSize           = $true
$Display_Date.width              = 80
$Display_Date.height             = 10
$Display_Date.location           = New-Object System.Drawing.Point(20,150)
$Display_Date.Font               = 'Microsoft Sans Serif,10'

$Display_Date_Reults                   = New-Object system.Windows.Forms.Label
$Display_Date_Reults.Text               = ""
$Display_Date_Reults.AutoSize           = $true
$Display_Date_Reults.width              = 80
$Display_Date_Reults.height             = 10
$Display_Date_Reults.location           = New-Object System.Drawing.Point(180,150)
$Display_Date_Reults.Font               = 'Microsoft Sans Serif,10'


$closeButton                     = New-Object system.Windows.Forms.Button
$closeButton.text                = "Close"
$closeButton.width               = 102
$closeButton.height              = 30
$closeButton.location            = New-Object System.Drawing.Point(250,250)
$closeButton.Font                = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($User_Name,$User_Name_TextBox,$Check_Button,$Display_Name,$Display_Name_Results,$Display_Date,$Display_Date_Reults,$closeButton,$StatusUpdate))


#region events {
$Check_Button.Add_Click({Check_password_Expirtaion})
$closeButton.Add_Click({ closeForm })
#endregion events }

#endregion GUI }

$User_Name_TextBox.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") {
        Check_password_Expirtaion
    }
    })

# Get domain password policy and convert to days
$Get_Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$Domain_ADSI = [ADSI]"LDAP://$Get_Domain"
$Max_PWD = $Domain_ADSI.maxPwdAge.Value
$Max_Pwd_INT = $Domain_ADSI.ConvertLargeIntegerToInt64($Max_PWD)
$Max_Pwd_Age = -$Max_Pwd_INT/(600000000 * 1440)


function Check_password_Expirtaion ()
    {
        
        #Checked the user name box has been filled 
        if (!$User_Name_TextBox.Text)
            {
                $StatusUpdate.ForeColor = 'red'
                $StatusUpdate.Text  = "Please provide a user name"
            }

        else
            {
                $StatusUpdate.Text  = " "
                $StatusUpdate.ForeColor = 'orange'
                $Display_Name.Text = ""
                $Display_Date.Text  = ""
                $Display_Name_Results.Text = ""
                $Display_Date_Reults.Text  = ""
                $StatusUpdate.Text  = "Checking, please wait"
                $User_Name_Text = $User_Name_TextBox.Text
                $Name_Results = ([adsisearcher]"(&(objectclass=user)(samaccountname=$User_Name_Text))").FindOne().Properties.displayname
                
                #get password last set date and convert it to date
                $Pass_Last_Set = ([adsisearcher]"(&(objectclass=user)(samaccountname=$User_Name_Text))").FindOne().Properties.pwdlastset | Out-String
                $Pass_Last_Set_Date = [datetime]::fromfiletime($Pass_Last_Set)
                
                #checke if password is set to never expired.
                $Never_Expired_check = ([adsisearcher]"(&(objectclass=user)(samaccountname=$User_Name_Text))").FindOne().Properties.useraccountcontrol
                $Never_Expired_results = (($Never_Expired_check.Item(0) -band 64) -or ($Never_Expired_check.Item(0) -band 65536))
                $StatusUpdate.Text  = " "
                                
                
                if (!$Name_Results)
                    {
                        $StatusUpdate.ForeColor = 'red'
                        $StatusUpdate.Text  = "The user name could not be found."
                    }
                else
                    {

                        #Password will be expired one day
                        if (($Never_Expired_results) -eq $False)
                            {
                                #Password expired
                                if ($Pass_Last_Set_Date.AddDays($Max_Pwd_Age) -le (get-date))
                                    {
                                        $StatusUpdate.ForeColor = 'red'
                                        $StatusUpdate.Text  = $Name_Results
                                    }
                                #Dispaly expiration date
                                else
                                    {
                                        $Display_Name.Text = "Display Name:"
                                        $Display_Date.Text  = "Expiry Date:"
                                        $Display_Name_Results.Text = $Name_Results
                                        $Display_Date_Reults.Text = $Pass_Last_Set_Date.AddDays($Max_Pwd_Age).ToShortDateString()
                                    }
                            }   
                        #Passsword never expire
                        else
                            {
                                $StatusUpdate.ForeColor = 'red'
                                $StatusUpdate.Text  = "$Name_Results's password never expires."
                            }
                    }
            }
    }

function closeForm(){$Form.close()}

[void]$Form.ShowDialog()