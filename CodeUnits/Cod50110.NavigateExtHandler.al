// namespace seminarmanagementbcal.seminarmanagementbcal;
// using Microsoft.Foundation.Navigate;

// codeunit 50110 "Navigate Ext Handler"
// {

//     [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterFindRecords', '', false, false)]
//     local procedure MyFindSeminarDocs(DocNoFilter: Code[20]; PostingDateFilter: Date; var DocumentEntry: Record "Document Entry" temporary)
//     var
//         SemRegHeader: Record "Seminar Registration Header";
//         PstdSemRegHeader: Record "Posted Seminar Reg.Header";
//         SemLedgEntry: Record "Seminar Ledger Entry";
//     begin
//         if SemRegHeader.ReadPermission then begin
//             SemRegHeader.SetRange("No.", DocNoFilter);
//             SemRegHeader.SetRange("Posting Date", PostingDateFilter);
//             if SemRegHeader.FindFirst() then
//                 DocumentEntry.InsertEntry(DATABASE::"Seminar Registration Header", SemRegHeader."No.", '');
//         end;

//         if PstdSemRegHeader.ReadPermission then begin
//             PstdSemRegHeader.SetRange("No.", DocNoFilter);
//             PstdSemRegHeader.SetRange("Posting Date", PostingDateFilter);
//             if PstdSemRegHeader.FindFirst() then
//                 DocumentEntry.InsertEntry(DATABASE::"Posted Seminar Reg.Header", PstdSemRegHeader."No.", '');
//         end;

//         if SemLedgEntry.ReadPermission then begin
//             SemLedgEntry.SetRange("Document No.", DocNoFilter);
//             SemLedgEntry.SetRange("Posting Date", PostingDateFilter);
//             if SemLedgEntry.FindFirst() then
//                 DocumentEntry.InsertEntry(DATABASE::"Seminar Ledger Entry", SemLedgEntry."Document No.", '');
//         end;
//     end;


//     [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterShowRecords', '', false, false)]
//     local procedure MyShowSeminarDocs(DocumentEntry: Record "Document Entry")
//     var
//         SemRegHeader: Record "Seminar Registration Header";
//         PstdSemRegHeader: Record "Posted Seminar Reg.Header";
//         SemLedgEntry: Record "Seminar Ledger Entry";
//     begin
//         case DocumentEntry."Table ID" of
//             DATABASE::"Seminar Registration Header":
//                 begin
//                     SemRegHeader.SetRange("No.", DocumentEntry."Document No.");
//                     PAGE.Run(PAGE::"Seminar Registration List", SemRegHeader);
//                 end;
//             DATABASE::"Posted Seminar Reg.Header":
//                 begin
//                     PstdSemRegHeader.SetRange("No.", DocumentEntry."Document No.");
//                     PAGE.Run(PAGE::"Posted Seminar Reg.Listpart", PstdSemRegHeader);
//                 end;
//             DATABASE::"Seminar Ledger Entry":
//                 begin
//                     SemLedgEntry.SetRange("Document No.", DocumentEntry."Document No.");
//                     PAGE.Run(PAGE::"Seminar Ledger Entries", SemLedgEntry);
//                 end;
//         end;
//     end;

// }
