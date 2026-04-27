codeunit 50070 BrandFlowDataILE
{

    //PT-FBTS_Brand JIRAID-674

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnPostItemJnlLineOnAfterPrepareItemJnlLine, '', false, false)]
    local procedure "Sales-Post_OnPostItemJnlLineOnAfterPrepareItemJnlLine"(var ItemJournalLine: Record "Item Journal Line"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; WhseShip: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; QtyToBeShipped: Decimal; TrackingSpecification: Record "Tracking Specification")
    begin
        ItemJournalLine.Brand := SalesHeader.Brand;
    end;//PT-FBTS_Brand

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnPostItemJnlLineOnAfterPrepareItemJnlLine, '', false, false)]
    local procedure "Purch.-Post_OnPostItemJnlLineOnAfterPrepareItemJnlLine"(var ItemJournalLine: Record "Item Journal Line"; PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var GenJnlLineDocNo: Code[20]; TrackingSpecification: Record "Tracking Specification"; QtyToBeReceived: Decimal)
    var
    //dd:PAGE "Transfer Order"
    begin
        ItemJournalLine.Brand := PurchaseHeader.Brand;
    end;//PT-FBTS_Brand

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", OnBeforePostItemJournalLine, '', false, false)]
    local procedure "TransferOrder-Post Shipment_OnBeforePostItemJournalLine"(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferShipmentHeader: Record "Transfer Shipment Header"; TransferShipmentLine: Record "Transfer Shipment Line"; CommitIsSuppressed: Boolean)
    var
    // TransOrder:page "Transfer Order"
    begin
        ItemJournalLine.Brand := TransferShipmentHeader.Brand;
        //Message('Ship%1', ItemJournalLine.Brand);

    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", OnBeforeInsertConsumptionJnlLine, '', false, false)]
    local procedure "Production Journal Mgt_OnBeforeInsertConsumptionJnlLine"(var ItemJournalLine: Record "Item Journal Line"; ProdOrderComp: Record "Prod. Order Component"; ProdOrderLine: Record "Prod. Order Line"; Level: Integer)
    begin
        ProdOrderLine.CalcFields(Brand);
        ItemJournalLine.Brand := ProdOrderLine.Brand;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", OnBeforeInsertOutputJnlLine, '', false, false)]
    local procedure "Production Journal Mgt_OnBeforeInsertOutputJnlLine"(var ItemJournalLine: Record "Item Journal Line"; ProdOrderRtngLine: Record "Prod. Order Routing Line"; ProdOrderLine: Record "Prod. Order Line")
    begin
        ProdOrderLine.CalcFields(Brand);
        ItemJournalLine.Brand := ProdOrderLine.Brand;
    end;



    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", OnBeforePostItemJournalLine, '', false, false)]
    // local procedure "TransferOrder-Post Receipt_OnBeforePostItemJournalLine"(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferReceiptHeader: Record "Transfer Receipt Header"; TransferReceiptLine: Record "Transfer Receipt Line"; CommitIsSuppressed: Boolean; TransLine: Record "Transfer Line"; PostedWhseRcptHeader: Record "Posted Whse. Receipt Header")
    // begin
    //     ItemJournalLine.Brand := TransferReceiptHeader.Brand;
    //     Message('Rec%1', ItemJournalLine.Brand);
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt1", OnBeforePostItemJournalLine, '', false, false)]
    local procedure "TransferOrder-Post Receipt1_OnBeforePostItemJournalLine"(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferReceiptHeader: Record "Transfer Receipt Header"; TransferReceiptLine: Record "Transfer Receipt Line"; CommitIsSuppressed: Boolean; TransLine: Record "Transfer Line"; PostedWhseRcptHeader: Record "Posted Whse. Receipt Header")
    begin
        ItemJournalLine.Brand := TransferReceiptHeader.Brand;
        // Message('Rec1%1', ItemJournalLine.Brand);
    end;


    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", OnAfterCreateItemJnlLine, '', false, false)]
    // local procedure "TransferOrder-Post Shipment_OnAfterCreateItemJnlLine"(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferShipmentHeader: Record "Transfer Shipment Header"; TransferShipmentLine: Record "Transfer Shipment Line")
    // begin
    //     ItemJournalLine.Brand := TransferShipmentHeader.Brand;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", OnBeforePostCorrectionItemJnLine, '', false, false)]
    // local procedure "Assembly-Post_OnBeforePostCorrectionItemJnLine"(var ItemJournalLine: Record "Item Journal Line"; var TempItemLedgEntry: Record "Item Ledger Entry" temporary)
    // begin
    //     ItemJournalLine.Brand := 
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", OnAfterCreateItemJnlLineFromAssemblyHeader, '', false, false)]
    local procedure "Assembly-Post_OnAfterCreateItemJnlLineFromAssemblyHeader"(var ItemJournalLine: Record "Item Journal Line"; AssemblyHeader: Record "Assembly Header")
    begin
        ItemJournalLine.Brand := AssemblyHeader.Brand;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", OnBeforePostItemConsumptionProcedure, '', false, false)]
    local procedure "Assembly-Post_OnBeforePostItemConsumptionProcedure"(AssemblyHeader: Record "Assembly Header"; var AssemblyLine: Record "Assembly Line"; PostingNoSeries: Code[20]; QtyToConsume: Decimal; QtyToConsumeBase: Decimal; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line"; DocumentNo: Code[20]; IsCorrection: Boolean; ApplyToEntryNo: Integer; var Result: Integer; var IsHandled: Boolean)
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", OnBeforePostItemConsumption, '', false, false)]
    local procedure "Assembly-Post_OnBeforePostItemConsumption"(var AssemblyHeader: Record "Assembly Header"; var AssemblyLine: Record "Assembly Line"; var ItemJournalLine: Record "Item Journal Line")
    begin
        ItemJournalLine.Brand := AssemblyHeader.Brand;
    end;


}