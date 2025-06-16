table 50105 "Seminar Registration Header"
{
    Caption = 'Seminar Registration Header';
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
        field(3; "Seminar Code"; Code[20])
        {
            Caption = 'Seminar Code';
            TableRelation = Seminar;
        }
        field(4; "Seminar Name"; Text[50])
        {
            Caption = 'Seminar Name';
        }
        field(5; "Instructor Code"; Code[10])
        {
            Caption = 'Instructor Code';
            TableRelation = Instructor;
        }
        field(6; "Instructor Name"; Text[50])
        {
            Caption = 'Instructor Name';
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = ,Planning,Registartion,Closed,Canceled;
        }
        field(8; "Duration"; Decimal)
        {
            Caption = 'Duration';
        }
        field(9; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(10; "Room Code"; Code[20])
        {
            Caption = 'Room Code';
        }
        field(11; "Room Name"; Text[30])
        {
            Caption = 'Room Name';
            TableRelation = "Seminar Room";
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
        }
        field(15; "Room City"; Text[30])
        {
            Caption = 'Room City';
            TableRelation = "Post Code";
        }
        field(16; "Room Phone No."; Text[30])
        {
            Caption = 'Room Phone No.';
        }
        field(17; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
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
            Editable = false;
        }
        field(26; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(27; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
    }
    keys
    {
        key(PK; "No.", "Room Code")
        {
            Clustered = true;
        }
    }
}
