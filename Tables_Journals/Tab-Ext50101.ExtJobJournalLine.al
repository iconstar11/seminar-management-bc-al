namespace seminarmanagementbcal.seminarmanagementbcal;

using Microsoft.Projects.Project.Journal;

tableextension 50101 "Ext.Job Journal Line " extends "Job Journal Line"
{
    fields
    {
        field(50100; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
            DataClassification = ToBeClassified;
        }
    }
}
