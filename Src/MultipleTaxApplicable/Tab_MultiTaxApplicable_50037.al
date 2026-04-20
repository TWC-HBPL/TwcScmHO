//AJ_Alle_11102023
table 50037 "Multiple Tax Applicable"
{
    DataClassification = ToBeClassified;

    fields
    {
        // field(50001; "Vendor"; Code[20])
        // {
        //     Caption = 'Vendor';
        //     TableRelation = Vendor."No.";
        // }
        field(50001; "Vendor"; Code[20])
        {
            Caption = 'Vendor';
            TableRelation = Vendor."No." where("Privacy Blocked" = const(false));
        }
        // field(50002; "Item"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = Item."No.";
        // }
        field(50002; "Item"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No." where(Blocked = const(false)); //
                                                                      // TableRelation = Item."No.";//PT-FBTSOLd Code
        }
        // field(50003; "GST Group Code"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "GST Group".Code;
        // }
        field(50003; "GST Group Code"; Code[20])//Jira ID-341
        {
            DataClassification = ToBeClassified;
            TableRelation = "GST Group".Code;
            trigger OnValidate()//PT-Fbts 20/04/2026
            var
                hsn: Record "HSN/SAC";
            begin
                if hsn.Get(Rec."GST Group Code") then
                    Rec."HSN/SAC CODE" := hsn.Code;
                // IF Rec."GST Group Code" = '' then
                //     Rec."HSN/SAC CODE" := '';
                if xRec."GST Group Code" <> "GST Group Code" then
                    Clear("HSN/SAC CODE");
            end;
        }
        field(50004; "HSN/SAC CODE"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HSN/SAC".Code where("GST Group Code" = field("GST Group Code"));
        }
        field(50005; StoreRegion; Code[20])//Jira ID-341
        {
            caption = 'Location Region';//Aashish
            TableRelation = MultiTaxApplicable;
        }
    }


    keys
    {
        // key(Key1; Vendor, Item)
        // {
        //     Clustered = true;
        // }
        key(Key1; Vendor, Item, "GST Group Code", "HSN/SAC CODE", StoreRegion)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        ValidateMandatoryFields;
    end;


    local procedure ValidateMandatoryFields()
    begin
        if Vendor = '' then
            Error('Vendor must not be blank.');
        if Item = '' then
            Error('Item must not be blank.');
        if "GST Group Code" = '' then
            Error('GST Group Code must not be blank.');
        if "HSN/SAC CODE" = '' then
            Error('HSN/SAC CODE must not be blank.');
        if StoreRegion = '' then
            Error('Store Region must not be blank.');
    end;

    var
        myInt: Integer;
        Purchaseline: Record "Purchase Line";

    local procedure IsNullOrEmpty(Value: Text): Boolean

    begin

        exit(DelChr(Value) = '');

    end;

}