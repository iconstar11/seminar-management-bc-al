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
                Codes: Record "Post Code";
            begin
                Codes.Reset();
                if Codes.Get(City) then begin
                    "Country Code " := Codes."Country/Region Code";
                    "Post Code" := Codes.Code;
                end;

            end;



        }
        field(6; "Post Code"; Code[20])
        {
            Caption = 'Post Code';



        }
        field(7; "Country Code "; Code[30])
        {
            Caption = 'Country code ';

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
            TableRelation = Resource;
        }
        field(17; "Comment "; Boolean)
        {
            Caption = 'Comment ';
        }
        field(18; "Internal/External"; Boolean)
        {
            Caption = 'Internal/External';
        }
        field(19; "Contact No. "; Code[20])
        {
            Caption = 'Contact No. ';
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

}
