page 50131 "Seminar Report Selection List"
{
    ApplicationArea = All;
    Caption = 'Seminar Report Selection List';
    PageType = List;
    SourceTable = "Seminar Report Selections";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Header)
            {
                field(Usage; ReportUsage)
                {
                    ApplicationArea = All;
                    Caption = 'Usage';
                    ToolTip = 'Select the report usage.';

                    trigger OnValidate()
                    begin
                        SetUsageFilter();
                        CurrPage.Update();
                    end;
                }
            }

            repeater(General)
            {
                field(Sequence; Rec.Sequence)
                {
                    ToolTip = 'Specifies the value of the Sequence field.';
                }
                field("Report ID"; Rec."Report ID")
                {
                    ToolTip = 'Specifies the value of the Report ID field.';

                    trigger OnValidate()
                    var
                        ReportObject: Record "Custom Report Mapping";
                    begin
                        if ReportObject.Get(Rec."Report ID") then
                            Rec."Report Name" := ReportObject."Report Name"
                        else
                            Rec."Report Name" := '';
                    end;
                }
                field("Report Name"; Rec."Report Name")
                {
                    ToolTip = 'Specifies the value of the Report Name field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CustomReport: Record "Custom Report Mapping";
                    begin
                        if Page.RunModal(Page::"Custom Report Mapping List", CustomReport) = Action::LookupOK then begin
                            Rec."Report ID" := CustomReport."Report ID";
                            Rec."Report Name" := CustomReport."Report Name";
                            exit(true);
                        end;
                        exit(false);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(NewRecord)
            {
                ApplicationArea = All;
                Caption = 'New Record';

                trigger OnAction()
                var
                    SeminarSel: Record "Seminar Report Selections";
                begin
                    SeminarSel.Init();
                    SeminarSel.NewRecord(ReportUsage);
                    SeminarSel.Insert(true);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetUsageFilter();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.NewRecord(ReportUsage);
    end;

    procedure SetUsageFilter()
    var
        FilterRec: Record "Seminar Report Selections";
    begin
        if ReportUsage = ReportUsage::Registration then begin
            FilterRec.SetRange(Usage, FilterRec.Usage::"S.Registration");

        end;
    end;

    var
        ReportUsage: Option Registration;
}
