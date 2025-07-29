namespace seminarmanagementbcal.seminarmanagementbcal;

page 50125 "Posted Seminar Reg.Card"
{
    ApplicationArea = All;
    Caption = 'Posted Seminar Reg.Card';
    PageType = Card;
    SourceTable = "Posted Seminar Reg.Header";

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
                field("Seminar No."; Rec."Seminar No.")
                {
                    ToolTip = 'Specifies the value of the Seminar No. field.', Comment = '%';
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
            group(Invoicing)
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

            part(SeminarRegLines; "Posted Seminar Reg.Listpart")
            {
                Caption = 'Posted Seminar Reg. Lines';
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Navigate)
            {
                Caption = 'Navigate';
                ShortcutKey = 'F11';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
            }
        }
    }

}
