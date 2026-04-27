pageextension 50165 SalesReturnOrder extends "Sales Return Order"
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
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                //PT-FBTS_Brand JIRAID-674
                if Rec.Brand = Rec.Brand::" " then
                    Error('Please enter the Brand Code');
            end;
        }
    }

    var
        myInt: Integer;
}