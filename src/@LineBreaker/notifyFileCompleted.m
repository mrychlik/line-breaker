function this = notifyFileCompleted(this, filename_or_msg)
    if ~isempty(this.app)
        this.app.BatchProgressInfoLabel.Text = filename_or_msg;
    else
        fprintf("%s\n",filename_or_msg);
    end
    drawnow;
end