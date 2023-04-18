$computers = Get-Content -Path C:\Users\******.ds\Desktop\TueReboot\******.txt
$msg = "Your computer will reboot in 30 seconds, please save all work and wait for the system to be patched."

 

ForEach ($Line In $computers)
{
    Invoke-WmiMethod -Path Win32_Process -Name Create -ArgumentList "msg * $msg" -ComputerName $Line
}
#30 second timer on reboot, edit timer by changing seconds integer
start-sleep -Seconds 30
#computers go night night 
Get-Content -Path C:\Users\*********.ds\Desktop\TueReboot\*******.txt | Restart-Computer -Force -ErrorAction Stop
#60 second delay for next block of code
start-sleep -Seconds 60

 

$pinglist= Get-Content -Path C:\Users\********.ds\Desktop\TueReboot\******.txt

 

$pingResults = New-Object System.Collections.ArrayList

 

# Iterate through the list of terminal servers and ping each one
foreach ($computer in $pinglist) {
   $pingResult = Test-Connection -ComputerName $computer -Count 1 -ErrorAction SilentlyContinue

 
#Output for our list classifying if the server is online or offline after the reboot and ping test
   if ($pingResult) {
       $pingResults.Add("$computer is Online`n") | Out-Null
   } else {
       $pingResults.Add("$computer is Offline`n") | Out-Null
   }
}
#output will give each server ping status 
$JobOutput = $pingResults
$JobOutput
#if the job fails email 
if($JobOutput -match "failed"){

 

 

 

    $smtpServer = "**************.com"
    $msg = new-object Net.Mail.MailMessage
    $smtp = new-object Net.Mail.SmtpClient($smtpServer)

 

 

 

# email its from and email its going too
    $msg.From = "*************@*************.com"
    $msg.Bcc.Add("******@**************.com")

 

 

 # subject of the email 
    $msg.Subject = "Connection Test Failed - Tuesday Maint."

 

 

 
# Body of the email that will return a list of the Servers and their status.
    $msg.Body = "Terminal Server Status:`n" + $JobOutput

 

 

 

    $smtp.Send($msg)

 

} 
#if the job is successful email.
else {

 

 

 

    $smtpServer = "**************.com"
    $msg = new-object Net.Mail.MailMessage
    $smtp = new-object Net.Mail.SmtpClient($smtpServer)

 

 

 


    $msg.From = "***********@***********.com"
    $msg.Bcc.Add("********@************.com")

 

 

 

    $msg.Subject = "Connection Test Successful. - Tuesday Maint."

 

 

 

    $msg.Body =  "Terminal Server Status:`n" + $JobOutput

 

 

 

    $smtp.Send($msg)
}

 

Exit