tableextension 50187 SalesCrMemoHeaderTabExt extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50123; Brand; Option) //PT-FBTS_Brand JIRAID-674
        {
            Caption = 'Brand';
            OptionMembers = " ","Third Wave","Third Rush";
            OptionCaption = ' ,Third Wave,Third Rush';
            DataClassification = ToBeClassified;
        }
        // PT-FBTS 10-11-2025 RepCounter
        field(50013; "Replication Counter"; Integer)
        {
            Caption = 'Replication Counter';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                // Transaction: Record "LSC Transaction Header";
                Transaction: Record "Sales Cr.Memo Header";
                ClientSessionUtility: Codeunit "LSC Client Session Utility";
            begin
                Transaction.SetCurrentKey("Replication Counter");
                if Transaction.FindLast then
                    "Replication Counter" := Transaction."Replication Counter" + 1
                else
                    "Replication Counter" := 1;
            end;
        }
        // PT-FBTS 10-11-2025 RepCounter


    }
    keys
    {
        // Add changes to keys here
        key(sec; "Replication Counter") //PT-FBTS 10-11-2025 RepCounter
        {

        }
    }
    trigger OnInsert()
    var
        myInt: Integer;
    begin
        Validate("Replication Counter"); //PT-FBTS 10-11-2025 RepCounter
    end;

    trigger OnModify()
    var
        myInt: Integer;
    begin
        Validate("Replication Counter"); //PT-FBTS 10-11-2025 RepCounter
    end;


    var
        myInt: Integer;
}