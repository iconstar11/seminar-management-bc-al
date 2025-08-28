namespace seminarmanagementbcal.seminarmanagementbcal;

using Microsoft.Foundation.AuditCodes;

tableextension 50103 SourceCodeSetupExt extends "Source Code Setup"
{
    fields
    {
        field(50100; Seminar; Code[10])
        {
            Caption = 'Seminar';
            DataClassification = ToBeClassified;
        }
    }
}
