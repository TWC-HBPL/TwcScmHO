report 50690 "Update SKU Cost From API"
{
    Caption = 'Update SKU Cost From API';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Administration;

    trigger OnPostReport()
    var
        SKULog: Record "SKU Cost Update Log";
    begin
        // Pehle purana log delete kare
        SKULog.DeleteAll();
        //EntryNo := 0;

        UpdateSKUCost();
        Message('SKU Cost update completed. Please check SKU Cost Update Log.');
    end;


    local procedure UpdateSKUCost()
    var
        URL: Text;


        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        Response: Text;
        ResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        JsonObject: JsonObject;
        JSONManagement: Codeunit "JSON Management";
        ArrayJSONManagement: Codeunit "JSON Management";
        ObjectJSONManagement: Codeunit "JSON Management";
        Index: Integer;
        Value: text;
        ItemJsonobject: text;
        JsonObject1: JsonObject;
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        JsonToken1: JsonToken;
        ItemNo: Code[20];
        VariantCode: Code[20];
        // StockCheckAgSalesLine: record "Stock Check Ag Sales Line";
        // StockCheckAgSalesLine1: record "Stock Check Ag Sales Line";
        SKU: Record "Stockkeeping Unit";
        SKULog: Record "SKU Cost Update Log";
        OldUnitCost: Decimal;
        NewUnitCost: Decimal;
        StoreNo: Text;
        Itm: Record Item;
        Date_: text;
        Description: Text;
        UOM: Text;
        Sale_Quantity: text;
        Stock: text;
        Stock_lDec: Decimal;

        Adj_Required: Text;
        Pending_Receiving: Text;
        Expected_Pur_Receiving:
                    Text;
        Expected_Pur_Receiving_lDec: decimal;
        Date_lDat: Date;
        Sale_Quantity_ldec: Decimal;
        Adj_Required_ldec: Decimal;
        Pending_Receiving_ldec: Decimal;
        InventorySetup: Record "Inventory Setup";
    begin

        // URL := 'http://10.20.2.9:1122/api/values/sku_cost';
        URL := 'http://10.20.0.7:1122/api/values/sku_cost'; //JIRAID-666


        IF HttpClient.Get(URL, HttpResponseMessage) then begin
            HttpResponseMessage.Content.ReadAs(Response);
            Response := DelChr(Response, '=', '\/');
            Response := CopyStr(Response, 2, StrLen(Response) - 2);
            // Message('%1', Response);
            if JsonArray.ReadFrom(Response) then begin
                //Message(Response);
                for Index := 0 to JsonArray.Count() - 1 do begin
                    //EntryNo := +1;
                    if JsonArray.Get(Index, JsonToken) then begin
                        JsonObject1 := JsonToken.AsObject();
                        if JsonObject1.Get('Location Code', JsonToken1) then begin
                            StoreNo := JsonToken1.AsValue().AsText();
                        end;

                        //Message('%1', StoreNo);
                        if JsonObject1.Get('Item No_', JsonToken1) then begin
                            ItemNo := JsonToken1.AsValue().AsText();
                        end;
                        if JsonObject1.Get('Qty', JsonToken1) then begin
                            Sale_Quantity := JsonToken1.AsValue().AsText();
                            Evaluate(Sale_Quantity_ldec, Sale_Quantity);
                        end;
                        if JsonObject1.Get('Cost_Amt', JsonToken1) then begin
                            Stock := JsonToken1.AsValue().AsText();
                            Evaluate(Stock_ldec, Stock);
                        end;
                        // if JsonObject1.Get('Rate', JsonToken1) then begin
                        //     Adj_Required := JsonToken1.AsValue().AsText();
                        //     Evaluate(Adj_Required_ldec, Adj_Required);
                        if JsonObject1.Get('Rate', JsonToken1) then begin
                            Adj_Required := JsonToken1.AsValue().AsText();
                            if not Evaluate(Adj_Required_ldec, Adj_Required) then
                                Adj_Required_ldec := 0;
                        end;

                    end;
                    NewUnitCost := Round(Adj_Required_ldec, 0.01);


                    Clear(SKULog);
                    SKULog.Init();
                    //."Entry No." := EntryNo;
                    SKULog."Entry DateTime" := CurrentDateTime;
                    SKULog."Location Code" := StoreNo;
                    SKULog."Item No." := ItemNo;
                    SKULog."New Unit Cost" := NewUnitCost;
                    SKULog."Cost Amount" := Stock_ldec;

                    SKU.Reset();
                    SKU.SetRange("Location Code", StoreNo);
                    SKU.SetRange("Item No.", ItemNo);
                    if SKU.FindFirst() then begin
                        //SKU 
                        OldUnitCost := SKU."Unit Cost";
                        SKULog."Old Unit Cost" := OldUnitCost;

                        // if SKU."New Cost Amt" <> NewUnitCost then begin
                        //     //SKU.Validate("New Cost Amt", NewUnitCost);
                        //     SKU.Modify(true);
                        // end;

                        SKULog.Status := SKULog.Status::Success;
                    end else begin
                        //SKU n
                        SKULog.Status := SKULog.Status::Failed;
                        SKULog."Error Message" := 'SKU not found for Location ' + StoreNo;
                    end;

                    SKULog.Insert();
                    Commit();

                end;
            end;
        end;
    end;

    //end;

    var
        EntryNo: Integer;

    [TryFunction]
    local procedure TryUpdateSKUUnitCost(var SKU: Record "Stockkeeping Unit"; UnitCost: Decimal)
    begin
        SKU.Validate("Unit Cost", UnitCost);
        //SKU.Modify(true);

    end;


}
