$Save_To = "C:\\Temp\\members.txt"
$DL_Group = Read-Host -Prompt 'Type the email address of the group you want the members list'

# Chcek if it's a group or a user
filter recurse_members
    {
        if($_.RecipientType -eq "MailUniversalDistributionGroup")
            {
                # If it's a group, read the group members
                Get-DistributionGroupMember -ResultSize "Unlimited" $_.Name | recurse_members
            }
        else
            {
                # Sending back the users list to the main
                $Members = $_.Name + " (" + $_.PrimarySMTPAddress + ")"
                Write-Output $Members
            }
    } 

# Read the group members 
Get-DistributionGroup $DL_Group | ForEach-Object {
    "`r`n$($_.DisplayName) ($($_.PrimarySMTPAddress))`r`n=============" | Add-Content $Save_To 
    # For each user check if it's group or user
    $DL_Out = Get-DistributionGroupMember -ResultSize "Unlimited" $_.Name | recurse_members
    Write-Output $DL_Out | Sort-Object | Get-Unique  | Add-Content $Save_To
}