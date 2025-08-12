namespace seminarmanagementbcal.seminarmanagementbcal;

codeunit 50106 "Seminar Document-Print"
{
    TableNo = "Seminar Registration Header";
    procedure PrintSeminarRegistrationHeader(var SemRegHeader: Record "Seminar Registration Header")
    var
        SemRepSelection: Record "Seminar Report Selections";
    begin
        SemRegHeader.SetRange("No.", SemRegHeader."No.");

        SemRepSelection.SetRange(Usage, SemRepSelection.Usage::"S.Registration");
        SemRepSelection.SetFilter("Report ID", '<>%1', 0);

        if SemRepSelection.FindSet() then
            repeat
                Report.RunModal(SemRepSelection."Report ID", true, true, SemRegHeader);
            until SemRepSelection.Next() = 0;
    end;

}
