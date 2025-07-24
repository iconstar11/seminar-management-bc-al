table 50109 "Seminar Journal Line"
{
    Caption = 'Seminar Journal Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = Seminar;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(6; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionMembers = Registration,Cancellation;
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(9; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(10; "Charge Type"; Option)
        {
            Caption = 'Charge Type';
            OptionMembers = Instructor,Room,Participant,Charge;
        }
        field(11; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = Resource,"G/L Account";
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(13; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            AutoFormatType = 2;
        }
        field(14; "Total Price"; Decimal)
        {
            Caption = 'Total Price';
            AutoFormatType = 1;
        }
        field(15; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;
        }
        field(16; "Participant Name"; Text[50])
        {
            Caption = 'Participant Name';
        }
        field(17; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            InitValue = true;
        }
        field(18; "Room Code"; Code[10])
        {
            Caption = 'Room Code';
            TableRelation = "Seminar Room";
        }
        field(19; "Instructor Code"; Code[10])
        {
            Caption = 'Instructor Code';
        }
        field(20; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(21; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
        }
        field(22; "Job No."; Code[20])
        {
            Caption = 'Job No.';
        }
        field(23; "Job Ledger Entry No."; Integer)
        {
            Caption = 'Job Ledger Entry No.';
        }
        field(24; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionMembers = ,Seminar;
        }
        field(25; "Sorce No."; Code[20])
        {
            Caption = 'Sorce No.';
        }
        field(26; "Journal batch No."; Code[10])
        {
            Caption = 'Journal batch No.';
        }
        field(27; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
        }
        field(28; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
        }
        field(29; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
        }
    }
    keys
    {
        key(PK; "Journal Template Name", "Line No.", "Journal batch No.")
        {
            Clustered = true;
        }
    }

    local procedure EmptyLine(): Boolean
    begin
        exit("Seminar No." = '')
    end;
}
