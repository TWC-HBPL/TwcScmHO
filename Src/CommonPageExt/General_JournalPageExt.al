pageextension 50108 GeneralJournalPageExt extends "General Journal" //PT-FBTS 06-05-26
{
    layout
    {
        // Add changes to page layout here
        modify("Location Code")
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}