table 50114 "Posted Seminar Reg.Header"
{
    Caption = 'Posted Seminar Reg.Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(3; "Seminar No."; Code[10])
        {
            Caption = 'Seminar No.';
            TableRelation = "Seminar";
        }
        field(4; "Seminar Name"; Text[50])
        {
            Caption = 'Seminar Name';
        }
        field(5; "Instructor Code"; Code[10])
        {
            Caption = 'Instructor Code';
            TableRelation = "Instructor";
        }
        field(6; "Instructor Name"; Text[50])
        {
            Caption = 'Instructor Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Instructor.Name);
        }
        field(7; "Duration"; Decimal)
        {
            Caption = 'Duration';
            DecimalPlaces = 0 : 1;
        }
        field(8; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(9; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }
        field(10; "Room Code"; Code[20])
        {
            Caption = 'Room Code';
            TableRelation = "Seminar Room";
        }
        field(11; "Room Name"; Text[30])
        {
            Caption = 'Room Name';
        }
        field(12; "Room Address"; Text[30])
        {
            Caption = 'Room Address';
        }
        field(13; "Room Address2"; Text[30])
        {
            Caption = 'Room Address2';
        }
        field(14; "Room Post Code"; Code[20])
        {
            Caption = 'Room Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(15; "Room City"; Text[30])
        {
            Caption = 'Room City';
        }
        field(16; "Room Phone No."; Text[30])
        {
            Caption = 'Room Phone No.';
        }
        field(17; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 1;
        }
        field(18; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(19; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(20; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;

            CalcFormula = exist("Seminar Comment Line" where("No." = field("No.")));
            // CalcFormula = lookup(Comment);
        }
        field(21; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(22; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(23; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(24; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(25; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(26; "Registration No. Series"; Code[10])
        {
            Caption = 'Registration No. Series';
            TableRelation = "No. Series";
        }
        field(27; "Registration No."; Code[20])
        {
            Caption = 'Registration No.';
        }
        field(28; "User ID"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = User;

            ValidateTableRelation = false;
        }
        field(29; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            tableRelation = "Source Code";
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(SK; "Room Code")
        {
            SumIndexFields = Duration;
            Clustered = false;
        }
    }
}
