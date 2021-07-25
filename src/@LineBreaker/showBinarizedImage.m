function this = showBinarizedImage(this)
    ax4 = this.UIAxes4;
    cla(ax4);
    imagesc(ax4,~this.CurrentBWImage);
    colormap(ax4,gray);
    title(ax4,'Binarized Image')
end
