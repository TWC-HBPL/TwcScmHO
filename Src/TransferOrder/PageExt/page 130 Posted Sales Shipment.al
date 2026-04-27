pageextension 50155 "PostedSalesShipment" extends "Posted Sales Shipment"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bill-to City")
        {
            //PT-FBTS_Brand JIRAID-674
            field(Brand; Rec.Brand)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}