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
                if getName.Get("Resource No. ") then begin
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
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
