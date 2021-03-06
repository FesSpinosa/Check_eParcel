############################################
# Ebootis XML import for powershell v2.0   #
# - Expeedoshop KDNR Check -               #
# Author: Thomas Pilgrim                   #
# PCE Deutschland GmbH, Im Langel 4        #
# 59872 Meschede                           #
# 02/2010                                  #
# All rights reserved.                     #
############################################


function sendmail ($to, $content)
    {
        $mail = New-Object System.Net.Mail.MailMessage
        Write-Host "Sending mail to $to"
        $mail.From = "onlineshop@warensortiment.de"
        $mail.To.Add($to)
        $mail.Subject = "$order_count neue OnlineShop Bestellung(en)"
        $mail.Body = $content
        $smtp = New-Object System.Net.Mail.SmtpClient("85.214.32.39");
        $smtp.Credentials = New-Object System.Net.NetworkCredential("nsc@warensortiment.de", "01716100817");
        $smtp.Send($mail);
        $mail = $null
        $smtp = $null
    }    


$time1 = get-date -uFormat “%Y-%m-%d”
$time2 = get-date -uFormat “%d.%m.%Y %H:%M:%S”
$savetime = get-date -uFormat “%d.%m.%Y-%H-%M-%S”
#######################################################


###############FTP Download ###########################

cd d:\import\expeedoshop\temp\Bestellungen
ncftpget -u ftppce1 -p Ziej2the -R -DD ftp://pce.shopdriver.de/auftrag*.xml
robocopy D:\import\expeedoshop\temp\Bestellungen D:\import\expeedoshop\backup\Bestellungen /E

cd d:\import\expeedoshop\temp\Kunden
ncftpget -u ftppce1 -p Ziej2the -R -DD ftp://pce.shopdriver.de/kunde*.xml
robocopy D:\import\expeedoshop\temp\Kunden D:\import\expeedoshop\backup\Kunden /E


$kundendateien = get-ChildItem d:\import\expeedoshop\temp\Kunden\*.* -name -include *.xml

#### oracle verbindung öffnen
[System.Reflection.Assembly]::LoadWithPartialName("System.Data.OracleClient")
$connectionString= "Data Source=PCE-ERP1/FET;User Id=FET_USER;Password=FET_USER;Integrated Security=no"
$connection = New-Object System.Data.OracleClient.OracleConnection($connectionString)

foreach ($datei in $kundendateien)
 	{
 #   if ($datei)
 #       {
 #        $war_vorhanden = $false
 #        [xml]$xml = get-content d:\import\expeedoshop\temp\Kunden\$datei
 #        if($xml.Customers.Customer.PrivateCustomerData.Person.Email.address)
 #        { 
 #        $mail = $xml.Customers.Customer.PrivateCustomerData.Person.Email.address
 #        }
 #        else
 #        {
 #        $mail = $xml.Customers.Customer.BusinessCustomerData.Employees.Employee.Person.Email.address
 #        }
 #         $connection.Open()
 #         $queryString = "select customer_id from FET_CUSTOMER where customer_proxy_guid = (select GUID from FET_CUSTOMER_PROXY where businesspartner_guid = (select businesspartner_guid from V_BUSINESSPARTNER_MAIL where COMM_STRING = '$mail'))"
 #           $command = new-Object System.Data.OracleClient.OracleCommand($queryString, $connection)
 #           $result = $command.ExecuteScalar()   
 #           if(!$result)
 #               {
 #               $queryString = "select customer_id from FET_CUSTOMER where customer_proxy_guid = (select GUID from FET_CUSTOMER_PROXY where businesspartner_guid = (select businesspartner_guid from FET_BP_EMPLOYEE where guid = (select bp_employee_guid from# V_BP_EMPLOYEE_MAIL where REGEXP_LIKE(comm_string,'$mail','i') and rownum = 1)))"
 #               $command = new-Object System.Data.OracleClient.OracleCommand($queryString, $connection)
 #               $result = $command.ExecuteScalar()   
 #               if(!$result)
 #                   {
 #                   echo "Kunde nicht vorhanden"
 #                   $istkundeerstellt = "`n kundennummer war nicht vorhanden, wurde generiert  `n"
 #                   [xml]$saved_variables = (get-content d:\import\expeedoshop\ps\saved_variables.xml) ### auslesen der nächsten kd-nr
 #                   [long]$customer_id = $saved_variables.Customers.next_customer_id
                    

 #                   }
 #               else
 #                   {
 #                   $istkundeerstellt = "`n kundennummer war vorhanden, wurde aus der DB genommen  `n"
 #                   $customer_id = $result
 #                   $war_vorhanden = $true
 #                   }
 #               }
 #           else
 #               {
 #               $istkundeerstellt = "`n kundennummer war vorhanden, wurde aus der DB genommen  `n"
 #               $customer_id = $result
 #               $war_vorhanden = $true
 #               }
 #          $connection.close()
 #          
 #        #if($xml.Customers.Customer.PrivateCustomerData.Person.Email.address)
 #        #{}
 #        #else
 #        #{
 #         $xml.Customers.Company.Id.InnerText = "$customer_id"
 #        #}
 #          $shopid = $xml.Customers.ControlInfo.GeneratorInfo
 #          $xml.Customers.Customer.Id.InnerText = "$customer_id"
 #          
 #          if($war_vorhanden -eq $true)
 #          {
 #               remove-item d:\import\expeedoshop\temp\Kunden\$datei
 #          }
 #          else
 #          {
 #               $xml.Save("d:\import\expeedoshop\temp\Kunden\$datei")
 #          }
 #          
 #          [xml]$xml_order = get-content d:\import\expeedoshop\temp\Bestellungen\$datei
 #          $xml_order.Order.OrderHeader.OrderParties.BuyerParty.PartyId.InnerText = "$customer_id"
 #          $xml_order.Order.OrderHeader.OrderParties.DeliveryParty.PartyId.InnerText = "$customer_id"
 #          $xml_order.Order.OrderHeader.OrderParties.InvoiceParty.PartyId.InnerText = "$customer_id"
 #          $xml_order.Save("d:\import\expeedoshop\temp\Bestellungen\$datei")
 #          if(!$result)
 #          {
 #              $customer_id++
 #              $saved_variables.Customers.next_customer_id = $customer_id.ToString()
 #              $saved_variables.Save("d:\import\expeedoshop\ps\saved_variables.xml")
 #          }
 #          $content = $shopid
 #          $content += $istkundeerstellt
 #          $content += $customer_id
 #          sendmail "tpi@warensortiment.de" $content       
 #          
 #        }
 #        
        }
         
 
if ($datei)
{
robocopy D:\import\expeedoshop\temp\Kunden D:\import\expeedoshop\Kunden /MOV
sleep 400
#eparcel start
cd "D:\import\expeedoshop\ps\"
php eParcel_check.php
sleep 20
robocopy D:\import\expeedoshop\temp\Bestellungen D:\import\expeedoshop\Bestellungen /MOV
}