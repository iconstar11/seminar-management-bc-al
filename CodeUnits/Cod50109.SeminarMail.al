namespace seminarmanagementbcal.seminarmanagementbcal;
using Microsoft.Sales.Customer;
using Microsoft.CRM.Contact;
using System.Email;

codeunit 50109 SeminarMail
{
    var
        SemRegHeader: Record "Seminar Registration Header";
        SemRegLine: Record "Seminar Registration Line";
        Customer: Record Customer;
        Contact: Record Contact;
        ErrorCounter: Integer;

        TextSubject: Label 'Seminar Confirmation';
        TextGreeting: Label 'Dear %1,';
        TextConfirm: Label 'We confirm your registration for the seminar: %1';
        TextSignature: Label 'Best regards, Training Dept.';

    procedure NewConfirmationMessage(var SemRegLine: Record "Seminar Registration Line")
    var
        Contact: Record Contact;
        Customer: Record Customer;
        EmailMsg: Codeunit "Email Message";
        Email: Codeunit Email;
        BodyText: Text;
        ToList: List of [Text];
        CcList: List of [Text];
        BccList: List of [Text];
    begin
        // Get Contact
        if SemRegLine."Participant Contact No." <> '' then
            if Contact.Get(SemRegLine."Participant Contact No.") then;

        // Get Customer
        if SemRegLine."Bill-to Customer No." <> '' then
            if Customer.Get(SemRegLine."Bill-to Customer No.") then;

        // Build the email body
        BodyText :=
            StrSubstNo(TextGreeting, Contact.Name) + '\n' +
            'Thank you for registering for the seminar.' + '\n' +
            'We look forward to seeing you.' + '\n' +
            TextSignature;

        // Build recipient lists
        if Contact."E-Mail" <> '' then
            ToList.Add(Contact."E-Mail");
        if Customer."E-Mail" <> '' then
            CcList.Add(Customer."E-Mail");

        // Create the email message
        EmailMsg.Create(
            ToList,             // To
            TextSubject,        // Subject
            BodyText,           // Body
            false,              // IsBodyHtml (true if you want HTML)
            CcList,             // CC
            BccList             // BCC (empty list)
        );

        // Send email (interactive = shows to user)
        Email.Send(EmailMsg, Enum::"Email Scenario"::Default);

        // Update confirmation date if send succeeds
        SemRegLine.Validate("Confirmation Date", Today());
        SemRegLine.Modify(true);
    end;

}
