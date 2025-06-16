table 50107 "Seminar Registration Line"
{
    Caption = 'Seminar Registration Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Seminar Registration Header";
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
        field(4; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;
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
        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
        }
        field(12; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
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
