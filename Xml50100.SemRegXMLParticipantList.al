namespace seminarmanagementbcal.seminarmanagementbcal;
using Microsoft.CRM.Contact;
using Microsoft.Projects.Resources.Resource;

xmlport 50100 "Sem. Reg.-XML Participant List"
{
    Caption = 'Seminar Registration Participant List';
    Encoding = UTF8;
    Direction = Export; // this XMLport is for exporting
    Format = Xml; // ensures proper XML format

    schema
    {
        textelement(Root)
        {
            tableelement(SemRegHeader; "Seminar Registration Header")
            {
                XmlName = 'SeminarRegistration';

                fieldelement(DocumentNo; SemRegHeader."No.") { }
                fieldelement(SeminarCode; SemRegHeader."Seminar Code") { }
                fieldelement(SeminarName; SemRegHeader."Seminar Name") { }

                // Instructor is already stored in the header
                fieldelement(InstructorCode; SemRegHeader."Instructor Code") { }
                fieldelement(InstructorName; SemRegHeader."Instructor Name") { }

                tableelement(SemRegLine; "Seminar Registration Line")
                {
                    XmlName = 'Participant';

                    fieldelement(LineNo; SemRegLine."Line No.") { }
                    fieldelement(RegisterDate; SemRegLine."Register Date") { }
                    fieldelement(ConfirmedDate; SemRegLine."Confirmation Date") { }

                    // Instead of fieldelement, use textelement to fill dynamically
                    textelement(ParticipantName) { }

                    trigger OnAfterGetRecord()
                    var
                        Contact: Record Contact;
                    begin
                        ParticipantName := SemRegLine."Participant Name"; // fallback
                        if SemRegLine."Participant Contact No." <> '' then
                            if Contact.Get(SemRegLine."Participant Contact No.") then
                                ParticipantName := Contact.Name;
                    end;
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
