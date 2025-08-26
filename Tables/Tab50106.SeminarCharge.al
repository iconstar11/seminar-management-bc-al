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
                        Error('The Job is bloked for posting or in all accounts');
                if JobRec.Status <> JobRec.Status::Open
                    then
                    Error('The Job is in Completed, Planning or Quote status');
            end;
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = Resource,"G/L Account";

        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(Resource)) Resource
            else if (Type = const("G/L Account")) "G/L Account";

            trigger OnValidate()
            var
                ResourceRec: Record Resource;
                GlAccountRec: Record "G/L Account";
            begin
                case Type of
                    Type::Resource:
                        begin
                            if ResourceRec.Get() then begin
                                if ResourceRec.Blocked = true then
                                    Error('The Resource is blocked for use');
                                ResourceRec.TestField("Gen. Prod. Posting Group");
                                "Gen. Prod. Posting Group" := ResourceRec."Gen. Prod. Posting Group";
                                Description := ResourceRec.Name;
                                "VAT Prod. Posting Group" := ResourceRec."VAT Prod. Posting Group";
                                "Unit Of Measure Code" := ResourceRec."Unit of Measure Filter";
                                "Unit Price" := ResourceRec."Unit Price";
                            end;
                        end;
                    Type::"G/L Account":
                        begin
                            if GlAccountRec.Get() then begin
                                CheckGLAcc(GlAccountRec);
                                GlAccountRec.TestField("Direct Posting", true);
                                Description := GlAccountRec.Name;
                                "Gen. Prod. Posting Group" := GlAccountRec."Gen. Prod. Posting Group";
                                "VAT Prod. Posting Group" := GlAccountRec."VAT Prod. Posting Group";
                            end;
                        end;
                end;

            end;

        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                CalcTotal();
            end;
        }
        field(8; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            AutoFormatType = 2;
            MinValue = 0;

            trigger OnValidate()
            begin
                CalcTotal();
            end;
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

            trigger OnValidate()
            begin
                case Type of
                    Type::Resource:

                        begin
                            ResourceRec.Get();
                            if "Unit Of Measure Code" = '' then
                                "Unit Of Measure Code" := ResourceRec."Base Unit of Measure";
                            "Qty. Per Unit of Measure" := ResourceRec."Qty. on Assembly Order";
                            "Unit Price" := ResourceRec."Unit Price";
                        end;


                    Type::"G/L Account":
                        begin
                            "Qty. Per Unit of Measure" := 1;


                        end;
                end;
            end;
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
        field(15; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
        }
        field(16; Registered; Boolean)
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
        ResourceRec: Record Resource;
        GlAccountRec: Record "G/L Account";

    trigger OnInsert()
    begin
        if SeminarRegHeaderRec.Get() then
            "Job No." := SeminarRegHeaderRec."Job No.";

    end;

    trigger OnDelete()
    begin
        TestField(Registered, false);
    end;

    local procedure CheckGLAcc(GLAcc: Record "G/L Account")
    begin
        if GLAcc."Account Type" <> GLAcc."Account Type"::Posting then
            Error('The G/L Account must be of type "Posting".');
    end;

    local procedure CalcTotal()
    begin
        "Total Price" := Round("Unit Price" * Quantity, 0.01);
    end;



}
