table 50104 Seminar
{
    Caption = 'Seminar';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[30])
        {
            Caption = 'No.';
            trigger OnValidate()
            begin
                if Rec."No." <> xRec."No." then begin
                    SeminarSetupRec.Get();
                    NoSeriesCheck.TestManual(SeminarSetupRec."Seminar Nos.");
                    "No. Series" := '';

                end;
            end;
        }
        field(6; "Search Name "; Text[50])
        {
            Caption = 'Search Name ';

        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            trigger OnValidate()
            begin
                if ("Search Name " = (UpperCase(xRec."Search Name ")))
                or ("Search Name " = '') then begin
                    "Search Name " := UpperCase(Name);
                end;
            end;

        }
        field(3; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DecimalPlaces = 0 : 1;
        }
        field(4; "Minimum Participarts"; Integer)
        {
            Caption = 'Minimum Participarts';
        }
        field(5; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }

        field(7; Bloked; Boolean)
        {
            Caption = 'Bloked';
        }
        field(8; "Last Date Modified "; Date)
        {
            Caption = 'Last Date Modified ';
            Editable = false;
        }
        field(9; Comment; Boolean)
        {
            Caption = 'Comment';
        }
        field(10; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;

            trigger OnValidate()
            var
                JobRec: Record Job;
            begin
                if "Job No." <> '' then
                    JobRec.Get("Job No.");
                if JobRec.Blocked <> JobRec.Blocked::" " then
                    Error('The Job %1 is blocked.', JobRec."No.");
            end;

        }
        field(11; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 1;
        }
        field(12; "Gen. Prod. Posting group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting group';
            TableRelation = "Gen. Product Posting Group";


            trigger OnValidate()
            var
                GenProdPostingGrp: Record "Gen. Product Posting Group";
            begin
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then begin
                    if GenProdPostingGrp.Get("Gen. Prod. Posting Group") then begin
                        // Fallback logic if ValidateVatProdPostingGroup doesn't exist
                        if GenProdPostingGrp."Def. VAT Prod. Posting Group" <> '' then
                            Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group")
                        else
                            Error('The Gen. Product Posting Group %1 does not have a default VAT Prod. Posting Group.', "Gen. Prod. Posting Group");
                    end;
                end;
            end;
        }
        field(13; "Vat Prod. Posting Group"; Code[10])
        {
            Caption = 'Vat Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(14; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";

        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(SecondaryKey; "Search Name ")
        {
            Clustered = false;
        }

    }
    procedure AssistEdit(): Boolean
    var
        SeminarSetupRec: Record "Seminar Setup";
        SeminarCopy: Record Seminar;
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        SeminarCopy := Rec; // Work with a local copy

        // 1. Load setup record and ensure series exists
        SeminarSetupRec.Get();
        SeminarSetupRec.TestField("Seminar Nos.");

        // 2. Let the user select a series, or use the default one
        if NoSeriesMgt.SelectSeries(SeminarSetupRec."Seminar Nos.", xRec."No. Series", SeminarCopy."No. Series") then begin

            // 3. Set the series on the Seminar No.
            SeminarSetupRec.Get(); // Reload to be extra safe
            SeminarSetupRec.TestField("Seminar Nos.");

            NoSeriesMgt.SetSeries(SeminarCopy."No."); // Assign the new number

            Rec := SeminarCopy; // Update the original record with the changes
            exit(true); // Success
        end;

        exit(false); // User cancelled or no series selected
    end;

    trigger OnInsert()
    var
        SeminarSetupRec: Record "Seminar Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        // Auto-assign a Seminar No. if it's empty
        if "No." = '' then begin
            SeminarSetupRec.Get();
            SeminarSetupRec.TestField("Seminar Nos"); // Ensure setup exists
            NoSeriesMgt.InitSeries(SeminarSetupRec."Seminar Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;



    var
        SeminarSetupRec: Record "Seminar SetUp";
        NoSeriesCheck: Codeunit NoSeriesManagement;


}
