pageextension 50167 Salesinvoice extends "Sales Invoice" //PT-FBTS
{
    layout
    {
        //PT-FBTS_Brand JIRAID-674
        // Add changes to page layout here
        addafter("Bill-to City")
        {
            field(Brand; Rec.Brand)
            { ApplicationArea = all; }
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Post)
        {
            trigger OnBeforeAction()
            var

            begin

                if Rec.Brand = Rec.Brand::" " then
                    Error('Please enter the Brand Code');
            end;
        }


    }


}