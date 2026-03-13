reportextension 50134 "PurchaseCredit Memo GST" extends "Purchase - Credit Memo GST"   //PT-FBTS 02-03-2026
{
    dataset
    {
        // Add changes to dataitems and columns here
        add("Purch. Cr. Memo Hdr.")
        {
            column(Vendor_Bill_No_; "Vendor Bill No.")
            { }
            column(VendorInvoiceDate; VendorInvoiceDate)
            { }
        }
        add("Purch. Cr. Memo Line")
        {
            column(GST_Group_Code; "GST Group Code")
            { }
            column(CGSTAmt1; CGSTAmt1)
            { }
            column(SGSTAmt1; SGSTAmt1)
            { }
            column(IGSTAmt1; IGSTAmt1)
            { }
            column(GRN_Rate; "GRN Rate")
            { }
            column(PI_Rate; "PI Rate")
            { }


        }
        modify("Purch. Cr. Memo Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                myInt: Integer;
            begin
                Clear(IGSTAmt1);
                Clear(CGSTAmt1);
                Clear(SGSTAmt1);
                // Clear(CessAmt);
                DetailedGSTLedgerEntry.Reset();
                DetailedGSTLedgerEntry.SetRange("Document No.", "Purch. Cr. Memo Line"."Document No.");
                DetailedGSTLedgerEntry.SetRange("No.", "Purch. Cr. Memo Line"."No.");
                DetailedGSTLedgerEntry.SetRange("Document Line No.", "Purch. Cr. Memo Line"."Line No.");
                if DetailedGSTLedgerEntry.FindSet() then
                    repeat
                        if (DetailedGSTLedgerEntry."GST Component Code" = 'CGST') then
                            CGSTAmt1 += Abs(DetailedGSTLedgerEntry."GST Amount");


                        // if (DetailedGSTLedgerEntry."GST Component Code" = SGSTLbl) And (PurchCrMemoHdr."Currency Code" <> '') then
                        //     SGSTAmt1 += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * PurchCrMemoHdr."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                        // else
                        if (DetailedGSTLedgerEntry."GST Component Code" = 'SGST') then
                            SGSTAmt1 += Abs(DetailedGSTLedgerEntry."GST Amount");


                        if (DetailedGSTLedgerEntry."GST Component Code" = 'IGST') then
                            IGSTAmt1 += Abs(DetailedGSTLedgerEntry."GST Amount");

                    // if (DetailedGSTLedgerEntry."GST Component Code" = CessLbl) And (PurchCrMemoHdr."Currency Code" <> '') then
                    //     CessAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * PurchCrMemoHdr."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
                    // else
                    //     if (DetailedGSTLedgerEntry."GST Component Code" = CessLbl) then
                    //         CessAmt += Abs(DetailedGSTLedgerEntry."GST Amount");
                    until DetailedGSTLedgerEntry.Next() = 0;
            end;
            //end;
        }

    }


    requestpage
    {
        // Add changes to the requestpage here


    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'Src/Report/PurchCreditMemoBase.rdl';
        }
    }
    var
        sdd: Report "Purchase - Credit Memo GST";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt1: Decimal;
        SGSTAmt1: Decimal;
        CGSTAmt1: Decimal;


    // local procedure GetGSTAmount(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    // PurchCrMemoLine: Record "Purch. Cr. Memo Line")
    // var

    // begin


}