namespace seminarmanagementbcal.seminarmanagementbcal;
using Microsoft.Foundation.Period;

page 50111 "Seminar Statistics"
{
    ApplicationArea = All;
    Caption = 'Seminar Statistics';
    PageType = Card;
    SourceTable = Seminar;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

            }
        }

    }

    trigger OnAfterGetRecord()
    var
        SemRec: Record Seminar;
    begin
        // Filter table to current seminar
        SemRec.Get(Rec."No.");

        // Ensure CurrentDate is work date
        if CurrentDate <> WorkDate then
            CurrentDate := WorkDate;

        // Create filters for periods
        DateFilterCalc.CreateAccountingPeriodFilter(SemDateFilter[1], SemDateName[1], CurrentDate, 0);
        DateFilterCalc.CreateFiscalYearFilter(SemDateFilter[2], SemDateName[2], CurrentDate, 0);
        DateFilterCalc.CreateFiscalYearFilter(SemDateFilter[3], SemDateName[3], CurrentDate, i[3]);

        // Loop through first 3 dimensions
        for i[1] := 1 to 3 do begin
            SemRec.SetRange("No.", Rec."No."); // stay on current seminar
            SemRec.SetFilter("Date Filter", SemDateFilter[i[1]]);

            // Calculate flowfields
            SemRec.CalcFields("Total Price", "Total Price (Not Chargeable)", "Total Price (Chargeable)");

            // Assign to arrays
            TotalPrice[i[1]] := SemRec."Total Price";
            TotalPriceNotChargeable[i[1]] := SemRec."Total Price (Not Chargeable)";
            TotalPriceChargeable[i[1]] := SemRec."Total Price (Chargeable)";
        end;

        // Filter to records before current date
        SemRec.SetRange("No.", Rec."No.");
        SemRec.SetFilter("Date Filter", '..%1', CurrentDate - 1);

        SemRec.CalcFields("Total Price", "Total Price (Not Chargeable)", "Total Price (Chargeable)");

        TotalPrice[4] := SemRec."Total Price";
        TotalPriceNotChargeable[4] := SemRec."Total Price (Not Chargeable)";
        TotalPriceChargeable[4] := SemRec."Total Price (Chargeable)";
    end;


    var
        DateFilterCalc: Codeunit "DateFilter-Calc";
        SemDateFilter: array[4] of Text[30];
        SemDateName: array[4] of Text[30];
        CurrentDate: Date;
        TotalPrice: array[4] of Decimal;
        TotalPriceNotChargeable: array[4] of Decimal;
        TotalPriceChargeable: array[4] of Decimal;
        i: array[4] of Integer;

}
