table 50121 "Seminar Register"
{
    Caption = 'Seminar Register';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(2; "From Entry No."; Integer)
        {
            Caption = 'From Entry No.';
            TableRelation = "Seminar Ledger Entry";
        }
        field(3; "To Entry No."; Integer)
        {
            Caption = 'To Entry No.';
            TableRelation = "Seminar Ledger Entry";


        }
        field(4; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(5; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(6; "User ID"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = User;
            trigger OnLookup()
            var
                UserRec: Record User;
            begin
                if Page.RunModal(Page::"Users", UserRec) = Action::LookupOK then
                    "User ID" := UserRec."User Name";
            end;
        }
        field(7; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(SK; "Creation Date")
        {
            Clustered = false;
        }
        key("Second SK"; "Source Code", "Journal Batch Name", "Creation Date")
        {
            Clustered = false;
        }
    }
}
