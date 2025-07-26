table 50113 "Posted Seminar Reg.Line"
{
    Caption = 'Posted Seminar Reg.Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            // TableRelation= "Posted Seminar Reg.Line";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(4; "Participant Contact No."; Code[100])
        {
            Caption = 'Participant Contact No.';
            Editable = false;
            FieldClass = FlowField;

            CalcFormula = lookup(Contact.Name where("No." = field("Participant Contact No.")));
        }
        field(5; "Participant Name"; Text[50])
        {
            Caption = 'Participant Name';
        }
        field(6; "Register Date"; Date)
        {
            Caption = 'Register Date';
            Editable = false;
        }
        field(7; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            InitValue = true;
        }
        field(8; Participated; Boolean)
        {
            Caption = 'Participated';
        }
        field(9; "Confirmation Date"; Date)
        {
            Caption = 'Confirmation Date';
            Editable = false;
        }
        field(10; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 2;
        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
        }
        field(12; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            AutoFormatType = 1;
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;
        }
        field(14; Registered; Boolean)
        {
            Caption = 'Registered';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
