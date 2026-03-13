tableextension 50077 PurchReceviableExt extends "Purchases & Payables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50100; SDVendPostingGrp; Code[10])
        {
            Caption = 'SD Vendor Posting Group';
            // TableRelation = Vendor."Vendor Posting Group";

        }
        field(50000; "Rate Diff Charge Group"; Code[20]) //PT-FBTS 02-03-2026
        {
            TableRelation = "Item Charge";


        }
        field(50001; "Rate Diff Enable"; Boolean)//PT-FBTS 02-03-2026
        {

        }
        field(50002; "Email Enable"; Boolean) //PT-FBTS 02-03-2026
        {

        }

    }

    var
        myInt: Integer;
}