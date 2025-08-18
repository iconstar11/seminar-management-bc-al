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

report 50106 "Seminar Reg.-Part. Certificate"
{
    Caption = 'Seminar Reg.-Part. Certificate';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    DefaultRenderingLayout = Word;

    dataset
    {
        dataitem("Seminar Registration Header"; "Seminar Registration Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Starting Date", "Seminar Code";
            PrintOnlyIfDetail = true;

            column(No; "No.") { }
            column(SeminarName; "Seminar Name") { }
            column(StartingDate; "Starting Date") { }
            column(InstructorName; "Instructor Name") { }

            dataitem("Seminar Registration Line"; "Seminar Registration Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLink = "Document No." = field("No.");
                // DataItemIndent = 1;
                // NewPagePerRecord = true;
                column(ParticipantName; "Participant Name") { }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    rendering
    {
        layout(Word)
        {
            Type = Word;
            LayoutFile = 'ReportLayout/SeminarCertificateConfirmation.docx';
            Caption = 'Certificate Confirmation Layout';
        }
    }
    var
        CompanyInfo: Record "Company Information";


}
