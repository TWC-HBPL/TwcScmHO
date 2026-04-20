page 50005 "Sub Indent List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = IndentHeader;
    SourceTableView = where("Sub-Indent" = const(true), Status = const(Released));
    //Editable = false;
    InsertAllowed = false;
    // DeleteAllowed = true;
    CardPageId = IndentProcessingCard;
    Caption = 'Indent Processing page';



    layout
    {
        area(Content)
        {

            repeater(GroupName)
            {
                // Editable = rec.Status <> Rec.Status::Release;
                field(Select; rec.Select)
                {
                    ApplicationArea = all;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("To Location Name"; rec."To Location Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("From Location Name"; rec."From Location Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Main Indent No."; rec."Main Indent No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Indent Date"; rec."Created Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }

            }
        }

    }

    actions
    {
        area(Processing)
        {
            action("Create Orders")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Process;

                trigger OnAction()
                var
                    indentHdr: Record IndentHeader;
                    indentline: Record Indentline;
                    PO: Record "Purchase Header";
                    subindentPO: Record "Sub Indent PO";
                begin
                    indentline.Reset();
                    indentline.SetRange(Select, true);
                    indentline.SetRange("Sub-Indent", true);
                    if indentline.FindFirst() then begin
                        Report.Run(50001, false, false, indentline);
                    end;
                    /*
                                        po.Reset();
                                        PO.SetRange("Indent No.", Rec."No.");
                                        IF PO.FindFirst() then
                                            repeat
                                                subindentPO.Reset();
                                                subindentPO.SetRange("PO NO.", PO."No.");
                                                IF subindentPO.FindLast() then
                                                    SendMail(subindentPO);
                                            until PO.Next() = 0;
                                            */

                    indentHdr.Reset();
                    indentHdr.SetRange("From Location Code", usersetup."Location Code");
                    indentHdr.SetRange(Select, true);
                    IF indentHdr.FindSet() then
                        repeat
                            CreateTransferOrder(indentHdr);
                        //   Rec.Status := Rec.Status::Released;
                        // Rec.Modify();
                        until indentHdr.Next() = 0;

                end;
            }
            action("Select all")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Process;

                trigger OnAction()
                var
                    indentHdr: Record IndentHeader;
                    indentline: Record Indentline;
                begin
                    //  Rec.Select := true;
                    indentHdr.Reset();
                    indentHdr.SetRange("From Location Code", usersetup."Location Code");
                    indentHdr.SetRange("Sub-Indent", true);
                    indentHdr.SetRange(Status, indentHdr.Status::Released);
                    if indentHdr.FindSet() then
                        repeat
                            indentHdr.Select := true;
                            indentHdr.Modify(true);
                            indentline.Reset();
                            indentline.SetRange("DocumentNo.", indentHdr."No.");
                            IF indentline.FindSet() then
                                indentline.ModifyAll(Select, true);
                        until indentHdr.Next() = 0;

                end;
            }
            action("UnSelect all")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Process;

                trigger OnAction()
                var
                    indentHdr: Record IndentHeader;
                    indentline: Record Indentline;
                begin
                    //  Rec.Select := true;
                    indentHdr.Reset();
                    indentHdr.SetRange("From Location Code", usersetup."Location Code");
                    indentHdr.SetRange("Sub-Indent", true);
                    indentHdr.SetRange(Status, indentHdr.Status::Released);
                    if indentHdr.FindSet() then
                        repeat
                            indentHdr.Select := false;
                            indentHdr.Modify(true);
                            indentline.Reset();
                            indentline.SetRange("DocumentNo.", indentHdr."No.");
                            IF indentline.FindSet() then
                                indentline.ModifyAll(Select, false);
                        until indentHdr.Next() = 0;

                end;
            }
        }

    }
    trigger OnOpenPage()
    var

    begin
        IF usersetup.Get(UserId) then;
        //rec.SetRange("From Location Code", usersetup."Location Code");

        Rec.FilterGroup(2);
        Rec.Setfilter("From Location code", '=%1|=%2', UserSetup."Location Code", '');
        Rec.FilterGroup(1);
    end;

    local procedure CreateTransferOrder(recIndent: Record IndentHeader)
    var
        transHdr: Record "Transfer Header";
        transHdr1: Record "Transfer Header";
        transline: Record "Transfer Line";
        transline1: Record "Transfer Line";
        inventorySetup: Record "Inventory Setup";
        //Transno: code[20];
        Transno: code[25];//PT-FBTS-31-03-2026 JiraID-855
        noseriesmgt: Codeunit NoSeriesManagement;
        IndentLine: Record Indentline;
        TransHdr2: Record "Transfer Header";
        IndentLn: Record Indentline;
        LineNo: Integer;
        LocationRec: Record Location;
        MultipleTaxApplicable: Record "Multiple Tax Applicable";
        storeReason: Option;
        Item: Record Item;
        StockkeepingUnitPrice: Record "Stockkeeping Unit";
        GSTPer: Decimal;
        BookvalueGST: Decimal;
        i: Integer;
        TaxCaseExecution: Codeunit "Use Case Execution";
    begin
        inventorySetup.Get();
        Clear(Transno);
        IndentLine.Reset();
        IndentLine.SetRange("Location/StoreNo.From", usersetup."Location Code");
        IndentLine.SetRange("DocumentNo.", recIndent."No.");
        IF IndentLine.FindFirst() then
            repeat
                IF Transno <> IndentLine."DocumentNo." then begin
                    transHdr.Init();
                    transHdr."No." := noseriesmgt.GetNextNo(inventorySetup."Transfer Order Nos.", WorkDate(), true);
                    transHdr.Insert();
                    transHdr.Validate("Transfer-from Code", IndentLine."Location/StoreNo.From");
                    transHdr.Validate("Transfer-to Code", IndentLine."Location/StoreNo.To");
                    transHdr.Validate("Posting Date", IndentLine."Request Delivery Date");
                    transHdr.Validate("Shipment Date", IndentLine."Request Delivery Date");
                    transHdr.Validate("Requistion No.", IndentLine."DocumentNo.");
                    // transHdr.Validate("In-Transit Code", 'INTRANSIT');//AsPerREQ12102023
                    transHdr.Validate("In-Transit Code", 'INTRANSIT1');
                    transHdr.Validate("Shipment Date", recIndent."Posting date");
                    Transno := IndentLine."DocumentNo.";
                    transHdr.Modify();
                End;

                Clear(LineNo); //JiraID-308
                transline1.Reset();
                transline1.SetRange("Document No.", transHdr."No.");
                IF transline1.FindLast() then
                    LineNo := transline1."Line No." + 10000
                Else
                    LineNo := 10000;//JiraID-308
                transline.Init();
                transline."Document No." := transHdr."No.";
                transline."Line No." := LineNo;

                transline.Validate("Item No.", IndentLine."Item Code");
                IndentLine.CalcFields(UOM);
                transline.validate("Unit of Measure Code", IndentLine.UOM);
                transline.Validate(Quantity, IndentLine.Quantity);
                transline.Validate("Indent Qty.", IndentLine.Quantity);
                transline.Validate("FA Subclass", IndentLine."FA Subclass");

                LocationRec.Reset(); //JiraID-308
                LocationRec.SetRange(Code, transHdr."Transfer-from Code");
                if LocationRec.FindFirst() then begin
                    MultipleTaxApplicable.Reset();
                    MultipleTaxApplicable.SetRange(StoreRegion, LocationRec.StoreRegion);
                    MultipleTaxApplicable.SetRange(Item, transline."Item No.");
                    if MultipleTaxApplicable.FindFirst() then begin
                        if transline."Item No." <> '9999999' then begin///PT-FBTS-20-04-26
                            transline.Validate("GST Group Code", MultipleTaxApplicable."GST Group Code");
                            transline.Validate("HSN/SAC Code", MultipleTaxApplicable."HSN/SAC Code");
                        end;
                    end else begin
                        if Item.Get(transline."Item No.") then begin
                            if not item.IsFixedAssetItem then begin
                                transline.Validate("GST Group Code", Item."GST Group Code");
                                transline.Validate("HSN/SAC Code", Item."HSN/SAC Code");
                            end;
                        end;
                        //JiraID-308 end;
                    End;
                End;
                transline.Insert(true);


                Clear(BookvalueGST);
                Clear(GSTPer);
                StockkeepingUnitPrice.Reset(); //PT-FBTS 16-08-2025
                StockkeepingUnitPrice.SetRange("Location Code", transHdr."Transfer-from Code");
                StockkeepingUnitPrice.SetRange("Item No.", transline."Item No.");
                if StockkeepingUnitPrice.FindFirst() then begin
                    Evaluate(GSTPer, transline."GST Group Code");
                    BookvalueGST := Round(StockkeepingUnitPrice."Unit Cost" / (100 + GSTPer) * 100);
                    transline.Validate("Transfer Price", BookvalueGST);
                End
                else
                    if Item.Get(transline."Item No.") then begin
                        Evaluate(GSTPer, transline."GST Group Code");
                        BookvalueGST := Round(Item."Unit Cost" / (100 + GSTPer) * 100);
                        transline.Validate("Transfer Price", BookvalueGST);
                    end;
                TaxCaseExecution.HandleEvent('OnAfterTransferPrirce', transline, '', 0);
                transline.Modify(true);

            until IndentLine.Next() = 0;
        TransHdr2.Reset();
        TransHdr2.SetRange("No.", transHdr."No.");
        IF TransHdr2.FindFirst() then begin
            TransHdr2.Validate(Status, TransHdr2.Status::Released);
            TransHdr2.Modify(true);
        end;
        recIndent."Transfer Order No." := transHdr."No.";


        recIndent."Processed Date & time" := CurrentDateTime;
        recIndent."Processed By" := UserId;
        recIndent.Status := recIndent.Status::Processed;
        recIndent.Select := false;
        recIndent.Validate(Status);
        Commit();
        recIndent.Modify(true);
        //CurrPage.Update(true);



    end;

    procedure SendMail(SubIndentPO: Record "Sub Indent PO")
    var
        EmailCodeunit: Codeunit Email;
        Tempblob: Codeunit "Temp Blob";
        IsStream: InStream;
        OStream: OutStream;
        UserSetup: Record "User Setup";
        EmailMessage: Codeunit "Email Message";
        currentuser: Record "User Setup";
        MessageBody: Text;
        MailList: List of [text];
        RequestRunPage: text;

        RecRef: RecordRef;
        Subject: Text;
        SubIndentPO1: Record "Sub Indent PO";
        parma: Text;

        //Mahendra start
        TempPurchHead: Record "Purchase Header";
        IsStream1: InStream;
        OStream1: OutStream;
        TempReportSelection: Record "Report Selections";
        TempVend: Record Vendor;
        RecrefPurch: RecordRef;
    //Mahendra end

    begin
        // MailList.Add('neha.gupta78@in.ey.com'); mahendra
        Subject := 'Indent Purchase Order' + SubIndentPO."PO NO." + '';
        MessageBody := 'Hello, ' + '<br><br>' + 'You have received Indent PO ' + ' ' + 'from Heisetasse Beverages Pvt. Ltd.';
        MessageBody += '<br><br> Best Regards';
        Tempblob.CreateOutStream(OStream);
        SubIndentPO1.Reset();
        SubIndentPO1.SetRange("PO NO.", SubIndentPO."PO NO.");
        IF SubIndentPO1.FindLast() then;

        //Report.ExcelLayout(Report::"Sub-Indent PO List", OStream);
        Report.SaveAs(Report::"Sub-Indent PO List", SubIndentPO1."PO NO.", ReportFormat::Pdf, OStream);
        //Report.SaveAsExcel(Report::"Sub-Indent PO List", 'Indent PO List', SubIndentPO1);
        Tempblob.CreateInStream(IsStream);

        //mahendra start
        Tempblob.CreateOutStream(OStream1);
        TempPurchHead.Reset();
        TempPurchHead.SetRange("No.", SubIndentPO."PO NO.");
        IF TempPurchHead.FindFirst() Then;

        RecrefPurch.GetTable(TempPurchHead);

        IF TempVend.get(TempPurchHead."Buy-from Vendor No.") then;
        // IF TempVend."E-Mail" = '' then
        //  Error('Please enter the email on Vendor card to send indent notification');



        TempReportSelection.Reset();
        TempReportSelection.SetRange(Usage, TempReportSelection.Usage::"P.Order");
        IF TempReportSelection.FindFirst() Then;


        Report.SaveAs(TempReportSelection."Report ID", TempPurchHead."No.", ReportFormat::Pdf, OStream1, RecrefPurch);
        // Report.SaveAsPdf(TempReportSelection."Report ID", 'PurchaseOrder.pdf', TempPurchHead);
        Tempblob.CreateInStream(IsStream1);
        //Mahendra End
        IF TempVend."E-Mail" <> '' then //mahendra
        Begin

            //EmailMessage.Create(MailList, Subject, MessageBody, true); mahendra
            EmailMessage.Create(TempVend."E-Mail", Subject, MessageBody, true);

            EmailMessage.AddAttachment('Indent Purchase Order.xlsx', 'xlsx', IsStream);

            //mahendra
            EmailMessage.AddAttachment('Purchase Order.pdf', 'PDF', IsStream1);

            EmailCodeunit.Send(EmailMessage);
        end
        Else
            Message('Indent email has not been send as no mail id is define on vendor Card');

    end;

    var
        usersetup: Record "User Setup";

}