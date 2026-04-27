tableextension 50170 AssemblyHeader extends "Assembly Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Assembly Production"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Order Posted"; Boolean) //PT-FBTS_Brand JIRAID-674
        { }//ICT
        field(50005; Brand; Option)
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
    trigger OnInsert() //PT-FBTS 190825
    var
        UserSetupRec: Record "User Setup";
    begin
        if UserSetupRec.Get(UserId) then
            Rec.Validate("Location Code", UserSetupRec."Location Code");
    end;

    var
        myInt: Integer;

}