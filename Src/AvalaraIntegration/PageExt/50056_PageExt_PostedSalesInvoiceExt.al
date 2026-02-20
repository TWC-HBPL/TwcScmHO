pageextension 50056 PostedSalesExtGST extends "Posted Sales invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {

        }
    }

    actions
    {
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

        addlast(processing)
        {
            action("Generate E-Invoice TWC")
            {
                ApplicationArea = Basic, Suite;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Specifies the function through which Json file will be generated.';

                trigger OnAction()
                var
                    //     SalesInvHeader: Record "Sales Invoice Header";
                    //     eInvoiceJsonHandler: Codeunit SalesInvoiceCreditMemo;
                    //     eInvoiceManagement: Codeunit "e-Invoice Management";
                    //     eWaybillEinvoice: Codeunit SalesInvoiceCreditMemo;

                    EinvoiceCU: codeunit "Einvoice CU";
                begin
                    // if (Rec."Sales type" = Rec."Sales type"::"Tax Invoice") or (Rec."Sales type" = Rec."Sales type"::"Rent Invoice") then begin
                    EinvoiceCU.SaleInvoice_GenerateIRNNumber(TransType::Sale, rec."Sell-to Customer No.", rec."No.", Rec);
                end;

                //end;

                // if eInvoiceManagement.IsGSTApplicable(Rec."No.", Database::"Sales Invoice Header") then begin
                //  SalesInvHeader.Reset();
                // SalesInvHeader.SetRange("No.", Rec."No.");
                // if SalesInvHeader.FindFirst() then begin
                //     Clear(eInvoiceJsonHandler);
                //     SalesInvHeader.Mark(true);
                //     eInvoiceJsonHandler.SetSalesInvHeader(SalesInvHeader);
                //     if SalesInvHeader."Acknowledgement No." = '' then
                //         eInvoiceJsonHandler.CreateSalesEInvoice();
                //     CurrPage.Update();
                //     Clear(eWaybillEinvoice);
                //     SalesInvHeader.Mark(true);
                //     eWaybillEinvoice.SetSalesInvHeader(SalesInvHeader);
                //     eWaybillEinvoice.CreateSalesInvoiceEwayBill();
                //     CurrPage.Update();

                // end;

                //  End;
                /*

            end else
                    Error('Error in generating file');
         //   end;*/
            }
            action("E-Way Bill Generate")
            {
                ApplicationArea = Basic, Suite;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Specifies the function through which Json file will be generated.';

                trigger OnAction()
                var
                    Einvoice: Codeunit "Einvoice CU";
                begin
                    Einvoice.SaleInvoice_GenerateInvoice(TransType::Sale, Rec."Sell-to Customer No.", Rec."No.", Rec)
                end;
            }
            action(EWAYBILL)
            {
                ApplicationArea = ALL;
                Caption = 'Only E-WAY Bill TWC';
                Visible = true;
                Promoted = true;
                Image = Print;


                trigger OnAction()
                var
                    EWAYBILL_SALESINVOICE: codeunit 50117;
                    storerec: Record "LSC Store";
                begin

                    EWAYBILL_SALESINVOICE.Generate__EWAY_BILL(Rec);
                    // TransferWAY.EwayGenerateIRNNumber(Rec);
                    // storerec.GET(Rec."Transfer-from Code");
                    // TransferWAY.HostbookLoginEWAYBill(storerec);

                end;

            }

            action("Cancel Einvoice")
            {
                ApplicationArea = Basic, Suite;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Specifies the function through which Json file will be generated.';

                trigger OnAction()
                var
                    Einvoice: Codeunit "Einvoice CU";
                begin
                    Einvoice.Cancel_Einvoice(TransType::Sale, Rec."Sell-to Customer No.", Rec."No.", Rec)
                end;
            }
            action("Cancel EWayBill")
            {
                ApplicationArea = Basic, Suite;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Specifies the function through which Json file will be generated.';

                trigger OnAction()
                var
                    Einvoice: Codeunit "Einvoice CU";
                begin
                    Einvoice.Cancel_Ewaybill(TransType::Sale, Rec."Sell-to Customer No.", Rec."No.", Rec)
                end;
            }
            action(LogEinv)
            {
                ApplicationArea = All;
                Caption = 'Log E-InvLog';
                Promoted = true;
                PromotedCategory = Category4;
                Image = Log;
                RunObject = page "E-invlog";
                RunPageLink = "Document No." = field("No.");
            }
            // action("Generate E-Invoice TWC")
            // {
            //     ApplicationArea = Basic, Suite;
            //     Image = ExportFile;
            //     Promoted = true;
            //     PromotedCategory = Category4;
            //     ToolTip = 'Specifies the function through which Json file will be generated.';

            //     trigger OnAction()
            //     var
            //         SalesInvHeader: Record "Sales Invoice Header";
            //         eInvoiceJsonHandler: Codeunit SalesInvoiceCreditMemo;
            //         eInvoiceManagement: Codeunit "e-Invoice Management";
            //         eWaybillEinvoice: Codeunit SalesInvoiceCreditMemo;
            //     begin


            //         // if eInvoiceManagement.IsGSTApplicable(Rec."No.", Database::"Sales Invoice Header") then begin
            //         SalesInvHeader.Reset();
            //         SalesInvHeader.SetRange("No.", Rec."No.");
            //         if SalesInvHeader.FindFirst() then begin
            //             Clear(eInvoiceJsonHandler);
            //             SalesInvHeader.Mark(true);
            //             eInvoiceJsonHandler.SetSalesInvHeader(SalesInvHeader);
            //             if SalesInvHeader."Acknowledgement No." = '' then
            //                 eInvoiceJsonHandler.CreateSalesEInvoice();
            //             CurrPage.Update();
            //             Clear(eWaybillEinvoice);
            //             SalesInvHeader.Mark(true);
            //             eWaybillEinvoice.SetSalesInvHeader(SalesInvHeader);
            //             eWaybillEinvoice.CreateSalesInvoiceEwayBill();
            //             CurrPage.Update();

            //         end;

            // End;
            /*

        end else
                Error('Error in generating file');
     //   end;*/
            // }
        }
    }
    var
        myInt: Integer;
        TransType: Option Sale,"Sale Retrun";

    trigger OnDeleteRecord(): Boolean; /// PT-FBTS 11-09-24 
    var
        myInt: Integer;
    begin
        Error('You can not delete this documnet');
    end;
}