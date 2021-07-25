function plot(this)

%%location figures
    figure

    %1
    subplot(2,2,1);
    x = bboxesIntiial(:,1) + bboxesIntiial(:,3);
    y = bboxesIntiial(:,2) + bboxesIntiial(:,4)/2;
    scatter(x,y); title("begginign and middle of each legature")
    xlim([0 size(I,2)]);ylim([0 size(I,1)]); set(gca, 'YDir','reverse');grid on;daspect([1 1 1])

    %2
    subplot(2,2,2);
    x=bboxes(:,1)+bboxes(:,3);
    y=bboxes(:,2)+bboxes(:,4)/2;
    scatter(x,y);title("begginign and middle of each line")
    xlim([0 size(I,2)]);ylim([0 size(I,1)]);set(gca, 'YDir','reverse');grid on;daspect([1 1 1])

    %3
    subplot(2,2,3);
    for i=1:size(bboxesIntiial,1)
        rectangle('Position',bboxesIntiial(i,:));hold on
    end
    title("surrounding box of each legature")
    xlim([0 size(I,2)]);ylim([0 size(I,1)]);set(gca, 'YDir','reverse');grid on;daspect([1 1 1])

    %4
    subplot(2,2,4);
    for i=1:size(bboxes,1)
        rectangle('Position',bboxes(i,:));hold on
    end
    title("surrounding box of each line")
    xlim([0 size(I,2)]);ylim([0 size(I,1)]);set(gca, 'YDir','reverse');grid on;daspect([1 1 1])

    %%Hist figures
    figure
    subplot(2,2,1);hist(bboxesIntiial(:,3));title("width of each word")
    subplot(2,2,2);hist(bboxes(:,3))       ;title("width of each line")
    subplot(2,2,3);hist(bboxesIntiial(:,4));title("hight of each word")
    subplot(2,2,4);hist(bboxes(:,4))       ;title("hight of each line")


    %line by line
    results1 = ocr(I,bboxes,'TextLayout','Line','Language','Arabic');
    [results1.Text]
    %word by word
    results2 = ocr(I,bboxesIntiial,'TextLayout','Line','Language','Arabic');
    [results2.Text]
    %the whole page
    results3 = ocr(I,'TextLayout','Block','Language','Arabic');
    [results3.Text]

end
