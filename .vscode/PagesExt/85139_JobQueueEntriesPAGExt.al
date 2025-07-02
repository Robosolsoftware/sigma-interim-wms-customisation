pageextension 85139 JobQueueEntryExt extends "Job Queue Entries"
{
    actions
    {
        modify(RunInForeground)
        {
            trigger OnBeforeAction()
            var
                Usersetup: Record "User Setup";

            begin
                Usersetup.Reset();
                Usersetup.SetRange("User ID", UserId);
                if Usersetup.FindFirst() then begin
                    if Usersetup."Job Run" = false then begin
                        Error('You dont have the permission to run the job queue In Foreground');
                    end else begin
                        if Rec.Status = Rec.Status::"In Process" then
                            Error('Job is already in Progress.');
                        if Rec.Status = Rec.Status::Ready then
                            Error('First make Job Queue Hold.');
                    end;
                end else
                    Error('You dont have the permission to run the job queue In Foreground');
            end;
        }
    }
}