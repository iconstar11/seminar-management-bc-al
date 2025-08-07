report 50100 "Seminar Reg.Participant List"
{
    ApplicationArea = All;
    Caption = 'Seminar Reg.- Participant List';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = Word;

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

                        column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
                        column(Participant_Contact_No_; "Participant Contact No.") { }
                        column(Participant_Name; "Participant Name") { }
                    }
                }

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    SetRange(Number, 1, NoOfLoops);
                end;





            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Instructor Name");
            end;


            trigger OnPostDataItem()
            var
                SeminarHeader: Record "Seminar Registration Header";
            begin
                if not CurrReport.Preview then begin
                    if SeminarHeader.Get(SeminarHeaderNo) then
                        SeminarCountPrinted.Run(SeminarHeader);
                end;
            end;



        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {

            area(Content)
            {
                group(Options)
                {
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = All;
                        Caption = 'No. Of Copies';
                    }
                    // Optional filters/fields
                }
            }
        }
    }

    rendering
    {
        layout(RDLC)
        {
            Type = RDLC;
            LayoutFile = 'ReportLayout/SeminarParticipantList.rdlc';
            Caption = 'Seminar Part. List RDLC';
        }
        layout(Word)
        {
            Type = Word;
            LayoutFile = 'ReportLayout/SeminarParticipantList.docx';
            Caption = 'Seminar Part. List Word';
        }
    }

    var
        SeminarCountPrinted: Codeunit "Seminar Registration-Printed";
        NoOfCopies: Integer;
        NoOfLoops: Integer;

        SeminarHeaderNo: Code[20];
}
