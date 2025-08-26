namespace seminarmanagementbcal.seminarmanagementbcal;

page 50135 "Instructor Card"
{
    ApplicationArea = All;
    Caption = 'Instructor Card';
    PageType = Card;
    SourceTable = Instructor;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Internal/External"; Rec."Internal/External")
                {
                    ToolTip = 'Specifies the value of the Internal/External field.', Comment = '%';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies the value of the Resource No. field.', Comment = '%';
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ToolTip = 'Specifies the value of the Contact No. field.', Comment = '%';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                }
                // field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                // {
                //     ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.', Comment = '%';
                // }
                // field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                // {
                //     ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.', Comment = '%';
                // }
                // field("Base Unit of Measure"; Rec."Base Unit of Measure")
                // {

                // }
            }
        }
    }
}
