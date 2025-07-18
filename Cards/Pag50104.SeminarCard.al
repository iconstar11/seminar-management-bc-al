namespace ALProject.ALProject;
using Microsoft.Foundation.ExtendedText;

page 50104 "Seminar Card"
{
    ApplicationArea = All;
    Caption = 'Seminar Card';
    PageType = Card;
    SourceTable = Seminar;
    Editable = true;

    layout
    {
        area(Content)
        {

            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if Rec.AssistEdit() then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Search Name "; Rec."Search Name ")
                {
                    ToolTip = 'Specifies the value of the Search Name field.', Comment = '%';
                }
                field("Seminar Duration"; Rec."Seminar Duration")
                {
                    ToolTip = 'Specifies the value of the Seminar Duration field.', Comment = '%';
                }
                field("Minimum Participarts"; Rec."Minimum Participarts")
                {
                    ToolTip = 'Specifies the value of the Minimum Participarts field.', Comment = '%';
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ToolTip = 'Specifies the value of the Maximum Participants field.', Comment = '%';
                }

                field(Bloked; Rec.Bloked)
                {
                    ToolTip = 'Specifies the value of the Bloked field.', Comment = '%';
                }
                field("Last Date Modified "; Rec."Last Date Modified ")
                {
                    ToolTip = 'Specifies the value of the Last Date Modified field.', Comment = '%';
                }

            }
            group(Invoicing)
            {
                field("Seminar Price"; Rec."Seminar Price")
                {

                }
                field("Gen. Prod. Posting group"; Rec."Gen. Prod. Posting group")
                {

                }
                field("Vat Prod. Posting Group"; Rec."Vat Prod. Posting Group")
                {

                }
                field("Job No."; Rec."Job No.")
                {

                }


            }
        }

    }



    actions
    {
        area(Navigation)
        {
            group(Comment)
            {
                Caption = 'Comment';
                Image = Comment;

                action(SeminarList)
                {
                    Caption = 'Seminar List';
                    ShortcutKey = 'F5';
                    RunObject = Page 50105; // Seminar List page
                    Image = List;
                }

                action(OpenComments)
                {
                    Caption = 'Comments';
                    RunObject = Page 124; // Comment Sheet
                    RunPageLink = "No." = FIELD("No.");
                }

                action(OpenExtendedTexts)
                {
                    Caption = 'Extended Texts';
                    RunObject = Page "Extended Text";
                    RunPageLink = "No." = FIELD("No.");
                }

            }
        }
        area(Processing)
        {
            action(CloseSeminar)
            {
                Caption = 'Close Seminar';
                Image = Stop;
                trigger OnAction()
                var
                    SeminarRec: Record "Seminar Registration Header";

                begin
                    SeminarRec.Get(Rec."No.");
                    SeminarRec.Status := SeminarRec.Status::Closed;
                    SeminarRec.Modify();
                    Message('Seminar %1 registration has been closed', SeminarRec."Seminar Name");

                end;


            }
            action(CheckSeminarState)
            {
                trigger OnAction()
                var
                    MaxCount: Integer;
                    MinCount: Integer;

                begin
                    MaxCount := Rec."Maximum Participants";
                    MinCount := Rec."Minimum Participarts";

                    if MaxCount <= MinCount then
                        Message('Max partipants cant be less to minparticipants');
                end;

            }
            action(OpenCommentsFromField)
            {
                ApplicationArea = All;
                Image = EditLines;
                Caption = 'Comments';
                trigger OnAction()
                begin
                    Page.Run(124, Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Clear filter on "No." to ensure full record is shown
        CurrPage.SetSelectionFilter(Rec);
        Rec.SetRange("No.");
    end;
}
