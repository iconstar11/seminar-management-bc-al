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

codeunit 50107 "Seminar Invoices"
{

    Subtype = Normal;

    procedure CreateInvoices()
    var
        SeminarLedgerEntry: Record "Seminar Ledger Entry";
    begin
        if PostingDateReq = 0D then
            Error(Text000);
        if DocDateReq = 0D then
            Error(Text001);

        Window.Open(Text002);

        SeminarLedgerEntry.SetCurrentKey("Bill-to Customer No.", "Seminar Registration No.", "Charge Type", "Participant Contact No.");
        SeminarLedgerEntry.SetFilter("Remaining Amount", '<>0');

        if SeminarLedgerEntry.FindSet() then begin
            repeat
                // Create new Sales Header
                Clear(SalesHeader);
                SalesHeader.Init();
                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                SalesHeader."Bill-to Customer No." := SeminarLedgerEntry."Bill-to Customer No.";
                SalesHeader."Posting Date" := PostingDateReq;
                SalesHeader."Document Date" := DocDateReq;
                SalesHeader.Insert(true);

                // Create Sales Lines
                Clear(SalesLine);
                SalesLine.Init();
                SalesLine.Validate("Document No.", SalesHeader."No.");
                SalesLine.Validate("Line No.", NextLineNo + 10000);
                SalesLine.Validate(Description, SeminarLedgerEntry."Seminar No.");
                SalesLine.Validate(Quantity, 1);
                SalesLine.Validate("Unit Price", SeminarLedgerEntry."Remaining Amount");
                SalesLine.Insert(true);

                // Apply discounts if needed
                if CalcInvDisc then begin
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    if SalesLine.FindSet() then
                        repeat
                            SalesCalcDisc.Run(SalesLine);
                        until SalesLine.Next() = 0;
                end;

                // Post the invoice
                if PostInc then
                    SalesPost.Run(SalesHeader);

                NoOfSalesInv += 1;
                NextLineNo += 10000;
            until SeminarLedgerEntry.Next() = 0;

            Message(Text005, NoOfSalesInv);
        end else
            Message(Text007);

        Window.Close();
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


        Text000: Label 'Please enter the posting Date';
        Text001: Label 'Please enter the document Date';
        Text002: Label 'Creating Seminar Invoices...\\';
        Text003: Label 'Customer No. #1##########\';
        Text004: Label 'Registration No. #2##########\';
        Text005: Label 'The number of invoice(s) created is %1.';
        Text006: Label 'Not all the invoices were posted. A total of %1 invoices were not posted.';
        Text007: Label 'There is nothing to invoice.';
}

