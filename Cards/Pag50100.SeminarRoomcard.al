namespace ALProject.ALProject;
using Microsoft.Foundation.Comment;
using System.EMail;

page 50149 "Seminar Room card"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Seminar Room card';
    PageType = Card;
    SourceTable = "Seminar Room";
    Editable = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code "; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }

                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field.', Comment = '%';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code field.', Comment = '%';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.', Comment = '%';
                }
                field("Country/Region"; Rec."Country Code ")
                {
                    ToolTip = 'Specifies the value of the Country/Region field.', Comment = '%';
                }
                field("Internal/External"; Rec."Internal/External")
                {
                    ToolTip = 'Specifies the value of the Internal/External field.', Comment = '%';
                }
                field("Maximum Participants "; Rec."Maximum Participants ")
                {
                    ToolTip = 'Specifies the value of the Maximum Participants field.', Comment = '%';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies the value of the Resource No. field.', Comment = '%';
                }
                field("Contact No. "; Rec."Contact No. ")
                {
                    ToolTip = 'Specifies the value of the Contact No. field.', Comment = '%';
                }

                field(Allocation; Rec.Allocation)
                {
                    ToolTip = 'Specifies the value of the Allocation field.', Comment = '%';
                }
            }
            group(Communication)
            {
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.', Comment = '%';
                }
                field("Fax No. "; Rec."Fax No. ")
                {
                    ToolTip = 'Specifies the value of the Fax No. field.', Comment = '%';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the value of the E-Mail field.', Comment = '%';
                }
                field("Home Page "; Rec."Home Page ")
                {
                    ToolTip = 'Specifies the value of the Home Page field.', Comment = '%';

                }

            }
            part(Contact; "Seminar Contact")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Seminar Room Code" = field(Code);
            }
        }

    }
    actions
    {
        area(Navigation)
        {
            Description = 'Options';
            ToolTip = 'Options';

            action(Roomlist)
            {
                Caption = 'Seminar Room List';
                Image = List;
                Promoted = true;
                ShortcutKey = 'F5';
                RunObject = page "Seminar Room List";

            }
            action("Extended Text")
            {
                Caption = 'Extended Texts';
                Promoted = true;
                RunObject = page "Comment Sheet";

            }
        }
        area(Processing)
        {
            action(SendEmail)
            {
                Caption = 'Send Email';
                ApplicationArea = All;
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    Mail: Codeunit "Mail Management";
                begin
                    // if Rec."E-Mail" <> '' then
                    //     Mail.OpenNewMessage(Rec."E-Mail");
                end;
            }


        }
    }

}
