pageextension 50052 PostedTransfershipmentListext extends "Posted Transfer Shipments"
{
    layout
    {
        // Add changes to page layout here
        //PT-FBTS 03-07-2024
        addafter("No.")
        {
            field("Transfer Order No."; "Transfer Order No.")
            {
                ApplicationArea = all;
            }
            field("Requistion No."; "Requistion No.")
            {
                ApplicationArea = all;
            }
        }//PT-FBTS 03-07-2024
        addafter("Transfer-to Code") //PT-FBTS 21052024
        {
            field("Transfer-to Name"; Rec."Transfer-to Name")
            {
                ApplicationArea = all;
            }
            field("IRN Hash"; Rec."IRN Hash")
            {
                ApplicationArea = all;
            }
            field("E-Way Bill No."; Rec."E-Way Bill No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Posting Date")///PT-FBTS
        {
            field(SystemCreatedAt; SystemCreatedAt)
            {
                ApplicationArea = all;
            }
        }

        addafter("Transfer-from Code")//PT-FBTS 21052024
        {
            field("Transfer-from Name"; Rec."Transfer-from Name")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("&Print")
        {

            trigger OnBeforeAction()
            var
                TransferShipmentLine: Record "Transfer Shipment Line";
                Amount_l: Decimal;
                Location: Record Location;
                Location1: Record Location;
            begin
                if Location.Get(Rec."Transfer-from Code") then;
                if Location1.Get(Rec."Transfer-to Code") then;
                if Location."State Code" <> Location1."State Code" then begin
                    if (Rec."IRN Hash" = '') then
                        Error('E-invoice is Mandatory');
                    if (Rec."E-Way Bill No." = '') then
                        Error('E-waybill is Mandatory');
                end;


                if Location."State Code" = Location1."State Code" then begin
                    Clear(Amount_l);
                    TransferShipmentLine.Reset();
                    TransferShipmentLine.SetRange("Document No.", Rec."No.");
                    if TransferShipmentLine.FindSet() then
                        TransferShipmentLine.CalcSums(Amount);
                    Amount_l := TransferShipmentLine.Amount;
                    if Rec."E-Way Bill No." = '' then begin
                        if Amount_l > 50000 then
                            Error('E-way bill is Mandatory');
                    end;
                end;
            end;
        }
    }
    trigger OnOpenPage()
    var
        TempUserSetup: Record "User Setup";
    begin
        //mahendra
        IF TempUserSetup.Get(UserId) Then;
        IF TempUserSetup."Location Code" <> '' then Begin
            Rec.FilterGroup(2);
            Rec.setfilter(Rec."Transfer-from Code", '=%1', TempUserSetup."Location Code");
            Rec.FilterGroup(0);
        End;
        //end
    end;

    var
        myInt: Integer;
}