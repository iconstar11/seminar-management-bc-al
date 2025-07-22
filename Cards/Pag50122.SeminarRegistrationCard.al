namespace seminarmanagementbcal.seminarmanagementbcal;
using ALProject.ALProject;

page 50122 "Seminar Registration Card"
{
    ApplicationArea = All;
    Caption = 'Seminar Registration Card';
    PageType = Card;
    SourceTable = "Seminar Registration Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
                field("Instructor Code"; Rec."Instructor Code")
                {
                    ToolTip = 'Specifies the value of the Instructor Code field.', Comment = '%';
                }
                field("Instructor Name"; Rec."Instructor Name")
                {
                    ToolTip = 'Specifies the value of the Instructor Name field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
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
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ToolTip = 'Specifies the value of the Minimum Participants field.', Comment = '%';
                }
            }
            group("Seminar Room")
            {
                field("Room Code"; Rec."Room Code")
                {
                    ToolTip = 'Specifies the value of the Room Code field.', Comment = '%';
                }
                field("Room Name"; Rec."Room Name")
                {
                    ToolTip = 'Specifies the value of the Room Name field.', Comment = '%';
                }
                field("Room Address"; Rec."Room Address")
                {
                    ToolTip = 'Specifies the value of the Room Address field.', Comment = '%';
                }
                field("Room Address2"; Rec."Room Address2")
                {
                    ToolTip = 'Specifies the value of the Room Address2 field.', Comment = '%';
                }
                field("Room Post Code"; Rec."Room Post Code")
                {
                    ToolTip = 'Specifies the value of the Room Post Code field.', Comment = '%';
                }
                field("Room City"; Rec."Room City")
                {
                    ToolTip = 'Specifies the value of the Room City field.', Comment = '%';
                }
                field("Room Phone No."; Rec."Room Phone No.")
                {
                    ToolTip = 'Specifies the value of the Room Phone No. field.', Comment = '%';
                }
            }
            group(invoicing)
            {
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ToolTip = 'Specifies the value of the Seminar Price field.', Comment = '%';
                }
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the value of the Job No. field.', Comment = '%';
                }
            }

            part(SeminarRegistrationLines; "Seminar Registration ListPart")
            {
                // ApplicationArea = 
                SubPageLink = "Document No." = field("No.");
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("Registration")
            {
                action("Registration List (F5)")
                {
                    Caption = 'Registration List';
                    ShortcutKey = 'F5';
                    RunObject = Page "Seminar Registration LIst";
                    ApplicationArea = All;
                }

                action(Comments)
                {
                    Caption = 'Comments';
                    RunObject = Page "Seminar Comment Sheet";
                    RunPageLink = "No." = field("No.");
                    ApplicationArea = All;
                    RunPageMode = Edit;
                }

                action(Charges)
                {
                    Caption = 'Charges';
                    RunObject = Page "Seminar Charges";
                    RunPageLink = "Seminar Registration No" = field("No.");
                    ApplicationArea = All;
                    RunPageMode = Edit;
                }
            }
        }
    }
}
