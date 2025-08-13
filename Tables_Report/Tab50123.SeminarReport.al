table 50123 "Seminar Report Selections"
{
    Caption = 'Seminar Report Selections';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Usage; Option)
        {
            Caption = 'Usage';
            OptionMembers = "S.Registration";
        }
        field(2; Sequence; Code[10])
        {
            Caption = 'Sequence';
        }
        field(3; "Report ID"; Integer)
        {
            Caption = 'Report ID';

        }
        field(4; "Report Name"; Text[80])
        {
            Caption = 'Report Name';
        }
    }
    keys
    {
        key(PK; Usage, Sequence)
        {
            Clustered = true;
        }
    }
    procedure NewRecord(NewUsage: Option)
    var
        LastRec: Record "Seminar Report Selections";
        LastSequence: Integer;
    begin
        // Set default Usage
        "Usage" := NewUsage;

        // Filter to same Usage
        LastRec.SetRange("Usage", NewUsage);

        if LastRec.FindLast() then begin
            Evaluate(LastSequence, LastRec."Sequence");
            LastSequence += 1;
            "Sequence" := Format(LastSequence);
        end else begin
            "Sequence" := '1';
        end;
    end;
}
