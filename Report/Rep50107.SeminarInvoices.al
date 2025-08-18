namespace seminarmanagementbcal.seminarmanagementbcal;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Document;
using Microsoft.Sales.Posting;
using Microsoft.Finance.Currency;
using Microsoft.Projects.Project.Ledger;
using Microsoft.Projects.Project.Job;
using Microsoft.Sales.Customer;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Sales.Setup;

report 50107 "Seminar Invoices"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(SeminarLedgerEntry; "Seminar Ledger Entry")
        {
            DataItemTableView = sorting("Bill-to Customer No.", "Seminar Registration No.", "Charge Type", "Participant Contact No.")
                                where("Remaining Amount" = filter(<> 0));
            RequestFilterFields = "Bill-to Customer No.", "Seminar No.", "Posting Date";

            trigger OnPreDataItem()
            begin
                if PostingDateReq = 0D then
                    Error(Text000);
                if DocDateReq = 0D then
                    Error(Text001);

                Window.Open(Text002 + Text003 + Text004);
                FirstEntry := true;
            end;



            trigger OnAfterGetRecord()
            begin
                // Get Job Ledger Entry
                if not JobLedgEntry.Get("Job Ledger Entry No.") then
                    exit;

                // Validate customer is not blocked
                if Cust.Get("Bill-to Customer No.") then
                    if (Cust.Blocked = Cust.Blocked::All) or (Cust.Blocked = Cust.Blocked::Invoice) then begin
                        NoOfSalesInvErrors += 1;
                        exit;
                    end;

                // Handle new Sales Header if Bill-to changes
                if SalesHeader."Bill-to Customer No." <> "Bill-to Customer No." then begin
                    Window.Update(1, "Bill-to Customer No.");
                    if SalesHeader."No." <> '' then
                        FinalizeSalesInvHeader();

                    InsertSalesInvHeader(SeminarLedgerEntry);
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Document No." := SalesHeader."No.";
                end;

                // Update dialog with registration no.
                Window.Update(2, "Seminar Registration No.");

                // Create Sales Line
                Clear(SalesLine);
                SalesLine.Init();
                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                SalesLine.Validate("Document No.", SalesHeader."No.");
                SalesLine.Validate("Line No.", NextLineNo);

                SalesLine.Type := JobLedgEntry.Type;

                // If G/L Account, ensure posting group exists
                if JobLedgEntry.Type = JobLedgEntry.Type::"G/L Account" then begin
                    Job.TestField("Job Posting Group");
                    JobPostingGr.Get(Job."Job Posting Group");
                    // Old "G/L Exp. Sales Acc." replaced with modern field
                    JobPostingGr.TestField("Job Sales Applied Account");
                    SalesLine.Validate("No.", JobPostingGr."Job Costs Applied Account");
                end else
                    SalesLine.Validate("No.", JobLedgEntry."No.");

                SalesLine.Validate(Description, "Seminar Registration No.");
                SalesLine.Validate("Work Type Code", JobLedgEntry."Work Type Code");
                SalesLine.Validate("Unit of Measure Code", JobLedgEntry."Unit of Measure Code");

                if JobLedgEntry.Quantity <> 0 then
                    SalesLine.Validate("Unit Price", JobLedgEntry."Total Price" / JobLedgEntry.Quantity);

                // Handle currency conversion
                if JobLedgEntry.Quantity <> 0 then
                    SalesLine.Validate("Unit Price", JobLedgEntry."Total Price" / JobLedgEntry.Quantity);

                // Handle currency conversion
                if SalesHeader."Currency Code" <> '' then begin
                    SalesLine."Unit Price" :=
                            CurrExchRate.ExchangeAmtLCYToFCY(
                            SalesHeader."Posting Date",
                            SalesHeader."Currency Code",
                            SalesLine."Unit Price",
                            SalesHeader."Currency Factor");
                end;

                SalesLine.Validate("Unit Cost (LCY)", JobLedgEntry."Total Cost" / JobLedgEntry.Quantity);

                SalesLine.Validate("Unit Cost (LCY)", JobLedgEntry."Total Cost" / JobLedgEntry.Quantity);
                SalesLine.Validate(Quantity, JobLedgEntry.Quantity);
                SalesLine.Validate("Job No.", JobLedgEntry."Job No.");

                // Phase Code / Task Code / Step Code fields removed in BC → skipped

                // Old "Applies-to ID" logic removed (not available in BC)
                // Instead, we only keep invoice linking logic if needed

                SalesLine.Insert(true);
                NextLineNo += 10000;
            end;

            trigger OnPostDataItem()
            begin
                if SalesHeader."No." <> '' then
                    FinalizeSalesInvHeader();

                if NoOfSalesInv > 0 then
                    Message(Text005, NoOfSalesInv)
                else
                    Message(Text007);

                Window.Close();
            end;





        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(PostingDateReq; PostingDateReq)
                    {
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                    }
                    field(DocDateReq; DocDateReq)
                    {
                        ApplicationArea = All;
                        Caption = 'Document Date';
                    }
                    field(CalcInvDisc; CalcInvDisc)
                    {
                        ApplicationArea = All;
                        Caption = 'Calculate Invoice Discount';
                    }
                    field(PostInc; PostInc)
                    {
                        ApplicationArea = All;
                        Caption = 'Post Invoices';
                    }
                }

            }

        }
        trigger OnOpenPage()
        begin
            if PostingDateReq = 0D then
                PostingDateReq := WorkDate();
            if DocDateReq = 0D then
                DocDateReq := WorkDate();

            if SalesSetup.Get() then
                CalcInvDisc := SalesSetup."Calc. Inv. Discount";
        end;

    }

    local procedure InsertSalesInvHeader(SeminarLedgerEntry: Record "Seminar Ledger Entry")
    begin
        Clear(SalesHeader);
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."No." := ''; // Let system assign number
        SalesHeader.Insert(true);

        SalesHeader.Validate("Sell-to Customer No.", SeminarLedgerEntry."Bill-to Customer No.");
        if SalesHeader."Bill-to Customer No." <> SeminarLedgerEntry."Bill-to Customer No." then
            SalesHeader.Validate("Bill-to Customer No.", SeminarLedgerEntry."Bill-to Customer No.");

        SalesHeader.Validate("Posting Date", PostingDateReq);
        SalesHeader.Validate("Document Date", DocDateReq);
        SalesHeader.Validate("Currency Code", '');

        SalesHeader.Modify(true);
        Commit();
        NextLineNo := 10000;
    end;

    local procedure FinalizeSalesInvHeader()
    begin
        if CalcInvDisc then
            SalesCalcDisc.Run(SalesLine);

        Commit();

        Clear(SalesCalcDisc);
        Clear(SalesPost);
        NoOfSalesInv += 1;
        if PostInc then
            if not SalesPost.Run(SalesHeader) then
                NoOfSalesInvErrors += 1;
    end;

    var
        CompanyInfo: Record "Company Information";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        GlSetup: Record "General Ledger Setup";
        Cust: Record Customer;
        Job: Record Job;
        JobLedgEntry: Record "Job Ledger Entry";
        AppJobLedgEntry: Record "Job Ledger Entry";
        JobPostingGr: Record "Job Posting Group";
        CurrExchRate: Record "Currency Exchange Rate";
        SalesCalcDisc: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
        JobLedgEntrySign: Code[10];
        Window: Dialog;
        PostingDateReq: Date;
        DocDateReq: Date;
        CalcInvDisc: Boolean;
        PostInc: Boolean;
        NextLineNo: Integer;
        NoOfSalesInvErrors: Integer;
        NoOfSalesInv: Integer;
        FirstEntry: Boolean;



        Text000: Label 'Please enter the posting Date';
        Text001: Label 'Please enter the document Date';
        Text002: Label 'Creating Seminar Invoices...\\';
        Text003: Label 'Customer No. #1##########\';
        Text004: Label 'Registration No. #2##########\';
        Text005: Label 'The number of invoice(s) created is %1.';
        Text006: Label 'Not all the invoices were posted. A total of %1 invoices were not posted.';
        Text007: Label 'There is nothing to invoice.';
}

