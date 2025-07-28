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

    end;

    local procedure CopyCommentLines()
    var
        FromDocumentType: Integer;
        ToDocumentType: Integer;
        FromNumber: Code[20];
        ToNumber: Code[20];
    begin

    end;

    local procedure CopyCharges()
    var
        FromNumber: Code[20];
        ToNumber: Code[20];
    begin

    end;

    local procedure PostedJobJnlLine(ChargeType: Option "Participant","Charge"): Integer
    begin
        exit(0);
    end;

    local procedure PostedSeminarJnlLine(ChargeType: Option "Instructor","Room","Participant","Charge"): Integer
    begin
        exit(0);
    end;

    local procedure PostCharge()
    begin

    end;


    var
        SemRegHeader: Record "Seminar Registration Header";
        SemRegLine: Record "Seminar Registration Line";
        PstdSemRegHeader: Record "Posted Seminar Reg.Header";
        SemCommentLine: Record "Seminar Comment Line";
        SemCommentLine2: Record "Seminar Comment Line";
        SemCharge: Record "Seminar Charge";
        PstdSemCharge: Record "Posted Seminar Charge";
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
