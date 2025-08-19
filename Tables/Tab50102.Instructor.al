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
        field(4; "Resource No. "; Code[20])
        {
            Caption = 'Resource No. ';
            TableRelation = Resource;

            trigger OnValidate()

            var
                getName: Record Resource;
            begin
                getName.Reset();
                if getName.Get("Resource No. ") and (Name = '') then begin
                    Name := getName.Name;

                end;
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
                if getContact.Get("Contact No.") then begin
                    Name := getContact.Name
                end
            end;
        }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code
        where("Global Dimension No." = const(1));
            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }

        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code
        where("Global Dimension No." = const(2));
            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }

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
        DimMgt.UpdateDefaultDim(Database::"Seminar Room", Code, "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;


    trigger OnDelete()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.DeleteDefaultDim(Database::"Seminar Room", Code);
    end;





}
