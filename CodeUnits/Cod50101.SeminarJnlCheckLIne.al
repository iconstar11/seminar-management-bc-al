namespace seminarmanagementbcal.seminarmanagementbcal;
using System.Security.User;
using Microsoft.Finance.GeneralLedger.Setup;

codeunit 50101 "Seminar Jnl.-Check LIne"
{
    TableNo = "Seminar Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);

    end;

    procedure RunCheck(var SemJnlLine: Record "Seminar Journal Line")
    var
        UserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";

    begin
        if SemJnlLine."Seminar No." = '' then
            Error('Seminar No cannot be empty');
        if SemJnlLine."Posting Date" = 0D then
            Error('Posting Date cannot be empty');

        if SemJnlLine."Job No." = '' then
            Error('Job No. must not be blank.');


        if SemJnlLine."Seminar No." = '' then
            Error('Seminar No. must not be blank.');

        // 3. Charge Type dependent checks
        // case SemJnlLine."Charge Type" of
        //     SemJnlLine."Charge Type"::Instructor:
        //         if SemJnlLine."Instructor Code" = '' then
        //             Error('Instructor Code must not be blank for Instructor charges.');

        //     SemJnlLine."Charge Type"::Room:
        //         if SemJnlLine."Room Code" = '' then
        //             Error('Room Code must not be blank for Room charges.');

        //     SemJnlLine."Charge Type"::Participant:
        //         if SemJnlLine."Participant Contact No." = '' then
        //             Error('Participant Contact No. must not be blank for Participant charges.');
        // end;

        if SemJnlLine.Chargeable and (SemJnlLine."Bill-to Customer No." = '') then
            Error('Bill-to Customer No. must not be blank for chargeable lines.');

        if SemJnlLine."Posting Date" <> 0D then
            if ClosingDate(SemJnlLine."Posting Date") = SemJnlLine."Posting Date" then
                Error('Posting Date cannot be a closing date.');

        if not UserSetup.Get(UserId) then
            GLSetup.Get();

        if UserSetup.Get(UserId) then begin
            if (UserSetup."Allow Posting From" <> 0D) and (SemJnlLine."Posting Date" < UserSetup."Allow Posting From") then
                Error('Posting Date is before your allowed posting period.');

            if (UserSetup."Allow Posting To" <> 0D) and (SemJnlLine."Posting Date" > UserSetup."Allow Posting To") then
                Error('Posting Date is after your allowed posting period.');
        end else begin
            GLSetup.Get();

            if (GLSetup."Allow Posting From" <> 0D) and (SemJnlLine."Posting Date" < GLSetup."Allow Posting From") then
                Error('Posting Date is before the allowed global posting period.');

            if (GLSetup."Allow Posting To" <> 0D) and (SemJnlLine."Posting Date" > GLSetup."Allow Posting To") then
                Error('Posting Date is after the allowed global posting period.');
        end;

        // 7. Closing date check for Document Date
        if ClosingDate(SemJnlLine."Document Date") = SemJnlLine."Document Date" then
            Error('Document Date cannot be a closing date.');

    end;

}
