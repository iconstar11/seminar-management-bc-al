namespace seminarmanagementbcal.seminarmanagementbcal;

codeunit 50104 "Seminar-Post"
{
    TableNo = "Seminar Registration Header";

    var
        SemRegHeader: Record "Seminar Registration Header";
        SeminarPost: Codeunit "Seminar-Post";


    procedure Code()
    var
        SemPost: Codeunit "Seminar-Post";
        ConfirmResponse: Boolean;
    begin
        // Ask for confirmation
        ConfirmResponse := Confirm('Do you want to post this seminar registration?', false);

        if not ConfirmResponse then
            exit;

        // Run the Seminar-Post codeunit with the current Seminar Registration Header
        SemPost.Run(SemRegHeader);

        // Commit the transaction after successful posting
        Commit();
    end;


    trigger OnRun()
    begin

    end;
}

