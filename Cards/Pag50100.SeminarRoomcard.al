namespace ALProject.ALProject;

page 50149 "Seminar Room card"
{
    ApplicationArea = All;
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

                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.', Comment = '%';
                }
                field(Allocation; Rec.Allocation)
                {
                    ToolTip = 'Specifies the value of the Allocation field.', Comment = '%';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field.', Comment = '%';
                }
                field("Code "; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field("Comment "; Rec."Comment ")
                {
                    ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                }
                // field(Contact; Rec.Contact)
                // {
                //     ToolTip = 'Specifies the value of the Contact field.', Comment = '%';
                // }
                field("Contact No. "; Rec."Contact No. ")
                {
                    ToolTip = 'Specifies the value of the Contact No. field.', Comment = '%';
                }
                field("Country/Region"; Rec."Country Code ")
                {
                    ToolTip = 'Specifies the value of the Country/Region field.', Comment = '%';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the value of the E-Mail field.', Comment = '%';
                }
                field("Fax No. "; Rec."Fax No. ")
                {
                    ToolTip = 'Specifies the value of the Fax No. field.', Comment = '%';
                }
                field("Home Page "; Rec."Home Page ")
                {
                    ToolTip = 'Specifies the value of the Home Page field.', Comment = '%';
                }
                field("Internal/External"; Rec."Internal/External")
                {
                    ToolTip = 'Specifies the value of the Internal/External field.', Comment = '%';
                }
                field("Maximum Participants "; Rec."Maximum Participants ")
                {
                    ToolTip = 'Specifies the value of the Maximum Participants field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ToolTip = 'Specifies the value of the Name 2 field.', Comment = '%';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.', Comment = '%';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code field.', Comment = '%';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies the value of the Resource No. field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                    Visible = false;
                }
            }
            part(Contact; "Seminar Contact")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Seminar Room Code" = field(Code);
            }
        }

    }
}
