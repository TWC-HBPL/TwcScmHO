tableextension 50136 RetailICTHeaderExt extends "LSC Retail ICT Header"
{
    fields
    {
        field(50000; "HO ICT Entry"; Boolean)
        { }
        field(50001; "TransferCreated"; Boolean)
        { }
        field(50002; "Skip From Replication"; Boolean)
        { }
        field(50003; "FA ICT"; Boolean) //FBTS AA 180126
        { }
        field(50004; "Invoice Inventory ICT"; Boolean) //FBTS AA 180126
        { }
    }

    keys
    {
        key(SK1; "Source TableNo", "Date Of Status", "Dist. Location From", "Time Of Status")
        { }
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}