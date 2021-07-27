function this = notifyFileCompleted(this, filename_or_msg)
    if ~isempty(this.app)
        this.app.FileCompletedLabel.Text = filename_or_msg;
    else
        fprintf(filename_or_msg);
    end
    drawnow;
end