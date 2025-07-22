table 50108 "Seminar Comment Line"
{
    Caption = 'Seminar Comment Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = ,hi;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(5; Code; Code[10])
        {
            Caption = 'Code ';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
    }
    keys
    {
        key(PK; "Document Type", "No.", "Line No.")
        {
            Clustered = true;
        }
    }
    procedure SetUpNewLine()
    begin
        if Date = 0D then
            Date := WorkDate();
    end;
}
