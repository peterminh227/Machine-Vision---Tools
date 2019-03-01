function p2clus = clean_clusnum(p2clus)
    max_clus = max(p2clus);
    incre = 1;
    while (incre < max_clus)
       
        mat = find(p2clus == incre);
        
        if isempty(mat)
            p2clus(find(p2clus > incre)) = ...
                p2clus(find(p2clus > incre)) - 1;
        end
        max_clus = max(p2clus);
        incre = incre + 1;
    end
end