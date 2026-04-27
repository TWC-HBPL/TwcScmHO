pageextension 50000 PostedASSExtension extends "Posted Assembly Order"
{
    layout
    {
        addafter("Assemble to Order")
        {
            //PT-FBTS_Brand JIRAID-674
            field(Brand; Rec.Brand)
            {
                ApplicationArea = all;
            }


        }
    }

    actions
    {
        addafter("Undo Post")
        {

        }
    }

}