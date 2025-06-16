table 50101 Participants
{
    Caption = 'Participants';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Participant contact"; Code[10])
        {
            Caption = 'Participant contact';
            TableRelation = Contact;

            trigger OnValidate()
            var
                Contact: Record Contact;
            begin
                Contact.Reset();
                if Contact.Get("Participant contact") then begin
                    Name := Contact.Name;
                    "Phone No." := Contact."Phone No.";
                    City := Contact.City;

                end;
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = ' Name';
            Editable = false;
        }
        field(3; City; Text[30])
        {
            Caption = 'City';
            Editable = false;
        }
        field(4; "Phone No."; Code[30])
        {
            Caption = 'Phone Number';
            Editable = false;
        }

        field(6; "Seminar Room Code"; Code[10])
        {
            Caption = 'Seminar Room Code';
        }
    }
    keys
    {
        key(PK; "Participant contact", "Seminar Room Code")
        {
            Clustered = true;
        }
    }
}
