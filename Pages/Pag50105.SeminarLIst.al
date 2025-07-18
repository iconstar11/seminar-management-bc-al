namespace ALProject.ALProject;

page 50105 "Seminar List"
{
    ApplicationArea = All;
    Caption = 'Seminar List';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Seminar;
    Editable = false;
    CardPageId = 50104;

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
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';

                }
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    ToolTip = 'Specifies the value of the Seminar Duration field.', Comment = '%';
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ToolTip = 'Specifies the value of the Maximum Participants field.', Comment = '%';
                    Visible = false;
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ToolTip = 'Specifies the value of the Seminar Price field.', Comment = '%';
                }
                field("Minimum Participarts"; Rec."Minimum Participarts")
                {
                    ToolTip = 'Specifies the value of the Minimum Participarts field.', Comment = '%';
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the value of the Job No. field.', Comment = '%';
                }
                field("Gen. Prod. Posting group"; Rec."Gen. Prod. Posting group")
                {
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting group field.', Comment = '%';
                }
                field("Vat Prod. Posting Group"; Rec."Vat Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Vat Prod. Posting Group field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            action(OpenCard)
            {
                Caption = 'Card';
                Image = Edit;
                ShortcutKey = 'Shift+F5';
                RunObject = Page "Seminar Card";
                RunPageLink = "No." = FIELD("No.");
            }
        }
    }
}
