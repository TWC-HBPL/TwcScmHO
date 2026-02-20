pageextension 50055 PostedSalesInvoiceListExt extends "Posted Sales invoices"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bill-to Customer No.")
        {
            field("IRN Hash"; Rec."IRN Hash")
            {
                ApplicationArea = all;
            }
            field("E-Way Bill No."; Rec."E-Way Bill No.")
            {
                ApplicationArea = all;
            }
            field("QR Code"; Rec."QR Code")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Print)
        {
            trigger OnBeforeAction()
            var
                SalesInvoiceLineRec: Record "Sales Invoice Line";
                Amount_l: Decimal;
                Location: Record Location;
                Location1: Record Location;
            begin
                if (rec."GST Customer Type" = Rec."GST Customer Type"::Registered) or
                (rec."GST Customer Type" = Rec."GST Customer Type"::"SEZ Unit") then begin
                    if (Rec."IRN Hash" = '') then
                        Error('E-invoice is Mandatory');
                    // if (Rec."E-Way Bill No." = '') then
                    //     Error('E-waybill is Mandatory');
                end;

                // if Location.Get(Rec."Location State Code") then;
                // if Location1.Get(Rec.State) then;
                if (rec."GST Customer Type" = Rec."GST Customer Type"::Registered) or
                (rec."GST Customer Type" = Rec."GST Customer Type"::"SEZ Unit") then begin
                    if Rec.State <> Rec."Location State Code" then begin
                        if (Rec."IRN Hash" = '') then
                            Error('E-invoice is Mandatory');
                        if (Rec."E-Way Bill No." = '') then
                            Error('E-waybill is Mandatory');
                    end;
                end;

                if Rec.State = Rec."Location State Code" then begin
                    Clear(Amount_l);
                    SalesInvoiceLineRec.Reset();
                    SalesInvoiceLineRec.SetRange("Document No.", Rec."No.");
                    if SalesInvoiceLineRec.FindSet() then
                        //  TransferShipmentLine.CalcSums(Amount);
                        Amount_l := SalesInvoiceLineRec.Amount;
                    if Rec."E-Way Bill No." = '' then begin
                        if Amount_l > 50000 then
                            Error('E-way bill is Mandatory');
                    end;
                end;
            end;
        }

    }
    var
        myInt: Integer;
}