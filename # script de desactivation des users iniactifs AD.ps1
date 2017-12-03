# script de desactivation des users iniactifs AD
#v1.0
#Author: Mohamed BOUSSAID

# Force Execution-Policy
Set-ExecutionPolicy Unrestricted

# import AD module 
Import-Module ActiveDirectory


$LockedAccount = Search-ADAccount -UsersOnly -AccountInactive -TimeSpan 90.00:00:00 -SearchBase "OU=Users,DC=Domaine,DC=Local" | where {$_.enabled}

# Desactiver les comptes AD
$LockedAccount | Set-ADUser

# envoi d'un email
$smtpServer = "mail.domaine.local"
$from = "DisableADAccount <powershell@domaine.local>"
$to = "Helpdesk <helpdesk@domaine.local>"
$subject = "[INFO] Comptes AD last logon > 90 jours"
$body = "
<html>
  <head></head>
     <body>
        <p>Bonjour,<br />
           Les comptes suivants sont désactivé à cause d'une inactivité de plus de 90 jours<br />:
           $LockedAccount
        </p>
      </body>
</html>"

Send-MailMessage -smtpserver $smtpserver -from $from -to $to -subject $subject -body $body -bodyasHTML -priority High

<html>