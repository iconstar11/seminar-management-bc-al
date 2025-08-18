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

            trigger OnAfterGetRecord()
            begin
                if PostingDateReq = 0D then
                    Error(Text000);
                if DocDateReq = 0D then
                    Error(Text001);

                if FirstEntry then begin
                    Window.Open(Text002);
                    FirstEntry := false;
                end;

                // Create Sales Header
                Clear(SalesHeader);
                SalesHeader.Init();
                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                SalesHeader.Validate("Bill-to Customer No.", "Bill-to Customer No.");
                SalesHeader."Posting Date" := PostingDateReq;
                SalesHeader."Document Date" := DocDateReq;
                SalesHeader.Insert(true);

                // Create Sales Line
                Clear(SalesLine);
                SalesLine.Init();
                SalesLine.Validate("Document No.", SalesHeader."No.");
                SalesLine.Validate("Line No.", NextLineNo + 10000);
                SalesLine.Validate(Description, "Seminar No.");
                SalesLine.Validate(Quantity, 1);
                SalesLine.Validate("Unit Price", "Remaining Amount");
                SalesLine.Insert(true);

                // Apply invoice discount if needed
                if CalcInvDisc then begin
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    if SalesLine.FindSet() then
                        repeat
                            SalesCalcDisc.Run(SalesLine);
                        until SalesLine.Next() = 0;
                end;

                // Post the invoice if requested
                if PostInc then
                    SalesPost.Run(SalesHeader);

                NoOfSalesInv += 1;
                NextLineNo += 10000;
            end;

            trigger OnPostDataItem()
            begin
                if NoOfSalesInv > 0 then
                    Message(Text005, NoOfSalesInv)
                else
                    Message(Text007);

                Window.Close();
            end;

            trigger OnPreDataItem()
            begin
                if PostingDateReq = 0D then
                    Error(Text000);
                if DocDateReq = 0D then
                    Error(Text001);

                Window.Open(Text002 + Text003 + Text004);
            end;
        }
    }
    local procedure InsertSalesInvHeader(SeminarLedgerEntry: Record "Seminar Ledger Entry")
    begin
        Clear(SalesHeader);
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."No." := ''; // Let system assign number
        // Insert first so that integrations/triggers have a record
        SalesHeader.Insert(true);
        // Validate Sell-to Customer No. (this may pull default values)
        SalesHeader.Validate("Sell-to Customer No.", SeminarLedgerEntry."Bill-to Customer No.");
        // Ensure Bill-to is aligned (in case Sell-to validation changed it)
        if SalesHeader."Bill-to Customer No." <> SeminarLedgerEntry."Bill-to Customer No." then
            SalesHeader.Validate("Bill-to Customer No.", SeminarLedgerEntry."Bill-to Customer No.");

        // Validate dates using Validate to respect checks and defaults
        SalesHeader.Validate("Posting Date", PostingDateReq);
        SalesHeader.Validate("Document Date", DocDateReq);
        SalesHeader.Validate("Currency Code", '');

        SalesHeader.Modify(true);

        Commit();
        NextLineNo := 10000;
    end;


    local procedure FinalizeSalesInvHeader()
    begin
        // Apply invoice discount if requested
        if CalcInvDisc then begin
            SalesCalcDisc.Run(SalesLine);
        end;
        Commit();

        Clear(SalesCalcDisc);
        Clear(SalesPost);

        NoOfSalesInv += 1;

        if PostInc then begin
            if not SalesPost.Run(SalesHeader) then
                NoOfSalesInvErrors += 1;
        end;
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
        JobLedgerEntry: Code[10];
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



