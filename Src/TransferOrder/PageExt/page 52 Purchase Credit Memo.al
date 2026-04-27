pageextension 50176 PurchCreditMemo extends "Purchase Credit Memo"
{
    layout
    {
        //PT-FBTS_Brand JIRAID-674
        addafter("Vendor Cr. Memo No.")//Aashish
        {
            field(Brand; Rec.Brand)
            {
                ApplicationArea = All;
            }

        }

    }

    actions
    {
        // Add changes to page actions here
        //modify( pos)
        modify(Post)
        {
            //PT-FBTS_Brand JIRAID-674
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                //  SendEmail(rec."No.");
                if Rec.Brand = Rec.Brand::" " then
                    Error('Please enter the Brand Code');
            end;
        }
        // modify(PostAndPrint)

    }

}