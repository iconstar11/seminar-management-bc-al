namespace seminarmanagementbcal.seminarmanagementbcal;
using Microsoft.CRM.Contact;

xmlport 50101 "Import Contact"
{
    Caption = 'Import Contact';
    Direction = Import;
    Format = VariableText; // allows CSV or TXT import
    UseRequestPage = true;

    schema
    {
        textelement(Root)
        {
            tableelement(Contact; Contact)
            {
                AutoSave = true; // inserts directly

                fieldelement(No; Contact."No.") { }
                fieldelement(Name; Contact.Name) { }
                fieldelement(Type; Contact.Type) { }
                fieldelement(Address; Contact.Address) { }
                fieldelement(Address2; Contact."Address 2") { }
                fieldelement(City; Contact.City) { }
                fieldelement(CountryCode; Contact."Country/Region Code") { }
                fieldelement(PhoneNo; Contact."Phone No.") { }
                fieldelement(CompanyNo; Contact."Company No.") { }
                fieldelement(CurrencyCode; Contact."Currency Code") { }
            }
        }
    }
}
