namespace seminarmanagementbcal.seminarmanagementbcal;

page 50109 "Seminar SetUp"
{
    ApplicationArea = All;
    Caption = 'Seminar SetUp';
    PageType = Card;
    SourceTable = "Seminar SetUp";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Seminar Nos."; Rec."Seminar Nos.")
                {
                    ToolTip = 'Specifies the value of the Seminar Nos. field.', Comment = '%';
                }
                field("Seminar Registration Nos."; Rec."Seminar Registration Nos.")
                {
                    ToolTip = 'Specifies the value of the Seminar Registration Nos. field.', Comment = '%';
                }
                field("Posted Sem. Registration Nos."; Rec."Posted Sem. Registration Nos.")
                {
                    ToolTip = 'Specifies the value of the Posted Sem. Registration Nos. field.', Comment = '%';
                }
            }
        }
    }
}
