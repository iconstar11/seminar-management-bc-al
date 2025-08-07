namespace seminarmanagementbcal.seminarmanagementbcal;

page 50132 "Custom Report Mapping List"
{
    ApplicationArea = All;
    Caption = 'Custom Report Mapping List';
    PageType = List;
    SourceTable = "Custom Report Mapping";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Report ID"; Rec."Report ID")
                {
                    ToolTip = 'Specifies the value of the Report ID field.', Comment = '%';
                }
                field("Report Name"; Rec."Report Name")
                {
                    ToolTip = 'Specifies the value of the Report Name field.', Comment = '%';
                }
            }
        }
    }
}
