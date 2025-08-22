codeunit 50104 "Seminar-Post"
{
    TableNo = "Seminar Registration Header";

    trigger OnRun()
    begin
        Code(Rec); // Pass current Seminar Registration Header
    end;

    procedure Code(var SemRegHeader: Record "Seminar Registration Header")
    var
        PostedSemRegHeader: Record "Posted Seminar Reg.Header";
        SemRegLine: Record "Seminar Registration Line";
        PostedSemRegLine: Record "Posted Seminar Reg.Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewNo: Code[20];
        LineNo: Integer;
        JobJnlLine: Record "Job Journal Line";
        JobJnlLine2: Record "Job Journal Line";
        JobJnlPost: Codeunit "Job Jnl.-Post Line";
        SemSetup: Record "Seminar SetUp";
        ResourceRec: Record Resource;
        InstructorRec: Record Instructor;
    begin
        if not Confirm('Do you want to post this seminar registration?', false) then
            exit;

        // === Create Posted Seminar Header ===
        PostedSemRegHeader.Init();
        NewNo := NoSeriesMgt.GetNextNo(SemRegHeader."No. Series", WorkDate(), true);
        PostedSemRegHeader."No." := NewNo;

        // --- Copy fields explicitly ---
        PostedSemRegHeader."Seminar No." := SemRegHeader."No.";
        PostedSemRegHeader."Seminar Name" := SemRegHeader."Seminar Name";
        PostedSemRegHeader."Starting Date" := SemRegHeader."Starting Date";
        PostedSemRegHeader."Duration" := SemRegHeader."Duration";
        PostedSemRegHeader."Instructor Code" := SemRegHeader."Instructor Code";
        PostedSemRegHeader."Instructor Name" := SemRegHeader."Instructor Name";
        PostedSemRegHeader."Maximum Participants" := SemRegHeader."Maximum Participants";
        PostedSemRegHeader."Minimum Participants" := SemRegHeader."Minimum Participants";
        PostedSemRegHeader."Room Code" := SemRegHeader."Room Code";
        PostedSemRegHeader."Room Name" := SemRegHeader."Room Name";
        PostedSemRegHeader."Room Address" := SemRegHeader."Room Address";
        PostedSemRegHeader."Room Address2" := SemRegHeader."Room Address2";
        PostedSemRegHeader."Room Post Code" := SemRegHeader."Room Post Code";
        PostedSemRegHeader."Room City" := SemRegHeader."Room City";
        PostedSemRegHeader."Room Phone No." := SemRegHeader."Room Phone No.";
        PostedSemRegHeader."Seminar Price" := SemRegHeader."Seminar Price";
        PostedSemRegHeader."Gen. Prod. Posting Group" := SemRegHeader."Gen. Prod. Posting Group";
        PostedSemRegHeader."VAT Prod. Posting Group" := SemRegHeader."VAT Prod. Posting Group";
        PostedSemRegHeader."Job No." := SemRegHeader."Job No.";
        PostedSemRegHeader."Reason Code" := SemRegHeader."Reason Code";
        PostedSemRegHeader."No. Series" := SemRegHeader."No. Series";

        // --- System fields ---
        PostedSemRegHeader."Posting Date" := Today;
        PostedSemRegHeader."Document Date" := WorkDate();
        PostedSemRegHeader."User ID" := CopyStr(UserId, 1, MaxStrLen(PostedSemRegHeader."User ID"));
        PostedSemRegHeader."Source Code" := 'SEMJNL';
        PostedSemRegHeader.Insert(true);

        // === Copy Lines ===
        SemRegLine.SetRange("Document No.", SemRegHeader."No.");
        if SemRegLine.FindSet() then begin
            LineNo := 10000;
            repeat
                PostedSemRegLine.Init();
                PostedSemRegLine."Document No." := PostedSemRegHeader."No.";
                PostedSemRegLine."Line No." := LineNo;
                PostedSemRegLine."Bill-to Customer No." := SemRegLine."Bill-to Customer No.";
                PostedSemRegLine."Participant Contact No." := SemRegLine."Participant Contact No.";
                PostedSemRegLine."Participant Name" := SemRegLine."Participant Name";
                PostedSemRegLine."Register Date" := SemRegLine."Register Date";
                PostedSemRegLine."To Invoice" := SemRegLine."To Invoice";
                PostedSemRegLine.Participated := SemRegLine.Participated;
                PostedSemRegLine."Confirmation Date" := SemRegLine."Confirmation Date";
                PostedSemRegLine."Seminar Price" := SemRegLine."Seminar Price";
                PostedSemRegLine."Line Discount %" := SemRegLine."Line Discount %";
                PostedSemRegLine."Line Discount Amount" := SemRegLine."Line Discount Amount";
                PostedSemRegLine.Amount := SemRegLine.Amount;
                PostedSemRegLine.Registered := SemRegLine.Registered;
                PostedSemRegLine.Insert(true);

                LineNo += 10000;
            until SemRegLine.Next() = 0;

            // === Create Job Journal Line ===
            // JobJnlLine.Init();

            // if SemRegHeader."Posting Date" = 0D then
            //     Error('Posting Date must be filled in on the Seminar Registration before posting.');

            // SemSetup.Get(); // Seminar Setup

            // // Use setup values instead of hardcoded ones
            // JobJnlLine."Journal Template Name" := SemSetup."Job Journal Template";
            // JobJnlLine."Journal Batch Name" := SemSetup."Job Journal Batch";
            // if JobJnlLine2.FindLast() then
            //     JobJnlLine."Line No." := JobJnlLine2."Line No." + 10000
            // else
            //     JobJnlLine."Line No." := 10000;

            // JobJnlLine."Posting Date" := SemRegHeader."Posting Date";
            // JobJnlLine."Document Date" := SemRegHeader."Posting Date";
            // JobJnlLine."Document No." := PostedSemRegHeader."No.";
            // JobJnlLine."Job No." := SemRegHeader."Job No.";
            // JobJnlLine."Job Task No." := SemSetup."Default Job Task No.";
            // JobJnlLine."Type" := JobJnlLine.Type::Resource;

            // // === Get Instructor Resource ===
            // if not InstructorRec.Get(SemRegHeader."Instructor Code") then
            //     Error('Instructor %1 does not exist.', SemRegHeader."Instructor Code");

            // if InstructorRec."Resource No." = '' then
            //     Error('Instructor %1 has no Resource assigned.', InstructorRec.Code);

            // if not ResourceRec.Get(InstructorRec."Resource No.") then
            //     Error('Resource %1 linked to Instructor %2 does not exist.', InstructorRec."Resource No.", InstructorRec.Code);

            // if ResourceRec."Gen. Prod. Posting Group" = '' then
            //     Error('Resource %1 (%2) must have a Gen. Prod. Posting Group before posting.',
            //           ResourceRec."No.", ResourceRec.Name);

            // JobJnlLine."No." := ResourceRec."No.";
            // JobJnlLine.Quantity := 1;
            // JobJnlLine."Unit Price" := SemRegHeader."Seminar Price";
            // JobJnlLine."Line Type" := JobJnlLine."Line Type"::Billable;
            // JobJnlLine."Source Code" := SemSetup."Job Source Code";

            // JobJnlLine.Insert(true);

            // // === Post Job Journal Line ===
            // JobJnlPost.Run(JobJnlLine);
        end;

        // === Cleanup: remove unposted records ===
        SemRegLine.DeleteAll();
        SemRegHeader.Delete();

        Commit();

        Message('Seminar Registration %1 has been posted as %2',
            SemRegHeader."No.", PostedSemRegHeader."No.");
    end;
}
