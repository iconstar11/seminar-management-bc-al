page 50110 "Seminar Comment Sheet"
{
    PageType = List;
    SourceTable = "Seminar Comment Line";
    ApplicationArea = All;
    Caption = 'Seminar Comment Sheet';
    DelayedInsert = true; // Record saved when user leaves the row
    AutoSplitKey = true; // Auto-generates Line No.

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Visible = false; // This field is hidden
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Comments)
            {
                action("Comments List (F5)")
                {
                    ApplicationArea = All;
                    Caption = 'Comments List';
                    ShortcutKey = 'F5';
                    RunObject = Page "Seminar Comment List"; // Page 50100
                }
            }
        }
    }


}
