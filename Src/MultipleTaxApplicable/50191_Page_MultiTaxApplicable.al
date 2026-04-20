//AJAlle_11102023
//NTCNFRM
page 50191 "Multiple Tax Applicable"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Multiple Tax Applicable";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Vendor; rec.Vendor)
                {
                    ApplicationArea = All;

                }
                field(Item; rec.Item)
                {
                    ApplicationArea = all;
                }
                field("GST Group Code"; Rec."GST Group Code")
                {
                    ApplicationArea = all;
                }
                field("HSN/SAC CODE"; Rec."HSN/SAC CODE")
                {
                    ApplicationArea = all;
                }
                field(StoreRegion; Rec.StoreRegion)//Jira ID-341
                {
                    ApplicationArea = all;
                    Caption = 'Store Region';
                    ShowMandatory = true;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;

    trigger OnQueryClosePage(CloseAction: Action): Boolean //Jira ID-341
    var
        MultiTax: Record "Multiple Tax Applicable";
    begin
        // Copy current page filter context (if any)
        MultiTax.Copy(Rec);

        // Loop through visible/filtered records
        if MultiTax.FindSet() then
            repeat
                if MultiTax."HSN/SAC CODE" = '' then
                    Error(
                        'Please fill the HSN/SAC Code before closing the page.\Vendor: %1\Item: %2\Store Region: %3',
                        MultiTax.Vendor,
                        MultiTax.Item,
                        MultiTax.StoreRegion
                    );
            until MultiTax.Next() = 0;

        exit(true);
    end;
}