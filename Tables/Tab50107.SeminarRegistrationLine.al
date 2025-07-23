table 50107 "Seminar Registration Line"
{
    Caption = 'Seminar Registration Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Seminar Registration Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if "Bill-to Customer No." <> xRec."Bill-to Customer No." then
                    if Registered then
                        Error('Cannot change customer on a registered line.');
            end;
        }
        field(4; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;


            trigger OnLookup()
            var
                Contact: Record Contact;
            begin
                if "Bill-to Customer No." = '' then
                    Error('Please select a Bill-to Customer before choosing a contact.');

                // Filter all contacts that belong to the selected customer as Company
                Contact.Reset();
                Contact.SetRange("Company No.", "Bill-to Customer No.");

                if Page.RunModal(Page::"Contact List", Contact) = Action::LookupOK then begin
                    "Participant Contact No." := Contact."No.";
                    "Participant Name" := Contact.Name;
                end;

                CalcFields("Participant Name");
            end;


        }
        field(5; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Contact.Name where("No." = field("Participant Contact No.")));

        }
        field(6; "Register Date"; Date)
        {
            Caption = 'Register Date';
            Editable = false;
        }
        field(7; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            InitValue = true;
        }
        field(8; Participated; Boolean)
        {
            Caption = 'Participated';
        }
        field(9; "Confirmation Date"; Date)
        {
            Caption = 'Confirmation Date';
            Editable = false;
        }
        field(10; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 2;

            trigger OnValidate()
            begin
                Validate("Line Discount %");
            end;
        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                GLSetup.Get();
                "Line Discount Amount" := Round("Seminar Price" * "Line Discount %" / 100, GLSetup."Amount Rounding Precision");
                UpdateAmount();
            end;
        }
        field(12; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                if "Seminar Price" <> 0 then
                    "Line Discount %" := Round("Line Discount Amount" / "Seminar Price" * 100, 0.00001)
                else
                    "Line Discount %" := 0;

                UpdateAmount();
            end;
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                TestField("Bill-to Customer No.");
                TestField("Seminar Price");

                GLSetup.Get();
                Amount := Round(Amount, GLSetup."Amount Rounding Precision");

                "Line Discount Amount" := "Seminar Price" - Amount;

                if "Seminar Price" <> 0 then
                    "Line Discount %" := Round("Line Discount Amount" / "Seminar Price" * 100, 0.00001)
                else
                    "Line Discount %" := 0;
            end;
        }
        field(14; Registered; Boolean)
        {
            Caption = 'Registered';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        SemHeader: Record "Seminar Registration Header";
        GLSetup: Record "General Ledger Setup";


    procedure GetSemRegHeader()
    begin
        if not SemHeader.Get("Document No.") then
            Error('Seminar Registration Header not found for Document No. %1', "Document No.");
    end;

    local procedure CalcAmount()
    begin
        Amount := Round("Seminar Price" * ((100 - "Line Discount %") / 100), 0.01);
    end;

    procedure UpdateAmount()
    begin
        GLSetup.Get();
        Amount := Round("Seminar Price" - "Line Discount Amount", GLSetup."Amount Rounding Precision");
    end;


    trigger OnInsert()
    begin
        GetSemRegHeader();

        "Register Date" := WorkDate;
        "Seminar Price" := SemHeader."Seminar Price";
        CalcAmount();
    end;

    trigger OnDelete()
    begin
        TestField(Registered, false);
    end;


}
