table 50104 Seminar
{
    Caption = 'Seminar';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[30])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
        }
        field(4; "Minimum Participarts"; Integer)
        {
            Caption = 'Minimum Participarts';
        }
        field(5; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(6; "Search Name "; Code[30])
        {
            Caption = 'Search Name ';
        }
        field(7; Bloked; Boolean)
        {
            Caption = 'Bloked';
        }
        field(8; "Last Date Modified "; Date)
        {
            Caption = 'Last Date Modified ';
            Editable = false;
        }
        field(9; Comment; Boolean)
        {
            Caption = 'Comment';
        }
        field(10; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(11; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
        }
        field(12; "Gen. Prod. Posting group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(13; "Vat Prod. Posting Group"; Code[10])
        {
            Caption = 'Vat Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(14; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";

        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
