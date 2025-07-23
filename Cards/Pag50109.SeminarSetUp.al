namespace seminarmanagementbcal.seminarmanagementbcal;

page 50109 "Seminar SetUp"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Seminar SetUp';
    PageType = Card;
    SourceTable = "Seminar SetUp";

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';

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
    trigger OnOpenPage()
    begin
        Rec.Reset();
        // Try to get the single record (where the Primary Key is blank).
        if not Rec.Get() then begin
            // If no record exists, create a new one.
            Rec.Init();
            Rec.Insert()

        end;
    end;
}
