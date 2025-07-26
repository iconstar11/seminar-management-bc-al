namespace seminarmanagementbcal.seminarmanagementbcal;

page 50124 "Posted Seminar Reg.Listpart"
{
    ApplicationArea = All;
    Caption = 'Posted Seminar Reg.Listpart';
    PageType = ListPart;
    SourceTable = "Posted Seminar Reg.Line";
    DelayedInsert = true;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Bill-to Customer No. field.', Comment = '%';
                }
                field("Participant Contact No."; Rec."Participant Contact No.")
                {
                    ToolTip = 'Specifies the value of the Participant Contact No. field.', Comment = '%';
                }
                field("Participant Name"; Rec."Participant Name")
                {
                    ToolTip = 'Specifies the value of the Participant Name field.', Comment = '%';
                }
                field(Participated; Rec.Participated)
                {
                    ToolTip = 'Specifies the value of the Participated field.', Comment = '%';
                }
                field("Register Date"; Rec."Register Date")
                {
                    ToolTip = 'Specifies the value of the Register Date field.', Comment = '%';
                }
                field("Confirmation Date"; Rec."Confirmation Date")
                {
                    ToolTip = 'Specifies the value of the Confirmation Date field.', Comment = '%';
                }
                field("To Invoice"; Rec."To Invoice")
                {
                    ToolTip = 'Specifies the value of the To Invoice field.', Comment = '%';
                }
                field(Registered; Rec.Registered)
                {
                    ToolTip = 'Specifies the value of the Registered field.', Comment = '%';
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ToolTip = 'Specifies the value of the Seminar Price field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ToolTip = 'Specifies the value of the Line Discount % field.', Comment = '%';
                    BlankZero = true;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ToolTip = 'Specifies the value of the Line Discount Amount field.', Comment = '%';
                    BlankZero = true;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
            }

        }
    }
}
