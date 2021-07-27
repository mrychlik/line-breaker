function this = notifyFileCompleted(this, filename)
    if ~isempty(this.app)
        this.app.FileCompletedLabel.Text = filename;
    else
        fprintf('File completed: %s', filename);
    end
end