table 50110 "Seminar Ledger Entry"
{
    Caption = 'Seminar Ledger Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = Seminar;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(5; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionMembers = Registration,Cancellation;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(9; "Charge Type"; Option)
        {
            Caption = 'Charge Type';
            OptionMembers = Instructor,Room,Participant,Charge;
            InitValue = Participant;
        }
        field(10; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = Resource,"G/L Account";
            InitValue = Resource;
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(12; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            AutoFormatType = 2;
        }
        field(13; "Total Price"; Decimal)
        {
            Caption = 'Total Price';
            AutoFormatType = 1;
        }
        field(14; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;
        }
        field(15; "Participant Name"; Text[50])
        {
            Caption = 'Participant Name';
        }
        field(16; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            InitValue = true;
        }
        field(17; "Room Code"; Code[10])
        {
            Caption = 'Room Code';
            TableRelation = "Seminar Room";
        }
        field(18; "Instructor Code"; Code[10])
        {
            Caption = 'Instructor Code';
            TableRelation = Instructor;
        }
        field(19; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(20; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
        }
        field(21; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(22; "Job Ledger Entry No."; Integer)
        {
            Caption = 'Job Ledger Entry No';
            TableRelation = "Job Ledger Entry";
        }
        field(23; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            FieldClass = FlowField;
            CalcFormula = lookup("Job Ledger Entry"."Line Amount (LCY)"
            where("Entry No." = field("Job Ledger Entry No.")));
            AutoFormatType = 1;
            Editable = false;
        }
        field(24; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionMembers = ,Seminar;
        }
        field(25; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(Seminar)) Seminar;
        }
        field(26; "Journal Batch Name"; Code[20])
        {
            Caption = 'Journal Batch Name';
        }
        field(27; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(28; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(29; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

        }
        field(30; "User ID"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = User;

            trigger OnLookup()
            var
                UserRec: Record User;
                UserPage: Page "User Card";
            begin
                if Page.RunModal(Page::"Users", UserRec) = Action::LookupOK then
                    "User ID" := UserRec."User Name";
            end;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key("First SK"; "Seminar No.", "Posting Date")
        {
            Clustered = false;
        }
        key("Second SK"; "Bill-to Customer No.", "Seminar Registration No.", "Charge Type", "Participant Contact No.")
        {
            Clustered = false;
        }
    }
}
