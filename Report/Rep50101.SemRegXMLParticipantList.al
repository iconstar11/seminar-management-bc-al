namespace seminarmanagementbcal.seminarmanagementbcal;
using System.Utilities;

report 50101 "Sem. Reg.-XML Participant List"
{
    Caption = 'Sem. Reg.-XML Participant List';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(SemRegHeader; "Seminar Registration Header")
        {
            RequestFilterFields = "No.", "Seminar Code";
        }
    }

    trigger OnPreReport()
    var
        OutStr: OutStream;
        InStr: InStream;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
    begin
        FileName := 'XML_Participant_List.xml';

        // Create a stream in memory
        TempBlob.CreateOutStream(OutStr);

        // Export XML into OutStream
        XmlPort.Export(XmlPort::"Sem. Reg.-XML Participant List", OutStr, SemRegHeader);

        // Turn blob into an InStream for download
        TempBlob.CreateInStream(InStr);

        // Let the user download
        DownloadFromStream(InStr, '', '', '', FileName);

        Message('XML export completed successfully.');
    end;
}