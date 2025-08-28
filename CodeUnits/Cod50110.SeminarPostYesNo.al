namespace seminarmanagementbcal.seminarmanagementbcal;

codeunit 50110 "Seminar-Post (Yes/No)"
{


    TableNo = "Seminar Registration Header";

    trigger OnRun()
    begin
        // Copy current record into our working variable
        SemRegHeader := Rec;

        // Call the Code() function (which asks for confirmation + runs posting)
        Code();

        // Copy the result back into Rec
        Rec := SemRegHeader;
    end;

    var
        SemRegHeader: Record "Seminar Registration Header";
        SeminarPost: Codeunit "Seminar-Post";

    local procedure Code()
    begin
        // Confirm with user before posting
        if not Confirm('Do you want to post the registration?', false) then
            exit;

        // Run the posting engine
        SeminarPost.Run(SemRegHeader);

        // Save changes permanently
        Commit();
    end;

}
