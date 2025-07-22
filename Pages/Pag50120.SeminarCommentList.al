namespace seminarmanagementbcal.seminarmanagementbcal;

page 50120 "Seminar Comment List"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Seminar Comment List';
    PageType = List;
    Editable = false;
    SourceTable = "Seminar Comment Line";

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
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                }
            }
        }
    }
}
