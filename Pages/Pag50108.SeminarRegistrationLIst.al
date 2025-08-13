namespace ALProject.ALProject;
using seminarmanagementbcal.seminarmanagementbcal;

page 50108 "Seminar Registration LIst"
{
    ApplicationArea = All;
    Caption = 'Seminar Registration LIst';
    PageType = List;
    SourceTable = "Seminar Registration Header";
    Editable = false;
    CardPageId = 50122;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field.', Comment = '%';
                }
                field("Seminar Code"; Rec."Seminar Code")
                {
                    ToolTip = 'Specifies the value of the Seminar Code field.', Comment = '%';
                }
                field("Seminar Name"; Rec."Seminar Name")
                {
                    ToolTip = 'Specifies the value of the Seminar Name field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Duration"; Rec."Duration")
                {
                    ToolTip = 'Specifies the value of the Duration field.', Comment = '%';
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ToolTip = 'Specifies the value of the Maximum Participants field.', Comment = '%';
                }
                field("Room Code"; Rec."Room Code")
                {
                    ToolTip = 'Specifies the value of the Room Code field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(PostSeminar)
            {
                Caption = 'Post...';
                ShortcutKey = 'F11';
                RunObject = Codeunit "Seminar-Post";
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
            }
            action(PrintSeminar)
            {
                ApplicationArea = All;
                Caption = 'Print';
                Image = Print;

                trigger OnAction()
                var
                    PrintCU: Codeunit "Seminar Document-Print";
                    SemRegHeader: Record "Seminar Registration Header";
                begin
                    // Get the current record
                    SemRegHeader := Rec;
                    // Call the print function
                    PrintCU.PrintSeminarRegistrationHeader(SemRegHeader);
                end;
            }
        }
    }
}
