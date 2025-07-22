table 50106 "Seminar Charge"
{
    Caption = 'Seminar Charge';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Seminar Registration No"; Code[20])
        {
            Caption = 'Seminar Registration No';
            TableRelation = "Seminar Registration Header";
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            trigger OnValidate()
            var
                JobRec: Record Job;
            begin
                JobRec.Reset();
                if JobRec.Get() then
                    if (JobRec.Blocked = JobRec.Blocked::All) or (JobRec.Blocked = JobRec.Blocked::Posting)
                    then
                        Error('The Job is bloked for posting or in all accounts')
                    else if JobRec.Status in [JobRec.Status::Completed, JobRec.Status::Planning, JobRec.Status::Quote]
                    then
                        Error('The Job is in Completed, Planning or Quote status');
            end;
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = ,Resource,"G/L Account";
            trigger OnValidate()
            begin
                Description := ' ';
            end;
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(Resource)) Resource
            else if (Type = const("G/L Account")) "G/L Account";

        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(8; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(9; "Total Price"; Decimal)
        {
            Caption = 'Total Price';
            Editable = false;
            AutoFormatType = 1;

        }
        field(10; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
        }
        field(11; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(12; "Unit Of Measure Code"; Code[10])
        {
            Caption = 'Unit Of Measure Code';
            TableRelation = if (Type = const(Resource)) "Resource Unit of Measure".Code where("Resource No." = field("No."))
            else
            "Unit of Measure";
        }
        field(13; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(14; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(15; "Qty. Per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. Per Unit of Measure';
        }
        field(16; Registred; Boolean)
        {
            Caption = 'Registred';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Seminar Registration No", "Line No.")
        {
            Clustered = true;
        }
        key(SecondaryKey; "Job No.")
        {
            Clustered = false;
        }
    }

    var
        SeminarRegHeaderRec: Record "Seminar Registration Header";

    trigger OnInsert()
    begin
        if SeminarRegHeaderRec.Get() then
            "Job No." := SeminarRegHeaderRec."Job No.";

    end;

    trigger OnDelete()
    begin
        TestField(Registred, false);
    end;


}
