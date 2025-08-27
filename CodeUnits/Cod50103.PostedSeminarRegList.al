namespace seminarmanagementbcal.seminarmanagementbcal;
using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Projects.Project.Posting;
using Microsoft.Foundation.NoSeries;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Projects.Project.Journal;
using Microsoft.Projects.Project.Ledger;
using Microsoft.Sales.Customer;

codeunit 50103 "Posted Seminar Reg.List"
{
    TableNo = "Seminar Registration Header";


    trigger OnRun()
    begin
        // Clear variables
        ClearAll();
        SemRegHeader := Rec;

        // Validate mandatory fields
        SemRegHeader.TestField("Posting Date");
        SemRegHeader.TestField("Document Date");
        SemRegHeader.TestField("Starting Date");
        SemRegHeader.TestField("Seminar Code");
        SemRegHeader.TestField(Duration);
        SemRegHeader.TestField("Instructor Code");
        SemRegHeader.TestField("Room Code");
        SemRegHeader.TestField("Job No.");
        SemRegHeader.TestField(Status, SemRegHeader.Status::Closed);

        // Validate related records
        SemRoom.Get(SemRegHeader."Room Code");
        SemRoom.TestField("Resource No.");
        Instr.Get(SemRegHeader."Instructor Code");
        Instr.TestField("Resource No.");

        // Check if lines exist
        SemRegLine.Reset();
        SemRegLine.SetRange("Document No.", SemRegHeader."No.");
        if not SemRegLine.FindFirst() then
            Error('No seminar registration lines found.');

        // Open progress dialog
        Window.Open('Posting Seminar Registration Line #1####');

        // Generate Posting No.
        if SemRegHeader."Posting No." = '' then begin
            SemRegHeader.TestField("Posting No. Series");
            SemRegHeader."Posting No." :=
                NoSeriesMgt.GetNextNo(SemRegHeader."Posting No. Series", WorkDate(), true);
            ModifyHeader := true;
        end;

        // Commit and lock records
        if ModifyHeader then begin
            SemRegHeader.Modify();
            Commit();
        end;

        if not SemRegLine.RecordLevelLocking then
            SemRegLine.LockTable();
        SemLedgEntry.LockTable();
        SemLedgEntry.FindLast();
        SemLedgEntryNo := SemLedgEntry."Entry Type" + 1;

        // Get source code
        SourceCodeSetup.Get();
        SrcCode := 'SEMINAR'; // Use a constant or replace with a valid field from SourceCodeSetup if available

        // Create Posted Header
        PstdSemRegHeader.Init();
        PstdSemRegHeader.TransferFields(SemRegHeader);
        PstdSemRegHeader."No." := SemRegHeader."Posting No.";
        PstdSemRegHeader."Registration No." := SemRegHeader."No.";
        PstdSemRegHeader."Registration No. Series" := SemRegHeader."No. Series";
        PstdSemRegHeader."Source Code" := SrcCode;
        PstdSemRegHeader."User ID" := UserId;
        PstdSemRegHeader.Insert();

        Window.Update(1, 1);

        // Copy comments and charges
        CopyCommentLines(0, 1, SemRegHeader."No.", PstdSemRegHeader."No.");
        CopyCharges(SemRegHeader."No.", PstdSemRegHeader."No.");

        // Post lines
        SemRegLine.Reset();
        SemRegLine.SetRange("Document No.", SemRegHeader."No.");
        LineCount := 1;

        if SemRegLine.FindSet() then
            repeat
                Window.Update(1, LineCount);
                SemRegLine.TestField("Bill-to Customer No.");
                SemRegLine.TestField("Participant Contact No.");

                if not SemRegLine."To Invoice" then begin
                    SemRegLine."Seminar Price" := 0;
                    SemRegLine."Line Discount %" := 0;
                    SemRegLine."Line Discount Amount" := 0;
                    SemRegLine.Amount := 0;
                end;

                JobLedgEntryNo := PostJobJnlLine(ChargeType::Participant);
                SemLedgEntryNo := PostSeminarJnlLine(ChargeType::Participant);

                // Insert Posted Line
                PstdSemRegLine.Init();
                PstdSemRegLine.TransferFields(SemRegLine);
                PstdSemRegLine."Document No." := PstdSemRegHeader."No.";
                PstdSemRegLine.Insert();

                JobLedgEntryNo := 0;
                SemLedgEntryNo := 0;

                LineCount += 1;
            until SemRegLine.Next() = 0;

        // Post additional charges and seminar entries
        PostCharge();
        PostSeminarJnlLine(ChargeType::Instructor);
        PostSeminarJnlLine(ChargeType::Room);

        // Clean up if record locking is off
        if not SemRegLine.RecordLevelLocking then
            SemRegLine.LockTable();

        // Delete source records
        SemCommentLine.Reset();
        SemCommentLine.SetRange("Document Type", 0);
        SemCommentLine.SetRange("No.", SemRegHeader."No.");
        SemCommentLine.DeleteAll();

        SemCharge.Reset();
        SemCharge.SetRange("Seminar Registration No.", SemRegHeader."No.");
        SemCharge.DeleteAll();

        SemRegLine.Reset();
        SemRegLine.SetRange("Document No.", SemRegHeader."No.");
        SemRegLine.DeleteAll();

        SemRegHeader.Delete();

        // Reset Rec to original record
        Rec := SemRegHeader;

        Window.Close();
    end;



    local procedure CopyCommentLines(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    begin
        SemCommentLine.Reset();
        SemCommentLine.SetRange("Document Type", FromDocumentType);
        SemCommentLine.SetRange("No.", FromNumber);

        if SemCommentLine.FindSet() then
            repeat
                SemCommentLine2 := SemCommentLine;
                SemCommentLine2."Document Type" := ToDocumentType;
                SemCommentLine2."No." := ToNumber;

                SemCommentLine2.Insert();
            until SemCommentLine.Next() = 0;
    end;

    local procedure CopyCharges(FromNumber: Code[20]; ToNumber: Code[20])
    var
        // FromNumber: Code[20];
        // ToNumber: Code[20];
        LineNo: Integer;

    begin
        SemCharge.Reset();
        SemCharge.SetRange("Seminar Registration No.", FromNumber);
        LineNo := 0;

        if SemCharge.FindSet() then
            repeat
                LineNo += 1;
                PstdSemCharge.Init();
                PstdSemCharge."Seminar Registration No." := ToNumber;
                PstdSemCharge."Line No." := LineNo;
                PstdSemCharge."Job No." := SemCharge."Job No.";
                PstdSemCharge.Type := SemCharge.Type;
                PstdSemCharge."No." := SemCharge."No.";
                PstdSemCharge.Description := SemCharge.Description;
                PstdSemCharge.Quantity := SemCharge.Quantity;
                PstdSemCharge."Unit Price" := SemCharge."Unit Price";
                PstdSemCharge."Total Price" := SemCharge."Total Price";
                PstdSemCharge."To Invoice" := SemCharge."To Invoice";
                PstdSemCharge."Bill-to Customer No." := SemCharge."Bill-to Customer No.";
                PstdSemCharge."Unit of Measure Code" := SemCharge."Unit Of Measure Code";
                PstdSemCharge."Gen. Prod. Posting Group" := SemCharge."Gen. Prod. Posting Group";
                PstdSemCharge."VAT Prod. Posting Group" := SemCharge."VAT Prod. Posting Group";
                PstdSemCharge."Qty. per Unit of Measure" := SemCharge."Qty. Per Unit of Measure";
                PstdSemCharge.Registered := SemCharge.Registered;

                PstdSemCharge.Insert();
            until SemCharge.Next() = 0;

    end;


    local procedure PostJobJnlLine(ChargeType: Option "Participant","Charge"): Integer
    var
        LastJobLedgEntry: Record "Job Ledger Entry";
    begin
        // Get Customer, Instructor, and Resource
        Cust.Get(PstdSemRegLine."Bill-to Customer No.");
        Instr.Get(PstdSemRegHeader."Instructor Code");
        Res.Get(Instr."Resource No.");

        // Initialize Job Journal Line
        JobJnlLine.Init();
        JobJnlLine."Journal Template Name" := 'DEFAULT';
        JobJnlLine."Journal Batch Name" := 'DEFAULT'; // Default batch, since it's not stored in posted header
        JobJnlLine."Line No." := 10000;
        JobJnlLine."Entry Type" := JobJnlLine."Entry Type"::Usage;
        JobJnlLine."Posting Date" := PstdSemRegHeader."Posting Date";
        JobJnlLine."Document No." := PstdSemRegHeader."No.";
        JobJnlLine."Seminar Registration No." := PstdSemRegLine."Document No."; // Link back to header
        JobJnlLine."Job No." := PstdSemRegHeader."Job No.";
        JobJnlLine."Source Code" := SrcCode;
        JobJnlLine."Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";

        case ChargeType of
            ChargeType::Participant:
                begin
                    JobJnlLine.Description := PstdSemRegLine."Participant Name";
                    JobJnlLine."No." := Res."No."; // Instructor Resource No.
                    JobJnlLine."Chargeable" := PstdSemRegLine."To Invoice";
                    JobJnlLine.Quantity := 1;
                    JobJnlLine."Quantity (Base)" := 1;
                    JobJnlLine."Unit Cost" := 0;
                    JobJnlLine."Total Cost" := 0;
                    JobJnlLine."Unit Price" := PstdSemRegLine.Amount;
                    JobJnlLine."Total Price" := PstdSemRegLine.Amount;
                end;

            ChargeType::Charge:
                begin
                    JobJnlLine.Description := SemCharge.Description;
                    JobJnlLine."Chargeable" := SemCharge."To Invoice";
                    JobJnlLine.Quantity := SemCharge.Quantity;
                    JobJnlLine."Quantity (Base)" := 1;
                    JobJnlLine."Unit Cost" := 0;
                    JobJnlLine."Total Cost" := 0;
                    JobJnlLine."Unit Price" := SemCharge."Unit Price";
                    JobJnlLine."Total Price" := SemCharge."Total Price";

                    case SemCharge.Type of
                        SemCharge.Type::Resource:
                            begin
                                JobJnlLine.Type := JobJnlLine.Type::Resource;
                                JobJnlLine."No." := SemCharge."No.";
                                JobJnlLine."Unit of Measure Code" := SemCharge."Unit Of Measure Code";
                                JobJnlLine."Qty. per Unit of Measure" := SemCharge."Qty. Per Unit of Measure";
                            end;

                        SemCharge.Type::"G/L Account":
                            begin
                                JobJnlLine.Type := JobJnlLine.Type::"G/L Account";
                                JobJnlLine."No." := SemCharge."No.";
                            end;
                    end;
                end;
        end;

        // Post the Job Journal Line
        JobJnlPostLine.RunWithCheck(JobJnlLine);

        // Return the last Job Ledger Entry No.
        if LastJobLedgEntry.FindLast() then
            exit(LastJobLedgEntry."Entry No.")
        else
            exit(0);
    end;



    local procedure PostedSeminarJnlLine(ChargeType: Option "Instructor","Room","Participant","Charge"): Integer
    begin
        exit(0);
    end;

    local procedure PostSeminarJnlLine(ChargeType: Option "Participant","Charge"): Integer
    begin
        // Implement posting logic for Seminar Journal Line here if needed
        // For now, this is a stub to resolve the missing procedure error
        exit(0);
    end;

    local procedure PostCharge()
    begin
        SemCharge.Reset();
        SemCharge.SetRange("Seminar Registration No.", SemRegHeader."No.");

        if SemCharge.FindSet() then
            repeat
                JobLedgEntryNo := PostJobJnlLine(ChargeType::Charge);
                PostSeminarJnlLine(ChargeType::Charge);
            until SemCharge.Next() = 0;

        JobLedgEntryNo := 0;

    end;


    var
        ChargeType: Option "Participant","Charge","Instructor","Room";
        SemRegHeader: Record "Seminar Registration Header";
        SemRegLine: Record "Seminar Registration Line";
        PstdSemRegHeader: Record "Posted Seminar Reg.Header";
        SemCommentLine: Record "Seminar Comment Line";
        SemCommentLine2: Record "Seminar Comment Line";
        SemCharge: Record "Seminar Charge";
        PstdSemCharge: Record "Posted Seminar Charge";
        PstdSemRegLine: Record "Posted Seminar Reg.Line";
        SemRoom: Record "Seminar Room";
        Instr: Record Instructor;
        Job: Record Job;
        Res: Record Resource;
        Cust: Record Customer;
        JobLedgEntry: Record "Job Ledger Entry";
        SemLedgEntry: Record "Seminar Journal Line";
        JobJnlLine: Record "Job Journal Line";
        SemJnlLine: Record "Seminar Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        SemJnlPostLine: Codeunit "Seminar Jnl.-Post Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ModifyHeader: Boolean;
        Window: Dialog;
        SrcCode: Code[10];
        LineCount: Integer;
        JobLedgEntryNo: Integer;
        SemLedgEntryNo: Integer;



}
