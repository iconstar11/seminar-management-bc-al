namespace ALProject.ALProject;

page 50104 "Seminar Card"
{
    ApplicationArea = All;
    Caption = 'Seminar Card';
    PageType = Card;
    SourceTable = Seminar;
    Editable = true;

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
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    ToolTip = 'Specifies the value of the Seminar Duration field.', Comment = '%';
                }
                field("Minimum Participarts"; Rec."Minimum Participarts")
                {
                    ToolTip = 'Specifies the value of the Minimum Participarts field.', Comment = '%';
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ToolTip = 'Specifies the value of the Maximum Participants field.', Comment = '%';
                }
                field("Search Name "; Rec."Search Name ")
                {
                    ToolTip = 'Specifies the value of the Search Name field.', Comment = '%';
                }
                field(Bloked; Rec.Bloked)
                {
                    ToolTip = 'Specifies the value of the Bloked field.', Comment = '%';
                }
                field("Last Date Modified "; Rec."Last Date Modified ")
                {
                    ToolTip = 'Specifies the value of the Last Date Modified field.', Comment = '%';
                }

            }
            group(Invoicing)
            {
                field("Seminar Price"; Rec."Seminar Price")
                {

                }
                field("Gen. Prod. Posting group"; Rec."Gen. Prod. Posting group")
                {

                }
                field("Vat Prod. Posting Group"; Rec."Vat Prod. Posting Group")
                {

                }
                field("Job No."; Rec."Job No.")
                {

                }


            }
        }
    }
}
