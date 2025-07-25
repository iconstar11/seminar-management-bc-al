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
        SemLedgEntry.Init();
        SemLedgEntry."Entry No." := NextEntryNo;
        SemLedgEntry.TransferFields(SemJnlLine);
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
