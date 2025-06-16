namespace ALProject.ALProject;

page 50101 "Seminar Room List"
{
    ApplicationArea = All;
    Caption = 'Seminar Room List';
    PageType = List;
    SourceTable = "Seminar Room";
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
}
