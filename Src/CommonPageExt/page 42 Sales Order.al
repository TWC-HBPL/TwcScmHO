pageextension 50166 SalesOrder extends "Sales Order"
{
    layout
    {
        //PT-FBTS_Brand JIRAID-674
        // Add changes to page layout here
        addafter("Your Reference")
        {
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
            //   dd:Codeunit 22
            begin
                if Rec.Brand = Rec.Brand::" " then
                    Error('Please enter the Brand Code');
            end;
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            var

            begin
            end;
        }

    }
}