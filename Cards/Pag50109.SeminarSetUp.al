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
                field(Seminar; Rec.Seminar)
                {
                    ToolTip = 'Specifies the value of the Seminar field.', Comment = '%';
                }
                field("Job Journal Template"; Rec."Job Journal Template")
                {
                    ToolTip = 'Specifies the value of the Job Journal Template field.', Comment = '%';
                }

                field("Job Journal Batch"; Rec."Job Journal Batch")
                {
                    ToolTip = 'Specifies the value of the Job Journal Batch field.', Comment = '%';
                }

                field("Job Source Code"; Rec."Job Source Code")
                {
                    ToolTip = 'Specifies the value of the Job Source Code field.', Comment = '%';
                }

                field("Default Job Task No."; Rec."Default Job Task No.")
                {
                    ToolTip = 'Specifies the value of the Default Job Task No. field.', Comment = '%';
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
