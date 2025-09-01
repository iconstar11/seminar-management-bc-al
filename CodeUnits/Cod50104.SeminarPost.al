codeunit 50104 "Seminar-Post"
{
    TableNo = "Seminar Registration Header";

    trigger OnRun()
    begin
        ClearAll();

        // Set SemRegHeader to the current record
        SemRegHeader := Rec;

        // === Step 14B: Validate header fields ===
        SemRegHeader.TestField("Posting Date");
        SemRegHeader.TestField("Document Date");
        SemRegHeader.TestField("Starting Date");
        SemRegHeader.TestField("Seminar Code");
        SemRegHeader.TestField(Duration);
        SemRegHeader.TestField("Instructor Code");
        SemRegHeader.TestField("Room Code");
        SemRegHeader.TestField("Job No.");

        if SemRegHeader.Status <> SemRegHeader.Status::Closed then
            Error('Seminar %1 must be Closed before posting.', SemRegHeader."No.");

        // === Step 14C: Validate linked Room and Instructor ===
        if not SemRoom.Get(SemRegHeader."Room Code") then
            Error('Room %1 does not exist.', SemRegHeader."Room Code");
        SemRoom.TestField("Resource No.");

        if not Instr.Get(SemRegHeader."Instructor Code") then
            Error('Instructor %1 does not exist.', SemRegHeader."Instructor Code");
        Instr.TestField("Resource No.");

        if not Job.Get(SemRegHeader."Job No.") then
            Error('Job %1 does not exist.', SemRegHeader."Job No.");

        // === Step 14D: Validate Seminar Registration Lines exist ===
        SemRegLine.Reset();
        SemRegLine.SetRange("Document No.", SemRegHeader."No.");
        if not SemRegLine.FindFirst() then
            Error('No seminar registration lines exist for Seminar %1.', SemRegHeader."No.");

        // === Step 14E: Open progress dialog ===
        Window.Open(
            'Posting Seminar Registration...\\' +
            'Document No.: #1##########\\' +
            'Posting No.:  #2##########\\' +
            'Lines Processed: #3##########'
        );
        Window.Update(1, SemRegHeader."No.");
        Window.Update(2, ''); // will update after posted header insert
        Window.Update(3, 0);

        // === Step 14F: Assign Posting No. if missing ===
        if SemRegHeader."Posting No." = '' then begin
            SemRegHeader.TestField("Posting No. Series"); // must not be blank
            SemRegHeader."Posting No." :=
                NoSeriesMgt.GetNextNo(SemRegHeader."Posting No. Series", SemRegHeader."Posting Date", true);
            ModifyHeader := true;
        end;

        // === Step 14G: Save Header and Commit ===
        if ModifyHeader then
            SemRegHeader.Modify();
        COMMIT;

        // === Step 14H: Record-level locking ===
        SemRegLine.LockTable();
        SemLedgEntry.LockTable();
        if SemLedgEntry.FindLast() then
            SemLedgEntryNo := SemLedgEntry."Entry No."
        else
            SemLedgEntryNo := 0;

        // === Step 14I: Get Source Code from Source Code Setup ===
        if not SourceCodeSetup.Get() then
            Error('Source Code Setup is missing.');
        SrcCode := SourceCodeSetup."Seminar";

        // === Step 14J: Create Posted Seminar Reg. Header ===
        PstdSemRegHeader.Init();
        // PstdSemRegHeader.TRANSFERFIELDS(SemRegHeader, false);

        PstdSemRegHeader."No." := SemRegHeader."Posting No."; // use posting no. as primary key
        PstdSemRegHeader."Starting Date" := SemRegHeader."Starting Date";
        PstdSemRegHeader."Seminar No." := SemRegHeader."Seminar Code";
        PstdSemRegHeader."Seminar Name" := SemRegHeader."Seminar Name";
        PstdSemRegHeader."Instructor Code" := SemRegHeader."Instructor Code";
        PstdSemRegHeader."Duration" := SemRegHeader."Duration";
        PstdSemRegHeader."Maximum Participants" := SemRegHeader."Maximum Participants";
        PstdSemRegHeader."Minimum Participants" := SemRegHeader."Minimum Participants";
        PstdSemRegHeader."Room Code" := SemRegHeader."Room Code";
        PstdSemRegHeader."Room Name" := SemRegHeader."Room Name";
        PstdSemRegHeader."Room Address" := SemRegHeader."Room Address";
        PstdSemRegHeader."Room Address2" := SemRegHeader."Room Address2";
        PstdSemRegHeader."Room Post Code" := SemRegHeader."Room Post Code";
        PstdSemRegHeader."Room City" := SemRegHeader."Room City";
        PstdSemRegHeader."Room Phone No." := SemRegHeader."Room Phone No.";
        PstdSemRegHeader."Seminar Price" := SemRegHeader."Seminar Price";
        PstdSemRegHeader."Gen. Prod. Posting Group" := SemRegHeader."Gen. Prod. Posting Group";
        PstdSemRegHeader."VAT Prod. Posting Group" := SemRegHeader."VAT Prod. Posting Group";
        PstdSemRegHeader.Comment := SemRegHeader.Comment;
        PstdSemRegHeader."Posting Date" := SemRegHeader."Posting Date";
        PstdSemRegHeader."Document Date" := SemRegHeader."Document Date";
        PstdSemRegHeader."Job No." := SemRegHeader."Job No.";
        PstdSemRegHeader."Reason Code" := SemRegHeader."Reason Code";
        PstdSemRegHeader."No. Series" := SemRegHeader."No. Series";




        // Overwrite key fields
        PstdSemRegHeader."No." := SemRegHeader."Posting No.";
        PstdSemRegHeader."Registration No. Series" := SemRegHeader."No. Series";
        PstdSemRegHeader."Registration No." := SemRegHeader."No.";

        // Add posting metadata
        PstdSemRegHeader."Source Code" := SrcCode;
        PstdSemRegHeader."User ID" := CopyStr(UserId, 1, MaxStrLen(PstdSemRegHeader."User ID"));

        // Insert the record
        PstdSemRegHeader.Insert();

        // Update dialog with Posting No.
        Window.Update(2, PstdSemRegHeader."No.");

        // === Step 14K: Copy Related Data ===
        CopyCommentLines(
            SemCommentLine."Document Type"::"Seminar Registration",
            SemCommentLine."Document Type"::"Posted Seminar Registration",
            SemRegHeader."No.",
            PstdSemRegHeader."No.");

        CopyCharges(SemRegHeader."No.", PstdSemRegHeader."No.");

        // === Step 14L: Post Each Registration Line ===
        SemRegLine.Reset();
        SemRegLine.SetRange("Document No.", SemRegHeader."No.");
        if SemRegLine.FindSet() then begin
            LineCount := 0;

            repeat
                LineCount += 1;
                Window.Update(3, LineCount);

                SemRegLine.TestField("Bill-to Customer No.");
                SemRegLine.TestField("Participant Contact No.");

                if not SemRegLine."To Invoice" then begin
                    SemRegLine."Seminar Price" := 0;
                    SemRegLine."Line Discount %" := 0;
                    SemRegLine."Line Discount Amount" := 0;
                    SemRegLine.Amount := 0;
                end;

                JobLedgEntryNo := PostJobJnlLine(JobChargeType::Participant);
                SemLedgEntryNo := PostSeminarJnlLine(SemChargeType::Participant);

                PstdSemRegLine.Init();
                PstdSemRegLine.TRANSFERFIELDS(SemRegLine);
                PstdSemRegLine."Document No." := PstdSemRegHeader."No.";
                PstdSemRegLine.Insert();

                JobLedgEntryNo := 0;
                SemLedgEntryNo := 0;

            until SemRegLine.Next() = 0;
        end;

        // === Step 14M: Post Charges, Instructor, and Room ===
        PostCharge();
        PostSeminarJnlLine(SemChargeType::Instructor);
        PostSeminarJnlLine(SemChargeType::Room);

        // === Step 14N: Cleanup ===
        SemRegLine.LockTable();

        SemRegLine.Reset();
        SemRegLine.SetRange("Document No.", SemRegHeader."No.");
        if SemRegLine.FindSet() then
            SemRegLine.DeleteAll();

        SemCommentLine.Reset();
        SemCommentLine.SetRange("Document Type", SemCommentLine."Document Type"::"Seminar Registration");
        SemCommentLine.SetRange("No.", SemRegHeader."No.");
        if SemCommentLine.FindSet() then
            SemCommentLine.DeleteAll();

        SemCharge.Reset();
        SemCharge.SetRange("Seminar Registration No.", SemRegHeader."No.");
        if SemCharge.FindSet() then
            SemCharge.DeleteAll();

        SemRegHeader.Delete();
        Rec := SemRegHeader;

        // Close progress dialog
        Window.Close();
    end;


    //### GLOBAL VARIABLES  ######

    var
        // Seminar & Registration Records
        SemSetup: Record "Seminar SetUp";
        SemRegHeader: Record "Seminar Registration Header";
        SemRegLine: Record "Seminar Registration Line";
        PstdSemRegHeader: Record "Posted Seminar Reg.Header";
        PstdSemRegLine: Record "Posted Seminar Reg.Line";

        // Comment & Charge Records
        SemCommentLine: Record "Seminar Comment Line";
        SemCommentLine2: Record "Seminar Comment Line";
        SemCharge: Record "Seminar Charge";
        PstdSemCharge: Record "Posted Seminar Charge";

        // Setup & Master Data Records
        SemRoom: Record "Seminar Room";
        Instr: Record Instructor;
        Res: Record Resource;
        Cust: Record Customer;

        // Job & Journal Records
        Job: Record Job;
        JobLedgEntry: Record "Job Ledger Entry";
        SemLedgEntry: Record "Seminar Ledger Entry";
        JobJnlLine: Record "Job Journal Line";
        SemJnlLine: Record "Seminar Journal Line";

        // Setup & Management Records
        SourceCodeSetup: Record "Source Code Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

        // Posting Codeunits
        JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        SemJnlPostLine: Codeunit "Seminar Jnl.-Post Line";

        // My Defined Variables
        ModifyHeader: Boolean;
        Window: Dialog;
        SrcCode: Code[50];
        LineCount: Integer;
        JobLedgEntryNo: Integer;
        SemLedgEntryNo: Integer;

        ResourceNo: Code[20];

        JobChargeType: Option Participant,Charge;
        SemChargeType: Option Instructor,Room,Participant,Charge;


    local procedure CopyCommentLines(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    begin
        SemCommentLine.Reset();
        SemCommentLine.SetRange("Document Type", FromDocumentType);
        SemCommentLine.SetRange("No.", FromNumber);

        if SemCommentLine.FindSet() then begin
            repeat
                // Prepare the new record
                SemCommentLine2.Init();
                SemCommentLine2 := SemCommentLine;
                SemCommentLine2."Document Type" := ToDocumentType;
                SemCommentLine2."No." := ToNumber;
                SemCommentLine2.Insert();
            until SemCommentLine.Next() = 0;
        end;

    end;

    local procedure CopyCharges(FromNumber: Code[20]; ToNumber: Code[20])
    begin
        SemCharge.Reset();
        SemCharge.SetRange("Seminar Registration No.", FromNumber);
        if SemCharge.FindSet()
        then begin
            repeat
                PstdSemCharge.Init();
                PstdSemCharge.TransferFields(SemCharge); //Transfer all the fileds
                PstdSemCharge."Seminar Registration No." := ToNumber;
                PstdSemCharge.Insert();
            until SemCharge.Next() = 0;
        end;
    end;

    local procedure PostJobJnlLine(ChargeType: Option Participant,Charge): Integer
    begin

        // Get Instructor 
        if not Instr.Get(SemRegHeader."Instructor Code") then
            Error('Instructor %1 does not exist.', SemRegHeader."Instructor Code");

        if Instr."Resource No." = '' then
            Error('Instructor %1 has no Resource assigned.', Instr.Code);

        // Get Resource linked to Instructor
        if not Res.Get(Instr."Resource No.") then
            Error('Resource %1 linked to Instructor %2 does not exist.', Instr."Resource No.", Instr.Code);

        // Get Customer from the current Seminar Registration Line 
        if SemRegLine."Bill-to Customer No." = '' then
            Error('Bill-to Customer No. must be filled for Participant %1.', SemRegLine."Participant Name");

        if not Cust.Get(SemRegLine."Bill-to Customer No.") then
            Error('Customer %1 does not exist.', SemRegLine."Bill-to Customer No.");

        if not Res.Get(Instr."Resource No.") then
            Error('Resource %1 linked to Instructor %2 does not exist.', Instr."Resource No.", Instr.Code);

        if Res."Base Unit of Measure" = '' then
            Error('Resource %1 (%2) must have a Base Unit of Measure before posting.',
                  Res."No.", Res.Name);
        If Instr.GET(SemRegHeader."Instructor Code")
                 THEN
            ResourceNo := Instr."Resource No.";
        IF Res.GET(ResourceNo)
        then
            SemSetup.Get();
        SemSetup.TestField("Default Job Task No.");

        // ### Create and initialize Job Journal Line ###
        JobJnlLine.Init();
        JobJnlLine."Job No." := SemRegHeader."Job No.";
        JobJnlLine."Job Task No." := SemSetup."Default Job Task No.";
        JobJnlLine."Posting Date" := SemRegHeader."Posting Date";
        JobJnlLine."Document Date" := SemRegHeader."Document Date";
        JobJnlLine."Gen. prod. Posting Group" := Res."Gen. Prod. Posting Group";
        JobJnlLine."Entry Type" := JobJnlLine."Entry Type"::Usage;
        JobJnlLine."Document No." := PstdSemRegHeader."No.";
        JobJnlLine."Seminar Registration No." := PstdSemRegHeader."No.";
        JobJnlLine."Source Code" := SrcCode;
        JobJnlLine."Source Currency Total Cost" := SemRegLine."Seminar Price";

        JobJnlLine."Unit of Measure Code" := Res."Base Unit of Measure";
        // ### ChargeType = Participant 
        if ChargeType = ChargeType::Participant
        then begin
            JobJnlLine.Description := SemRegLine."Participant Name";
            JobJnlLine."No." := Instr."Resource No.";
            JobJnlLine.Chargeable := SemRegLine."To Invoice";
            JobJnlLine.Quantity := 1;
            JobJnlLine."Unit Cost" := 0;
            JobJnlLine."Total Cost" := 0;
            JobJnlLine."Unit Price" := SemRegLine.Amount;
            JobJnlLine."Total Price" := SemRegLine.Amount;
        end;

        // ### ChargeType = Charge 
        if ChargeType = ChargeType::Charge
        then begin
            JobJnlLine.Description := SemCharge.Description;
            case SemCharge.Type of

                // ##If Type = Resource
                SemCharge.Type::Resource:
                    begin
                        JobJnlLine.Type := JobJnlLine.Type::Resource;
                        JobJnlLine."Unit of Measure Code" := SemCharge."Unit Of Measure Code";
                        JobJnlLine."Qty. per Unit of Measure" := SemCharge."Qty. per Unit of Measure";
                    end;

                // ## If Type = Gl Account
                SemCharge.Type::"G/L Account":
                    begin
                        JobJnlLine.Type := JobJnlLine.Type::"G/L Account";
                        JobJnlLine.Chargeable := SemCharge."To Invoice";
                        JobJnlLine."Quantity (Base)" := 1;
                        JobJnlLine."Unit Cost" := 0;
                        JobJnlLine."Total Cost" := 0;
                        JobJnlLine."No." := SemCharge."No.";
                        JobJnlLine.Quantity := SemCharge.Quantity;
                        JobJnlLine."Unit Price" := SemCharge."Unit Price";
                        JobJnlLine."Total Price" := SemCharge."Total Price";
                    end;

            end;
        end;
        JobJnlLine.Insert(true);
        JobJnlPostLine.RunWithCheck(JobJnlLine);

        if JobLedgEntry.FindLast() then
            exit(JobLedgEntry."Entry No.")
        else
            exit(0);
    end;

    local procedure PostSeminarJnlLine(ChargeType: Option Instructor,Room,Participant,Charge): Integer
    begin
        SemJnlLine.Init();

        SemJnlLine."Seminar No." := SemRegHeader."Seminar Code";


        SemJnlLine."Document No." := PstdSemRegHeader."No.";
        SemJnlLine."Job No." := SemRegHeader."Job No.";
        SemJnlLine."Seminar Registration No." := PstdSemRegHeader."No.";
        SemJnlLine."Posting Date" := SemRegHeader."Posting Date";
        SemJnlLine."Document Date" := SemRegHeader."Document Date";
        SemJnlLine."Source Code" := SrcCode;


        SemJnlLine."Unit Price" := 0;
        SemJnlLine."Total Price" := 0;
        SemJnlLine.Quantity := 0;


        if ChargeType = ChargeType::Instructor
        then begin

            SemJnlLine."Instructor Code" := SemRegHeader."Instructor Code";
            SemJnlLine.Description := Instr.Name;
            SemJnlLine.Type := SemJnlLine.Type::Resource;
            SemJnlLine.Chargeable := false;
            SemJnlLine.Quantity := SemRegHeader.Duration;


        end;

        // --- Case: Room ---
        if ChargeType = ChargeType::Room then begin
            if not SemRoom.Get(SemRegHeader."Room Code") then
                Error('Room %1 does not exist.', SemRegHeader."Room Code");

            SemJnlLine.Description := SemRoom.Name;
            SemJnlLine.Type := SemJnlLine.Type::Resource;
            SemJnlLine.Chargeable := false;
            SemJnlLine.Quantity := SemRegHeader.Duration;
        end;


        // --- Case: Participant ---
        if ChargeType = ChargeType::Participant then begin
            if SemRegLine."Bill-to Customer No." = '' then
                Error('Bill-to Customer No. must be filled for participant %1.', SemRegLine."Participant Name");
            if SemRegLine."Participant Contact No." = '' then
                Error('Participant Contact No. must be filled for participant %1.', SemRegLine."Participant Name");

            SemJnlLine."Bill-to Customer No." := SemRegLine."Bill-to Customer No.";
            SemJnlLine."Participant Contact No." := SemRegLine."Participant Contact No.";
            SemJnlLine."Participant Name" := SemRegLine."Participant Name";

            SemJnlLine.Description := SemRegLine."Participant Name";
            SemJnlLine.Type := SemJnlLine.Type::Resource;
            SemJnlLine.Chargeable := SemRegLine."To Invoice";
            SemJnlLine.Quantity := 1;

            // Pricing from registration line
            SemJnlLine."Unit Price" := SemRegLine.Amount;
            SemJnlLine."Total Price" := SemRegLine.Amount;
        end;

        // --- Case: Charge ---
        if ChargeType = ChargeType::Charge
        then begin
            SemJnlLine.Description := SemCharge.Description;
            SemJnlLine."Bill-to Customer No." := SemCharge."Bill-to Customer No.";
            SemJnlLine.Type := SemCharge.Type;
            SemJnlLine.Quantity := SemCharge.Quantity;
            SemJnlLine."Unit Price" := SemCharge."Unit Price";
            SemJnlLine."Total Price" := SemCharge."Total Price";
            SemJnlLine.Chargeable := SemCharge."To Invoice";
        end;

        // === Post the Seminar Journal Line ===
        SemJnlPostLine.Run(SemJnlLine);

        // === Return last Seminar Ledger Entry No. ===
        if SemLedgEntry.FindLast() then
            exit(SemLedgEntry."Entry No.")
        else
            exit(0);

    end;


    local procedure PostCharge()
    begin

        SemCharge.Reset();
        SemCharge.SetRange("Seminar Registration No.", SemRegHeader."No.");

        if SemCharge.FindSet() then begin
            repeat
                // Post Job Journal Line for this charge
                JobLedgEntryNo := PostJobJnlLine(1);   // Charge
                // Post Seminar Journal Line for this charge
                SemLedgEntryNo := PostSeminarJnlLine(3);  // Charge
                // Reset counters after posting
                JobLedgEntryNo := 0;
            // SemLedgEntryNo := 0;
            until SemCharge.Next() = 0;
        end;
    end;







}







// codeunit 50104 "Seminar-Post"
// {
//     TableNo = "Seminar Registration Header";

//     trigger OnRun()
//     begin
//         Code(Rec); // Pass current Seminar Registration Header
//     end;

//     procedure Code(var SemRegHeader: Record "Seminar Registration Header")
//     var
//         PostedSemRegHeader: Record "Posted Seminar Reg.Header";
//         SemRegLine: Record "Seminar Registration Line";
//         PostedSemRegLine: Record "Posted Seminar Reg.Line";
//         NoSeriesMgt: Codeunit NoSeriesManagement;
//         NewNo: Code[20];
//         LineNo: Integer;
//         JobJnlLine: Record "Job Journal Line";
//         JobJnlLine2: Record "Job Journal Line";
//         JobJnlPost: Codeunit "Job Jnl.-Post Line";
//         SemSetup: Record "Seminar SetUp";
//         ResourceRec: Record Resource;
//         InstructorRec: Record Instructor;
//         ResourceNo: Code[20];
//     begin
//         if not Confirm('Do you want to post this seminar registration?', false) then
//             exit;

//         // === Create Posted Seminar Header ===
//         PostedSemRegHeader.Init();
//         NewNo := NoSeriesMgt.GetNextNo(SemRegHeader."No. Series", WorkDate(), true);
//         PostedSemRegHeader."No." := NewNo;

//         // --- Copy fields explicitly ---
//         PostedSemRegHeader."Seminar No." := SemRegHeader."No.";
//         PostedSemRegHeader."Seminar Name" := SemRegHeader."Seminar Name";
//         PostedSemRegHeader."Starting Date" := SemRegHeader."Starting Date";
//         PostedSemRegHeader."Duration" := SemRegHeader."Duration";
//         PostedSemRegHeader."Instructor Code" := SemRegHeader."Instructor Code";
//         PostedSemRegHeader."Instructor Name" := SemRegHeader."Instructor Name";
//         PostedSemRegHeader."Maximum Participants" := SemRegHeader."Maximum Participants";
//         PostedSemRegHeader."Minimum Participants" := SemRegHeader."Minimum Participants";
//         PostedSemRegHeader."Room Code" := SemRegHeader."Room Code";
//         PostedSemRegHeader."Room Name" := SemRegHeader."Room Name";
//         PostedSemRegHeader."Room Address" := SemRegHeader."Room Address";
//         PostedSemRegHeader."Room Address2" := SemRegHeader."Room Address2";
//         PostedSemRegHeader."Room Post Code" := SemRegHeader."Room Post Code";
//         PostedSemRegHeader."Room City" := SemRegHeader."Room City";
//         PostedSemRegHeader."Room Phone No." := SemRegHeader."Room Phone No.";
//         PostedSemRegHeader."Seminar Price" := SemRegHeader."Seminar Price";
//         PostedSemRegHeader."Gen. Prod. Posting Group" := SemRegHeader."Gen. Prod. Posting Group";
//         PostedSemRegHeader."VAT Prod. Posting Group" := SemRegHeader."VAT Prod. Posting Group";
//         PostedSemRegHeader."Job No." := SemRegHeader."Job No.";
//         PostedSemRegHeader."Reason Code" := SemRegHeader."Reason Code";
//         PostedSemRegHeader."No. Series" := SemRegHeader."No. Series";

//         // --- System fields ---
//         PostedSemRegHeader."Posting Date" := Today;
//         PostedSemRegHeader."Document Date" := WorkDate();
//         PostedSemRegHeader."User ID" := CopyStr(UserId, 1, MaxStrLen(PostedSemRegHeader."User ID"));
//         PostedSemRegHeader."Source Code" := 'SEMJNL';
//         PostedSemRegHeader.Insert(true);

//         // === Copy Lines ===
//         SemRegLine.SetRange("Document No.", SemRegHeader."No.");
//         if SemRegLine.FindSet() then begin
//             LineNo := 10000;
//             repeat
//                 PostedSemRegLine.Init();
//                 PostedSemRegLine."Document No." := PostedSemRegHeader."No.";
//                 PostedSemRegLine."Line No." := LineNo;
//                 PostedSemRegLine."Bill-to Customer No." := SemRegLine."Bill-to Customer No.";
//                 PostedSemRegLine."Participant Contact No." := SemRegLine."Participant Contact No.";
//                 PostedSemRegLine."Participant Name" := SemRegLine."Participant Name";
//                 PostedSemRegLine."Register Date" := SemRegLine."Register Date";
//                 PostedSemRegLine."To Invoice" := SemRegLine."To Invoice";
//                 PostedSemRegLine.Participated := SemRegLine.Participated;
//                 PostedSemRegLine."Confirmation Date" := SemRegLine."Confirmation Date";
//                 PostedSemRegLine."Seminar Price" := SemRegLine."Seminar Price";
//                 PostedSemRegLine."Line Discount %" := SemRegLine."Line Discount %";
//                 PostedSemRegLine."Line Discount Amount" := SemRegLine."Line Discount Amount";
//                 PostedSemRegLine.Amount := SemRegLine.Amount;
//                 PostedSemRegLine.Registered := SemRegLine.Registered;
//                 PostedSemRegLine.Insert(true);

//                 LineNo += 10000;
//             until SemRegLine.Next() = 0;

//             // === Create Job Journal Line ===
//             JobJnlLine.Init();

//             if SemRegHeader."Posting Date" = 0D then
//                 Error('Posting Date must be filled in on the Seminar Registration before posting.');

//             SemSetup.Get(); // Seminar Setup

//             // Use setup values instead of hardcoded ones
//             JobJnlLine."Journal Template Name" := SemSetup."Job Journal Template";
//             JobJnlLine."Journal Batch Name" := SemSetup."Job Journal Batch";
//             JobJnlLine2.SetRange("Journal Template Name", SemSetup."Job Journal Template");
//             JobJnlLine2.SetRange("Journal Batch Name", SemSetup."Job Journal Batch");

//             if JobJnlLine2.FindLast() then
//                 JobJnlLine."Line No." := JobJnlLine2."Line No." + 10000
//             else
//                 JobJnlLine."Line No." := 10000;

//             JobJnlLine."Posting Date" := SemRegHeader."Posting Date";
//             JobJnlLine."Document Date" := SemRegHeader."Posting Date";
//             JobJnlLine."Document No." := PostedSemRegHeader."No.";
//             JobJnlLine."Job No." := SemRegHeader."Job No.";
//             JobJnlLine."Job Task No." := SemSetup."Default Job Task No.";
//             JobJnlLine."Type" := JobJnlLine.Type::Resource;

//             // === Get Instructor Resource ===
//             // if not InstructorRec.Get(SemRegHeader."Instructor Code") then
//             //     Error('Instructor %1 does not exist.', SemRegHeader."Instructor Code");

//             // if InstructorRec."Resource No." = '' then
//             //     Error('Instructor %1 has no Resource assigned.', InstructorRec.Code);

//             // if not ResourceRec.Get(InstructorRec."Resource No.") then
//             //     Error('Resource %1 linked to Instructor %2 does not exist.',
//             //     InstructorRec."Resource No.", InstructorRec.Code);

//             // if ResourceRec."Gen. Prod. Posting Group" = '' then
//             //     Error('Resource %1 (%2) must have a Gen. Prod. Posting Group before posting.',
//             //           ResourceRec."No.", ResourceRec.Name);

//             If InstructorRec.GET(SemRegHeader."Instructor Code")
//                 THEN
//                 ResourceNo := InstructorRec."Resource No.";
//             IF ResourceRec.GET(ResourceNo)
//                 then
//                 JobJnlLine."No." := ResourceRec."No.";
//             JobJnlLine.Quantity := 1;
//             JobJnlLine."Gen. Prod. Posting Group" := ResourceRec."Gen. Prod. Posting Group";
//             JobJnlLine."Unit Price" := ResourceRec."Unit Price";
//             JobJnlLine."Line Type" := JobJnlLine."Line Type"::Billable;
//             JobJnlLine."Source Code" := SemSetup."Job Source Code";
//             JobJnlLine."Unit of Measure Code" := ResourceRec."Base Unit of Measure";

//             JobJnlLine.Insert(true);

//             // === Post Job Journal Line ===
//             JobJnlPost.Run(JobJnlLine);
//         end;

//         // === Cleanup: remove unposted records ===
//         SemRegLine.DeleteAll();
//         SemRegHeader.Delete();

//         Commit();

//         Message('Seminar Registration %1 has been posted as %2',
//             SemRegHeader."No.", PostedSemRegHeader."No.");
//     end;
// }
