table 50103 "Seminar SetUp"
{
    Caption = 'Seminar SetUp';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary key"; Code[10])
        {
            Caption = 'Primary key';
        }
        field(2; "Seminar Nos."; Code[10])
        {
            Caption = 'Seminar Nos.';
            TableRelation = "No. Series";
        }
        field(3; "Seminar Registration Nos."; Code[10])
        {
            Caption = 'Seminar Registration Nos.';
            TableRelation = "No. Series";
        }
        field(4; "Posted Sem. Registration Nos."; Code[10])
        {
            Caption = 'Posted Sem. Registration Nos.';
            TableRelation = "No. Series";
        }
        field(5; Seminar; Code[10])
        {
            Caption = 'Seminar';
            TableRelation = "Source Code Setup";
        }
    }
    keys
    {
        key(PK; "Primary key")
        {
            Clustered = true;
        }
    }
}
