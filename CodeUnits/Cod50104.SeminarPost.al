codeunit 50104 "Seminar-Post"
{
    TableNo = "Seminar Registration Header";

    trigger OnRun()
    begin
        Code(Rec); // Pass in the current record
    end;

    procedure Code(var SemRegHeader: Record "Seminar Registration Header")
    var
        ConfirmResponse: Boolean;
    begin
        // Ask for confirmation
        ConfirmResponse := Confirm('Do you want to post this seminar registration?', false);
        if not ConfirmResponse then
            exit;

        // Here you’d call your actual posting logic
        // (e.g., move data into Seminar Ledger Entry)
        // Example:
        // SeminarPostingMgt.PostSeminar(SemRegHeader);

        Commit();
    end;
}
