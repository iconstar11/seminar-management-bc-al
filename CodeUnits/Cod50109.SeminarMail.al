namespace seminarmanagementbcal.seminarmanagementbcal;
using Microsoft.Sales.Customer;
using Microsoft.CRM.Contact;
using System.Email;

codeunit 50109 SeminarMail
{

    // --- Globals (Step 2) ---
    var
        SemRegHeader: Record "Seminar Registration Header";
        SemRegLine: Record "Seminar Registration Line";
        Customer: Record Customer;
        Contact: Record Contact;
        ErrorCounter: Integer;

        // Book uses Automation MAPIHandler (obsolete in BC) 
        // Placeholder here: we won't implement it, but declared for completeness
        // MAPIHandler: Automation "Navision Attain ApplicationHandler".MAPIHandler;

        // --- Text Constants (Step 3) ---
        TextSubject: Label 'Seminar Confirmation';
        TextGreeting: Label 'Dear %1,';
        TextConfirm: Label 'We confirm your registration for the seminar: %1';
        TextSignature: Label 'Best regards, Training Dept.';
}
