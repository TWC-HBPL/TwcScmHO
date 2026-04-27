pageextension 50174 AssemblyOrder extends "Assembly Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("Assigned User ID")
        {
            field("Assembly Production"; "Assembly Production")
            {
                ApplicationArea = all;
            }
            //PT-FBTS_Brand JIRAID-674
            field(Brand; Rec.Brand)
            {
                ApplicationArea = all;
            }
        }
        modify("Location Code")
        {
            Editable = EditBool;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify("P&ost") //PT-FBTS-09/12/25
        {
            //PT-FBTS_Brand JIRAID-674FV
            trigger OnBeforeAction()

            var
                myInt: Integer;
            begin
                if Rec.Brand = Rec.Brand::" " then
                    Error('Please Check the Brand Code is Blank');
            end;

            trigger OnAfterAction()
            var
                myInt: Integer;
            begin
                CurrPage.Close();
            end;
        }
    }

    var
    trigger OnInsertRecord(dd: Boolean): Boolean //PT-FBTS 190225
    var
        myInt: Integer;
    begin
        Rec."Assembly Production" := true;
        // Rec.Modify();
    end;

    trigger OnAfterGetRecord()
    var
        UserSetup: Record "User Setup";

    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."Assembly Production" = false then begin
                EditBool := false
            end else
                if UserSetup."Assembly Production" = true then
                    EditBool := true
        end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        UserSetup: Record "User Setup";

    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."Assembly Production" = false then begin
                EditBool := false
            end else
                if UserSetup."Assembly Production" = true then
                    EditBool := true
        end;
    end;


    ///ICT 
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if Rec."Order Posted" then
            Editable := false
        else
            Editable := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."Order Posted" then
            Error('user cannot modify this Posted Order');
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec."Order Posted" then
            Error('user cannot modify this Posted Order');
    end;
    ///ICT 

    var
        EditBool: Boolean;
    // myInt: Integer;
}