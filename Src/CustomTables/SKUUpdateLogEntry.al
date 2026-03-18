table 50691 "SKU Cost Update Log"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Entry DateTime"; DateTime) { }
        field(3; "Location Code"; Code[10]) { }
        field(4; "Item No."; Code[20]) { }
        field(5; "Old Unit Cost"; Decimal) { }
        field(6; "New Unit Cost"; Decimal) { }
        field(7; Status; Option)
        {
            OptionMembers = Success,Failed;
        }
        field(8; "Error Message"; Text[250]) { }
        field(9; "Cost Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
