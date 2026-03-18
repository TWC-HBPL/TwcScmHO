page 50692 "SKU Cost Update Log List"
{
    PageType = List;
    SourceTable = "SKU Cost Update Log";
    Caption = 'SKU Cost Update Log';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry DateTime"; Rec."Entry DateTime")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Old Unit Cost"; Rec."Old Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("New Unit Cost"; Rec."New Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;   // nice visual
                }
                field("Error Message"; "Error Message")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(DeleteLogs)
            {
                Caption = 'Delete Logs';
                Image = Delete;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to delete all logs?', false) then
                        Rec.DeleteAll();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Color coding for Status
        if Rec.Status = Rec.Status::Success then
            StatusStyle := 'Favorable'
        else
            StatusStyle := 'Unfavorable';
    end;

    var
        StatusStyle: Text;
}
