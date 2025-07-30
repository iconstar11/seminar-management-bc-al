namespace seminarmanagementbcal.seminarmanagementbcal;

using Microsoft.Foundation.Navigate;

pageextension 50110 ExtNavigate extends Navigate


{

    var
        SemRegHeader: Record "Seminar Registration Header";
        PstdSemRegHeader: Record "Posted Seminar Reg.Header";
        SemLedgEntry: Record "Seminar Ledger Entry";


    procedure FindRecords()
    begin
        if SemRegHeader.ReadPermission then begin
            SemRegHeader.Reset();
            SemRegHeader.SetRange("No.", DocNoFilter);
            SemRegHeader.SetRange("Posting Date", PostingDateFilter);
            if SemRegHeader.FindFirst() then
                InsertIntoDocEntry(DATABASE::"Seminar Registration Header", SemRegHeader."No.");
        end;

        if PstdSemRegHeader.ReadPermission then begin
            PstdSemRegHeader.Reset();
            PstdSemRegHeader.SetRange("No.", DocNoFilter);
            PstdSemRegHeader.SetRange("Posting Date", PostingDateFilter);
            if PstdSemRegHeader.FindFirst() then
                InsertIntoDocEntry(DATABASE::"Posted Seminar Reg. Header", PstdSemRegHeader."No.");
        end;

        if SemLedgEntry.ReadPermission then begin
            SemLedgEntry.Reset();
            SemLedgEntry.SetRange("Document No.", DocNoFilter);
            SemLedgEntry.SetRange("Posting Date", PostingDateFilter);
            if SemLedgEntry.FindFirst() then
                InsertIntoDocEntry(DATABASE::"Seminar Ledger Entry", SemLedgEntry."Document No.");
        end;
    end;

}
