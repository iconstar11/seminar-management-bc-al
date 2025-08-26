table 50102 Instructor
{
    Caption = 'Instructor';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(3; "Internal/External"; Option)
        {
            Caption = 'Internal/External';
            OptionMembers = internal,external;
        }
        field(4; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;

            trigger OnValidate()
            var
                Res: Record Resource;
            begin
                if Res.Get("Resource No.") then begin
                    if Name = '' then
                        Name := Res.Name;

                    // Copy posting setup fields
                    // "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                    // "VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
                    // "Base Unit of Measure" := Res."Base Unit of Measure";

                    // Optional warning if missing
                    if Res."Gen. Prod. Posting Group" = '' then
                        Message('Warning: Resource %1 has no Gen. Prod. Posting Group. Posting will fail until this is set up.', Res."No.");

                    if Res."Base Unit of Measure" = '' then
                        Message('Warning: Resource %1 has no Base Unit of Measure. Posting will fail until this is set up.', Res."No.");
                end
                // else begin
                //     Clear("Gen. Prod. Posting Group");
                //     Clear("VAT Prod. Posting Group");
                //     Clear("Base Unit of Measure");
                // end;
            end;
        }
        field(5; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;

            trigger OnValidate()
            var
                getContact: Record Contact;
            begin
                getContact.Reset();
                if getContact.Get("Contact No.") then
                    Name := getContact.Name;
            end;
        }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        // field(8; "Gen. Prod. Posting Group"; Code[20])
        // {
        //     Caption = 'Gen. Prod. Posting Group';
        //     TableRelation = "Gen. Product Posting Group";
        // }
        // field(9; "VAT Prod. Posting Group"; Code[20])
        // {
        //     Caption = 'VAT Prod. Posting Group';
        //     TableRelation = "VAT Product Posting Group";
        // }
        // field(10; "Base Unit of Measure"; Code[10])
        // {
        //     Caption = 'Base Unit of Measure';
        //     TableRelation = Resource."Base Unit of Measure";
        // }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::Instructor, Code, FieldNumber, ShortcutDimCode);
    end;

    trigger OnInsert()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.UpdateDefaultDim(Database::Instructor, Code, "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;

    trigger OnDelete()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.DeleteDefaultDim(Database::Instructor, Code);
    end;
}
