namespace seminarmanagementbcal.seminarmanagementbcal;

page 50134 "Posted Seminar Reg. List"
{
    PageType = List;
    SourceTable = "Posted Seminar Reg.Header";
    ApplicationArea = All;
    Caption = 'Posted Seminar Registrations';
    CardPageId = 50125; // links list to the card

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Seminar No."; Rec."Seminar No.") { ApplicationArea = All; }
                field("Seminar Name"; Rec."Seminar Name") { ApplicationArea = All; }
                field("Instructor Name"; Rec."Instructor Name") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Room Code"; Rec."Room Code") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewCard)
            {
                Caption = 'View Registration';
                ApplicationArea = All;
                Image = View;
                RunObject = Page "Posted Seminar Reg.Card";
                RunPageLink = "No." = field("No.");
            }
        }
    }
}
