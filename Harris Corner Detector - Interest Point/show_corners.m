function show_corners(I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners, debug_corners)
    hold off;  

    if ~debug_corners
            imshow(I), hold on
            title('I');
            scatter(Corners(:,2),Corners(:,1), 'xr');
    else
        Ixx = Ixx / max(max(Ixx));
        Iyy = Iyy / max(max(Iyy));
        Ixy = Ixy / max(max(Ixy));
        Gxx = Gxx / max(max(Gxx));
        Gyy = Gyy / max(max(Gyy));
        Gxy = Gxy / max(max(Gxy));
        Hnonmax = Hnonmax / max(max(Gxy));
        Hdense = Hdense / max(max(Gxy));

        idx_subplot = 1;
        subplot(3,3,idx_subplot); idx_subplot = idx_subplot+1;
            imshow(I), hold on
            title('I');
            scatter(Corners(:,2),Corners(:,1), 'xr');
        subplot(3,3,idx_subplot); idx_subplot = idx_subplot+1;
            imshow(Ixx)
            title('Ixx');
        subplot(3,3,idx_subplot); idx_subplot = idx_subplot+1;
            imshow(Iyy)
            title('Iyy');
        subplot(3,3,idx_subplot); idx_subplot = idx_subplot+1;
            imshow(Ixy)
            title('Ixy');
        subplot(3,3,idx_subplot); idx_subplot = idx_subplot+1;
            imshow(Gxx)
            title('Gxx');
        subplot(3,3,idx_subplot); idx_subplot = idx_subplot+1;
            imshow(Gyy)
            title('Gyy');
        subplot(3,3,idx_subplot); idx_subplot = idx_subplot+1;
            imshow(Gxy)
            title('Gxy');
        subplot(3,3,idx_subplot); idx_subplot = idx_subplot+1;
            imshow(Hdense)
            title('Hdense');
        subplot(3,3,idx_subplot);
            imshow(Hnonmax)
            title('Hnonmax');
        figure(100)
        imshow(I), hold on
        title('$$\sigma_1 = 4$$','interpreter','latex');
        
        scatter(Corners(:,2),Corners(:,1), 'xr');
            drawnow();
    end
end