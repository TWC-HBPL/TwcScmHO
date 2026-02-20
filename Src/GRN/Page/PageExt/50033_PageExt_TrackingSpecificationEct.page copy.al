pageextension 51033 AppliedDeliveryChallanExt extends "Applied Delivery Challan"
{
    layout
    {
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Line")
        {
            action("Clear Lot") //PT-FBTS 4-12-25 //Ticket420
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                Caption = 'Clear Assigned Lot';
                trigger OnAction()
                var
                    ResvaationEntey: Record "Reservation Entry";
                begin
                    ResvaationEntey.Reset();
                    ResvaationEntey.SetRange("Source Type", 18467);
                    if ResvaationEntey.FindFirst() then
                        ResvaationEntey.DeleteAll(true);
                    // rec.Delete();
                    //  CurrPage.Update();
                end;
            }
            //PT-FBTS 4-12-25 //Ticket420
        }
    }

    var
        myInt: Integer;
}