namespace seminarmanagementbcal.seminarmanagementbcal;
using System.Utilities;

report 50100 "Seminar Reg.Participant List"
{
    ApplicationArea = All;
    Caption = 'Seminar Reg.- Participant List';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Seminar Registration Header"; "Seminar Registration Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Seminar Code", "No. Printed";

            column(No; "No.") { }
            column(SeminarCode; "Seminar Code") { }
            column(SeminarName; "Seminar Name") { }
            column(Duration; "Duration") { }
            column(InstructorName; "Instructor Name") { }
            column(RoomName; "Room Name") { }

            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));

                    dataitem("Seminar Registration Line"; "Seminar Registration Line")
                    {
                        DataItemTableView = sorting("Document No.", "Line No.");
                        DataItemLinkReference = "Seminar Registration Header";
                        DataItemLink = "Document No." = field("No.");

                        // Add any additional participant fields you need
                    }
                }
            }
        }
    }

    // layout
    // {
    //     rcdl Or Word layout
    // }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    // Optional filters/fields
                }
            }
        }
    }
}
