pageextension 50188 MyEon extends "Purch. Invoice Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Serial No."; Rec."Serial No.")
            { ApplicationArea = all; }
            field("PI Qty."; Rec."PI Qty.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("GRN Rate"; Rec."GRN Rate")
            {
                ApplicationArea = all;
                Editable = false;


            }

        }

        // modify(GetReceiptLines)
        // {
        //     trigger OnBeforeAction()
        //     var
        //         myInt: Integer;
        //     begin
        //         Message('hi');
        //     end;
        // }
    }

    var
        myInt: Integer;
}