namespace seminarmanagementbcal.seminarmanagementbcal;
using Microsoft.Foundation.NoSeries;

codeunit 50102 "Seminar Jnl.-Post Line"
{
    TableNo = "Seminar Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);


    end;

    procedure GetSemReg(var NewSemReg: Record "Seminar Register")
    begin
        NewSemReg := SemReg;

    end;

    procedure RunWithCheck(var SemJnlLine2: Record "Seminar Journal Line")
    begin
        SemJnlLine := SemJnlLine2;
        Code();
        SemJnlLine2 := SemJnlLine;

    end;

    procedure Code()
    var
        SemJnlCheckLine: Codeunit "Seminar Jnl.-Check Line";
        SemLedgEntry: Record "Seminar Ledger Entry";
        LastEntry: Record "Seminar Ledger Entry";
        LastRegister: Record "Seminar Register";
        TodayDate: Date;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Semsetup: Record "Seminar SetUp";
    begin
        // 1. Exit if line is empty
        if (SemJnlLine."Posting Date" = 0D) and (SemJnlLine."Document No." = '') then
            exit;

        // 2. Run validation
        SemJnlCheckLine.RunCheck(SemJnlLine);

        // 3. Determine NextEntryNo
        if NextEntryNo = 0 then begin
            SemLedgEntry.LockTable();
            if LastEntry.FindLast() then
                NextEntryNo := LastEntry."Entry No." + 1
            else
                NextEntryNo := 1;
        end;

        // 4. Fill missing Document Date
        if SemJnlLine."Document Date" = 0D then
            SemJnlLine."Document Date" := SemJnlLine."Posting Date";

        // 5. Manage Seminar Register
        if SemReg."No." = 0 then begin
            SemReg.LockTable();

            if (not LastRegister.FindLast()) or (LastRegister."To Entry No." <> 0) then begin
                SemReg.Init();

                if not LastRegister.FindLast() then
                    SemReg."No." := 1
                else
                    SemReg."No." := LastRegister."No." + 1;

                SemReg."Creation Date" := Today();
                SemReg."User ID" := UserId;
                SemReg."Source Code" := SemJnlLine."Source Code";
                SemReg."Journal Batch Name" := SemJnlLine."Journal Batch Name";
                SemReg."From Entry No." := NextEntryNo;
                SemReg.Insert();
            end else
                SemReg := LastRegister;
        end;
        // 6. Update To Entry No. and save register
        SemReg."To Entry No." := NextEntryNo;
        SemReg.Modify();

        // 7. Insert new Seminar Ledger Entry
        // SemLedgEntry.Init();

        // SemLedgEntry.TransferFields(SemJnlLine);
        // SemLedgEntry."Entry No." := NextEntryNo;
        // SemLedgEntry.Insert();

        SemLedgEntry.Init();

        // Always assign the Entry No. separately (NextEntryNo logic)
        if SemLedgEntry.FindLast() then
            SemLedgEntry."Entry No." := SemLedgEntry."Entry No." + 1
        else
            SemLedgEntry."Entry No." := 1;

        // Map fields explicitly
        SemLedgEntry."Seminar No." := SemJnlLine."Seminar No.";
        SemLedgEntry."Posting Date" := SemJnlLine."Posting Date";
        SemLedgEntry."Document Date" := SemJnlLine."Document Date";
        SemLedgEntry."Entry Type" := SemJnlLine."Entry Type";
        SemLedgEntry."Document No." := SemJnlLine."Document No.";
        SemLedgEntry.Description := SemJnlLine.Description;
        SemLedgEntry."Bill-to Customer No." := SemJnlLine."Bill-to Customer No.";
        SemLedgEntry."Charge Type" := SemJnlLine."Charge Type";
        SemLedgEntry."Type" := SemJnlLine."Type";
        SemLedgEntry.Quantity := SemJnlLine.Quantity;
        SemLedgEntry."Unit Price" := SemJnlLine."Unit Price";
        SemLedgEntry."Total Price" := SemJnlLine."Total Price";
        SemLedgEntry."Participant Contact No." := SemJnlLine."Participant Contact No.";
        SemLedgEntry."Participant Name" := SemJnlLine."Participant Name";
        SemLedgEntry.Chargeable := SemJnlLine.Chargeable;
        SemLedgEntry."Room Code" := SemJnlLine."Room Code";
        SemLedgEntry."Instructor Code" := SemJnlLine."Instructor Code";
        SemLedgEntry."Starting Date" := SemJnlLine."Starting Date";
        SemLedgEntry."Seminar Registration No." := SemJnlLine."Seminar Registration No.";
        SemLedgEntry."Job No." := SemJnlLine."Job No.";
        SemLedgEntry."Job Ledger Entry No." := SemJnlLine."Job Ledger Entry No.";
        SemLedgEntry."Source Type" := SemJnlLine."Source Type";
        SemLedgEntry."Source No." := SemJnlLine."Source No.";  // careful, your field is spelled "Sorce No."
        SemLedgEntry."Journal Batch Name" := SemJnlLine."Journal batch Name";
        SemLedgEntry."Source Code" := SemJnlLine."Source Code";
        SemLedgEntry."Reason Code" := SemJnlLine."Reason Code";
        SemLedgEntry."No. Series" := SemJnlLine."Posting No. Series";
        SemLedgEntry."User ID" := CopyStr(UserId, 1, MaxStrLen(SemLedgEntry."User ID"));

        // Insert the Ledger Entry
        SemLedgEntry.Insert();


        // 8. Increment entry counter
        NextEntryNo += 1;
    end;



    var
        SemJnlLine: Record "Seminar Journal Line";
        SemLedgEntry: Record "Seminar Ledger Entry";
        SemReg: Record "Seminar Register";
        SemJnlCheckLIne: Codeunit "Seminar Jnl.-Check LIne";
        NextEntryNo: Integer;

}
