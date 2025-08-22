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
            TableRelation = "Source Code";
        }

        field(6; "Job Journal Template"; Code[10])
        {
            Caption = 'Job Journal Template';
            TableRelation = "Job Journal Template".Name;
        }
        field(7; "Job Journal Batch"; Code[10])
        {
            Caption = 'Job Journal Batch';
            TableRelation = "Job Journal Batch".Name
                where("Journal Template Name" = field("Job Journal Template"));
        }
        field(8; "Job Source Code"; Code[10])
        {
            Caption = 'Job Source Code';
            TableRelation = "Source Code";
        }
        field(9; "Default Job Task No."; Code[20])
        {
            Caption = 'Default Job Task No.';
            TableRelation = "Job Task"."Job Task No.";
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
