tableextension 50150 "Prod. Order LineExt" extends "Prod. Order Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Brand; Option)//PT-FBTS_Brand JIRAID-674
        {
            OptionMembers = " ","Third Wave","Third Rush";
            FieldClass = FlowField;
            CalcFormula = lookup("Production Order".Brand where("No." = field("Prod. Order No.")));
        }

        // field(50001; "TO Created Qty"; Decimal)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = sum("Transfer Line"."Quantity (Base)" where("Prod. order No" = field("Prod. Order No."), "Derived From Line No." = filter(0)));
        // }

        // field(50002; "TO Posted Qty"; Decimal)
        // {
        //     FieldClass = FlowField;
        //     CalcFormula = sum("Transfer Shipment Line"."Quantity (Base)" where("Prod. order No" = field("Prod. Order No.")));
        // }


    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}