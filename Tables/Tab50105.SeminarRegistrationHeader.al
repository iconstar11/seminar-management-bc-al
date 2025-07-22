table 50105 "Seminar Registration Header"
{
    Caption = 'Seminar Registration Header';
    DataClassification = ToBeClassified;
    LookupPageId = 50108;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate()
            var
                SemSetup: Record "Seminar Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if "No." <> xRec."No." then begin
                    SemSetup.Get();
                    NoSeriesMgt.TestManual(SemSetup."Seminar Registration Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if "Starting Date" <> xRec."Starting Date" then begin
                    if Status <> Status::Planning then
                        Status := Status::Planning
                end;
            end;
        }
        field(3; "Seminar Code"; Code[20])
        {
            Caption = 'Seminar Code';
            TableRelation = Seminar;

            trigger OnValidate()
            var
                SeminarRec: Record Seminar;
                SemLine: Record "Seminar Registration Line";
            begin
                if "Seminar Code" <> xRec."Seminar Code" then begin

                    if SemLine.Get("No.") then
                        Error('Cannot change Seminar Code when registration lines exist.'); // 

                    if SeminarRec.Get("Seminar Code") then begin
                        SeminarRec.TestField(Bloked, false);
                        SeminarRec.TestField("Gen. Prod. Posting Group");
                        SeminarRec.TestField("VAT Prod. Posting Group");

                        "Seminar Name" := SeminarRec.Name;
                        Duration := SeminarRec."Seminar Duration";
                        "Seminar Price" := SeminarRec."Seminar Price";
                        "Gen. Prod. Posting Group" := SeminarRec."Gen. Prod. Posting Group";
                        "VAT Prod. Posting Group" := SeminarRec."VAT Prod. Posting Group";
                        "Minimum Participants" := SeminarRec."Minimum Participarts";
                        "Maximum Participants" := SeminarRec."Maximum Participants";

                        Validate("Job No.", SeminarRec."Job No."); // triggers Job validation logic
                    end;
                end;
            end;
        }
        field(4; "Seminar Name"; Text[50])
        {
            Caption = 'Seminar Name';
        }
        field(5; "Instructor Code"; Code[10])
        {
            Caption = 'Instructor Code';
            TableRelation = Instructor;

            trigger OnValidate()
            var
                Inst: Record Instructor;
            begin
                if Inst.Get("Instructor Code") then
                    "Instructor Name" := Inst.Name;
            end;
        }
        field(6; "Instructor Name"; Text[50])
        {
            Caption = 'Instructor Name';
            Editable = false; // This field is not editable
            FieldClass = FlowField;
            CalcFormula = lookup(Instructor.Name where(Code = field("Instructor Code")));
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Planning,Registration,Closed,Canceled;
        }
        field(8; "Duration"; Decimal)
        {
            Caption = 'Duration';
            DecimalPlaces = 0 : 1;
        }
        field(9; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(28; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }
        field(10; "Room Code"; Code[20])
        {
            Caption = 'Room Code';

            trigger OnValidate()
            var
                Room: Record "Seminar Room";
            begin
                if "Room Code" = '' then begin
                    "Room Name" := '';
                    "Room Address" := '';
                    "Room Address2" := '';
                    "Room Post Code" := '';
                    "Room City" := '';
                    "Room Phone No." := '';
                end else begin
                    if Room.Get("Room Code") then begin
                        "Room Name" := Room.Name;
                        "Room Address" := Room.Address;
                        "Room Address2" := Room."Address 2";
                        "Room Post Code" := Room."Post Code";
                        "Room City" := Room.City;
                        "Room Phone No." := Room."Phone No.";

                        if Room."Maximum Participants " < "Maximum Participants" then
                            if Confirm('The room capacity (%1) is less than current Maximum Participants (%2).\Do you want to reduce the Maximum Participants to fit the room?', false, Room."Maximum Participants ", "Maximum Participants") then
                                "Maximum Participants" := Room."Maximum Participants ";
                    end;
                end;
            end;
        }
        field(11; "Room Name"; Text[30])
        {
            Caption = 'Room Name';
            TableRelation = "Seminar Room";
        }
        field(12; "Room Address"; Text[30])
        {
            Caption = 'Room Address';
        }
        field(13; "Room Address2"; Text[30])
        {
            Caption = 'Room Address2';
        }
        field(14; "Room Post Code"; Code[20])
        {
            Caption = 'Room Post Code';

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidatePostCode("Room Post Code", "Room City");
            end;

            trigger OnLookup()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.LookUpPostCode("Room Post Code", "Room City");
            end;
        }
        field(15; "Room City"; Text[30])
        {
            Caption = 'Room City';
            TableRelation = "Post Code";
            ValidateTableRelation = false; // This field does not validate against the Post Code table
        }
        field(16; "Room Phone No."; Text[30])
        {
            Caption = 'Room Phone No.';
        }
        field(17; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
        }
        field(18; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(19; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

        }
        field(20; Comment; Boolean)
        {
            Caption = 'Comment';
        }
        field(21; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(22; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(23; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(24; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(25; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            Editable = false;
        }
        field(26; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(27; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(RoomKey; "Room Code")
        {
            SumIndexFields = Duration;
        }
    }

    local procedure AssistEdit()
    begin

    end;

    local procedure InitRecord()
    begin
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate;
        "Document Date" := WorkDate;
        if not SemSetUpRec.Get() then
            Error('Failed to load seminar setup record');

        NoSeriesMgt.SetDefaultSeries("Posting No. Series", SemSetUpRec."Posted Sem. Registration Nos.");


    end;

    procedure AssistEdit(OldSemRegHeader: Record "Seminar Registration Header"): Boolean
    var
        NewNo: Code[20];
        IsHandled: Boolean;
    begin
        SemSetUpRec.Get();
        if SemSetUpRec."Seminar Nos." = '' then
            Error('Text0001'); // "You must define a Seminar Nos. series in Seminar Setup."

        IsHandled := NoSeriesMgt.SelectSeries(NewNo, SemSetUpRec."Seminar Nos.", OldSemRegHeader."No.");
        if not IsHandled then
            exit(false);

        NoSeriesMgt.SetSeries(NewNo);
        "No." := NewNo;
        exit(true);
    end;

    var
        SemSetUpRec: Record "Seminar SetUp";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SemLine: Record "Seminar Registration Line";
        SemCharge: Record "Seminar Charge";
        SemComment: Record "Seminar Comment Line";

    trigger OnInsert()
    begin
        if "No." = '' then begin
            if not SemSetUpRec.Get() then
                Error('Failed to get Seminar Setup record');
            SemSetUpRec.TestField(SemSetUpRec."Seminar Registration Nos.");
            // NoSeriesMgt.InitSeries(SemSetUpRec."Seminar Registration Nos.", "No. Series", 0D, "No. Series");

        end;
        InitRecord();
    end;

    trigger OnDelete()
    begin
        if Status <> Status::Canceled then
            Error('Status is not Canceled');
        if SemLine.Get() then
            Error('Cannot delete. Registered seminar lines exist.');
        if SemCharge.Get() then
            Error('Cannot delete. Seminar charges exist.');
        if SemComment.FindSet() then
            repeat
                if SemComment."No." = "No." then
                    SemComment.Delete();
            until SemComment.Next() = 0;


    end;

    trigger OnRename()
    begin
        Error('This record cannot be renamed');
    end;


}
