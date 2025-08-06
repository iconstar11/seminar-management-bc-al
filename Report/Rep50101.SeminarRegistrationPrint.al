namespace seminarmanagementbcal.seminarmanagementbcal;

report 50101 "Seminar Registration Print"
{
    Caption = 'Seminar Registration Print';
    dataset
    {
        dataitem(; "")
        {
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
}
