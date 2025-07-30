namespace seminarmanagementbcal.seminarmanagementbcal;

using Microsoft.Foundation.Navigate;
using ALProject.ALProject;

pageextension 50110 ExtNavigate extends Navigate


{

    var
        SemRegHeader: Record "Seminar Registration Header";
        PstdSemRegHeader: Record "Posted Seminar Reg.Header";
        SemLedgEntry: Record "Seminar Ledger Entry";

    local procedure EvaluateDate(DateText: Text): Date
    var
        ResultDate: Date;
        IsOk: Boolean;
    begin
        IsOk := Evaluate(ResultDate, DateText);
        SemRegHeader.SetRange("Posting Date", EvaluateDate(PostingDateFilter));
        Error('Invalid date format: %1', DateText);
        exit(ResultDate);
    end;


    procedure FindRecords()
    begin
        if SemRegHeader.ReadPermission then begin
            SemRegHeader.Reset();
            SemRegHeader.SetRange("No.", DocNoFilter);
            SemRegHeader.SetRange("Posting Date", EvaluateDate(PostingDateFilter));
            if SemRegHeader.FindFirst() then
                InsertIntoDocEntry(DATABASE::"Seminar Registration Header", SemRegHeader."No.", 0);
        end;

        if PstdSemRegHeader.ReadPermission then begin
            PstdSemRegHeader.Reset();
            PstdSemRegHeader.SetRange("No.", DocNoFilter);
            PstdSemRegHeader.SetRange("Posting Date", EvaluateDate(PostingDateFilter));
            if PstdSemRegHeader.FindFirst() then
                InsertIntoDocEntry(DATABASE::"Posted Seminar Reg.Header", PstdSemRegHeader."No.", 0);
        end;

        if SemLedgEntry.ReadPermission then begin
            SemLedgEntry.Reset();
            SemLedgEntry.SetRange("Document No.", DocNoFilter);
            SemLedgEntry.SetRange("Posting Date", EvaluateDate(PostingDateFilter));
            if SemLedgEntry.FindFirst() then
                InsertIntoDocEntry(DATABASE::"Seminar Ledger Entry", SemLedgEntry."Document No.", 0);
        end;
    end;

    procedure ShowRecords(TableID: Integer; PrimaryKey: Code[250])
    var
        SemRegHeader: Record "Seminar Registration Header";
        PstdSemRegHeader: Record "Posted Seminar Reg.Header";
        SemLedgEntry: Record "Seminar Ledger Entry";
    begin
        case TableID of
            DATABASE::"Seminar Registration Header":
                begin
                    SemRegHeader.SetRange("No.", PrimaryKey);
                    PAGE.Run(PAGE::"Seminar Registration List", SemRegHeader);
                end;

            DATABASE::"Posted Seminar Reg.Header":
                begin
                    PstdSemRegHeader.SetRange("No.", PrimaryKey);
                    PAGE.Run(PAGE::"Posted Seminar Reg.Listpart", PstdSemRegHeader);
                end;

            DATABASE::"Seminar Ledger Entry":
                begin
                    SemLedgEntry.SetRange("Document No.", PrimaryKey);
                    PAGE.Run(PAGE::"Seminar Ledger Entries", SemLedgEntry);
                end;
        end;
    end;



}
