table 50112 "Custom Report Mapping"
{
    Caption = 'Custom Report Mapping';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Report ID"; Integer)
        {
            Caption = 'Report ID';
        }
        field(2; "Report Name"; Text[80])
        {
            Caption = 'Report Name';
        }
    }
    keys
    {
        key(PK; "Report ID")
        {
            Clustered = true;
        }
    }
}
