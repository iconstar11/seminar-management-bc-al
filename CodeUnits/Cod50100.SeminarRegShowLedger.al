namespace seminarmanagementbcal.seminarmanagementbcal;

codeunit 50100 "Seminar Reg.-Show Ledger"
{
    TableNo = "Seminar Register";

    trigger OnRun()
    var
        SemRegEntryRec: Record "Seminar Ledger Entry";
    begin
        SemRegEntryRec.SetRange("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        Page.Run(Page::"Seminar Ledger Entries", SemRegEntryRec);
    end;

}
