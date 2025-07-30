namespace seminarmanagementbcal.seminarmanagementbcal;

codeunit 50105 "Seminar Registration-Printed"
{
    TableNo = "Seminar Registration Header";

    trigger OnRun()
    var
        SemRegHeader: Record "Seminar Registration Header";
    begin
        SemRegHeader.Get(Rec."No."); // Get the current record by primary key

        SemRegHeader."No. Printed" += 1; // Increment No. Printed
        SemRegHeader.Modify(true);       // Modify with validation
        Commit();                        // Commit the change


    end;

    // local procedure IncrementNoPrint()
    // begin

    // end;

}
