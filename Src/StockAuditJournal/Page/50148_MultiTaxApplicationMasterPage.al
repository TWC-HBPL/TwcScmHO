page 50176 "MultiTax Application Mater" //JiraID-341
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = MultiTaxApplicable;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }
}