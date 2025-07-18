table 50148 "Seminar Room"
{
    Caption = 'Seminar Room';


    fields
    {
        field(1; Code; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[30])
        {
            Caption = 'Name';

        }
        field(3; Address; Text[30])
        {
            Caption = 'Address';
        }
        field(4; "Address 2"; Text[30])
        {
            Caption = 'Address 2';
        }
        field(5; City; Text[30])
        {
            Caption = 'City';
            TableRelation = "Post Code".City;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";

            begin
                PostCode.Reset();
                PostCode.SetRange(City, City);
                if PostCode.FindFirst() then begin
                    "Post Code" := PostCode.Code;
                    "Country Code " := PostCode."Country/Region Code";
                end;
            end;

        }
        field(6; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";

            trigger OnValidate()
            begin
                PostCodeRec.Reset();
                PostCodeRec.SetRange(Code, "Post Code");

                if PostCodeRec.FindFirst() then begin
                    City := PostCodeRec.City;
                    "Country Code " := PostCodeRec."Country/Region Code";
                end;
            end;




        }
        field(7; "Country Code "; Code[30])
        {
            Caption = 'Country code ';
            Editable = false;


        }
        field(8; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';

        }
        field(9; "Fax No. "; Text[30])
        {
            Caption = 'Fax No. ';
        }
        field(10; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(11; Contact; Text[50])
        {
            Caption = 'Contact';
            TableRelation = Contact;
        }
        field(12; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
        }
        field(13; "Home Page "; Text[90])
        {
            Caption = 'Home Page ';
        }
        field(14; "Maximum Participants "; Integer)
        {
            Caption = 'Maximum Participants ';
        }
        field(15; Allocation; Decimal)
        {
            Caption = 'Allocation';
            Editable = false;
        }
        field(16; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource."No." where(Type = const(Machine));
            trigger OnValidate()
            begin
                if ResourceRec.Get("Resource No.") and (Name = '') then
                    Name := ResourceRec.Name;
            end;
        }
        field(17; "Comment "; Boolean)
        {
            Caption = 'Comment ';
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = exist("Comment Line" where("Room Code" = field(Code) ))
        }
        field(18; "Internal/External"; Option)
        {
            Caption = 'Internal/External';
            OptionMembers = Internal,External;
        }
        field(19; "Contact No. "; Code[20])
        {
            Caption = 'Contact No. ';
            TableRelation = Contact;
            trigger OnValidate()
            begin
                if ContactRec.Get("Contact No. ") and (Name = '') then
                    Name := ContactRec.Name;
            end;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        PostCodeRec: Record "Post Code";
        ResourceRec: Record Resource;
        ContactRec: Record Contact;




}
