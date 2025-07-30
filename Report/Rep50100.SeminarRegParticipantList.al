namespace seminarmanagementbcal.seminarmanagementbcal;

report 50100 "Seminar Reg.Participant List"
{
    ApplicationArea = All;
    Caption = 'Seminar Reg.Participant List';
    UsageCategory = Administration;
    dataset
    {
        dataitem(SeminarRegistrationHeader; "Seminar Registration Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Seminar Code", "No. Printed";
            column(No; "No.")
            {
            }
            column(SeminarCode; "Seminar Code")
            {
            }
            column(SeminarName; "Seminar Name")
            {
            }
            column(Duration; "Duration")
            {
            }
            column(InstructorName; "Instructor Name")
            {
            }
            column(RoomName; "Room Name")
            {
            }
        }
        //     dataitem(CopyLoop; "Seminar Registration Header"){
        //         DataItemTableView = No

        //     }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
