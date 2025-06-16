namespace ALProject.ALProject;

using Microsoft.CRM.Contact;

page 50102 "Seminar Contact"
{
    ApplicationArea = All;
    Caption = 'Participants';
    PageType = ListPart;
    SourceTable = Participants;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Partipant Contact"; Rec."Participant Contact")
                {
                    ToolTip = 'Contact no';

                }

                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name.';
                }

                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the city where the contact is located.';
                }


                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the contact''s phone number.';
                }

            }
        }
    }
}
