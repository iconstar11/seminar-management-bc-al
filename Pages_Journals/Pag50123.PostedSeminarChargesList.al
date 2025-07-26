namespace seminarmanagementbcal.seminarmanagementbcal;

page 50123 "Posted Seminar Charges List"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    Caption = 'Posted Seminar Charges List';
    PageType = Card;
    SourceTable = "Posted Seminar Charge";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Bill-to Customer No. field.', Comment = '%';
                }
                field("To Invoice"; Rec."To Invoice")
                {
                    ToolTip = 'Specifies the value of the To Invoice field.', Comment = '%';
                }
                field("Unit Of Measure Code"; Rec."Unit Of Measure Code")
                {
                    ToolTip = 'Specifies the value of the Unit Of Measure Code field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.', Comment = '%';
                }
                field("Total Price"; Rec."Total Price")
                {
                    ToolTip = 'Specifies the value of the Total Price field.', Comment = '%';
                }
            }
        }
    }
}
