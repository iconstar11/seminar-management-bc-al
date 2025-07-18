namespace ALProject.ALProject;
using Microsoft.Foundation.Comment;
using Microsoft.Foundation.ExtendedText;

page 50101 "Seminar Room List"
{
    ApplicationArea = All;
    Caption = 'Seminar Room List';
    PageType = List;
    SourceTable = "Seminar Room";
    Editable = false;
    CardPageId = 50149;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Code "; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }

                field("Maximum Participants "; Rec."Maximum Participants ")
                {
                    ToolTip = 'Specifies the value of the Maximum Participants field.', Comment = '%';
                }

                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies the value of the Resource No. field.', Comment = '%';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Open Card")
            {
                Caption = 'Open Card';
                RunObject = page "Seminar Room card";
                Promoted = true;

            }
            action(Comments)
            {
                Caption = 'Open Comments Sheet';
                RunObject = page "Comment Sheet";
                Promoted = true;
            }
            action(Seminar)
            {
                Caption = 'Extended Text';
                RunObject = page "Extended Text";
                Promoted = true;
            }
        }
    }
}
