namespace ALProject.ALProject;

page 50103 "Instructor List"
{
    ApplicationArea = All;
    Caption = 'Instructor List';
    PageType = List;
    SourceTable = Instructor;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }


                field("Internal/External"; Rec."Internal/External")
                {
                    ToolTip = 'Specifies the value of the Internal/External field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }

                field("Contact No."; Rec."Contact No.")
                {
                    ToolTip = 'Specifies the value of the Contact No. field.', Comment = '%';
                }
                field("Resource No. "; Rec."Resource No. ")
                {
                    ToolTip = 'Specifies the value of the Resource No. field.', Comment = '%';
                }
            }
        }
    }
}
