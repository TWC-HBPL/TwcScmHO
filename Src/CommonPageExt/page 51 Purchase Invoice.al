pageextension 50115 PurchaseInvoiceExt extends 51
{
    layout
    {
        // Add changes to page layout here
        addafter("Vendor Invoice No.")
        {
            field("Vendor Bill No."; Rec."Vendor Bill No.")
            {
                ApplicationArea = all;
            }
            field("Order No"; Rec."Order No")
            {
                ApplicationArea = all;
            }
            //PT-FBTS_Brand JIRAID-674
            field(Brand; Rec.Brand)
            { ApplicationArea = ALL; }

        }
    }

    actions
    {
        // Add changes to page actions here
        //ALLENick091023_start
        modify(PostBatch)
        {
            Visible = true; //Aashish
        }


        //ALLENick091023_End
        modify(Post)
        {
            trigger OnBeforeAction()//PT-FBTS-16-08-25
            var
                myInt: Integer;
            begin
                //PT-FBTS_Brand JIRAID-674
                if Rec.Brand = Rec.Brand::" " then
                    Error('Please check the Brand code is blank');
                // PurchInvSub.Reset();
                // PurchInvSub.SetRange("Document No.", Rec."No.");
                // if PurchInvSub.Findset() then begin
                //     repeat
                //         GLAccont.Reset();
                //         GLAccont.SetRange("No.", PurchInvSub."No.");
                //         GLAccont.SetRange("TDS Mandatory", true);
                //         if GLAccont.FindFirst() then
                //             repeat
                //                 if PurchInvSub."TDS Section Code" = '' then
                //                     Error('Please enter TD Section Code then Post', PurchInvSub."No.");
                //             until GLAccont.Next() = 0;
                //     until PurchInvSub.Next() = 0;
                // end;
            end;
            //PT-FBTS-16-08-25
        }

        //ALLENick091023_End


    }



    var
        PurchInvSub: Record "Purchase Line";
        GLAccont: Record "G/L Account";
        myInt: page "Purch. Invoice Subform";
}