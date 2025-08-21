codeunit 50104 "Seminar-Post"
{
    TableNo = "Seminar Registration Header";

    trigger OnRun()
    begin
        Code(Rec); // post current seminar registration
    end;

    procedure Code(var SemRegHeader: Record "Seminar Registration Header")
    var
        PostedSemRegHeader: Record "Posted Seminar Reg.Header";
        PostedSemRegLine: Record "Posted Seminar Reg.Line";
        SemRegLine: Record "Seminar Registration Line";
        NextLineNo: Integer;
    begin
        if not Confirm('Do you want to post this seminar registration?', false) then
            exit;

        // Insert posted header
        PostedSemRegHeader.Init();
        PostedSemRegHeader.TransferFields(SemRegHeader, true); // copies fields
        PostedSemRegHeader."No." := SemRegHeader."No.";
        PostedSemRegHeader."Posting Date" := Today;
        PostedSemRegHeader.Insert();

        // Insert posted lines
        SemRegLine.SetRange("Document No.", SemRegHeader."No.");
        if SemRegLine.FindSet() then begin
            NextLineNo := 10000;
            repeat
                PostedSemRegLine.Init();
                PostedSemRegLine.TransferFields(SemRegLine, true);
                PostedSemRegLine."Document No." := PostedSemRegHeader."No.";
                PostedSemRegLine."Line No." := NextLineNo;
                PostedSemRegLine.Insert();

                NextLineNo += 10000;
            until SemRegLine.Next() = 0;
        end;

        // Example: create a seminar ledger entry
        CreateSeminarLedgerEntries(SemRegHeader);

        // Optionally delete the unposted registration
        SemRegHeader.Delete(true);

        Commit();
        Message('Seminar %1 has been posted as %2', SemRegHeader."No.", PostedSemRegHeader."No.");
    end;


    local procedure CreateSeminarLedgerEntries(SemRegHeader: Record "Seminar Registration Header")
    var
        SemLedgerEntry: Record "Seminar Ledger Entry";
    begin
        SemLedgerEntry.Init();
        SemLedgerEntry."Document No." := SemRegHeader."No.";
        SemLedgerEntry."Posting Date" := Today;
        SemLedgerEntry."Seminar No." := SemRegHeader."Seminar Code";
        SemLedgerEntry.Insert();
    end;
}
