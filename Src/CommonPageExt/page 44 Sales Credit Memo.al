pageextension 50164 SalesCredit extends "Sales Credit Memo" //PT-FBTS
{
    layout
    {
        addafter("Posting Date")
        {
            //PT-FBTS_Brand JIRAID-674
            field(Brand; Rec.Brand)
            { ApplicationArea = all; }
        }
    }
    actions
    {
        // Add changes to page actions here
        modify(Post)
        {
            //PT-FBTS_Brand JIRAID-674FV
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                if Rec.Brand = Rec.Brand::" " then
                    Error('Please enter the Brand Code');
            end;
        }

    }

    var
        myInt: Integer;
}