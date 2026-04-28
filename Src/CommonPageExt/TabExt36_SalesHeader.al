tableextension 50145 saleshea extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        // field(50020; "PO No."; code[20])
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(50000; "Response Data"; Text[2048])
        // {

        // }
        field(50123; Brand; Option) //PT-FBTS_Brand JIRAID-674
        {
            Caption = 'Brand';
            OptionMembers = " ","Third Wave","Third Rush";
            OptionCaption = ' ,Third Wave,Third Rush';
            DataClassification = ToBeClassified;
        }

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